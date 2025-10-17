import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:netlab/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FirebaseTestScreen(),
    );
  }
}

class FirebaseTestScreen extends StatefulWidget {
  const FirebaseTestScreen({super.key});

  @override
  State<FirebaseTestScreen> createState() => _FirebaseTestScreenState();
}

class _FirebaseTestScreenState extends State<FirebaseTestScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  GoogleSignInAccount? _currentUser;
  User? _firebaseUser;
  String _status = 'Not signed in';
  bool _isLoading = false;
  String? _firestoreTestResult;
  bool _googleSignInInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeGoogleSignIn();

    _auth.authStateChanges().listen((User? user) {
      setState(() {
        _firebaseUser = user;
        if (user != null) {
          _status = 'Signed in as ${user.email}';
        } else {
          _status = 'Not signed in';
        }
      });
    });
  }

  Future<void> _initializeGoogleSignIn() async {
    try {
      await _googleSignIn.initialize();

      // Listen to authentication events
      _googleSignIn.authenticationEvents.listen((event) {
        setState(() {
          _currentUser = switch (event) {
            GoogleSignInAuthenticationEventSignIn() => event.user,
            _ => null,
          };
        });
      });

      setState(() {
        _googleSignInInitialized = true;
      });
    } catch (e) {
      setState(() {
        _status = 'Error initializing Google Sign-In: $e';
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    if (!_googleSignInInitialized) {
      setState(() {
        _status = 'Google Sign-In is still initializing...';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _status = 'Signing in...';
    });

    try {
      await _googleSignIn.authenticate();

      if (_currentUser == null) {
        setState(() {
          _status = 'Sign in cancelled';
          _isLoading = false;
        });
        return;
      }

      // Get authentication tokens
      final googleAuth = _currentUser!.authentication;

      // Get authorization for access token
      final authorization = await _currentUser!.authorizationClient
          .authorizationForScopes(['email', 'profile']);

      if (authorization == null) {
        setState(() {
          _status = 'Failed to get authorization';
          _isLoading = false;
        });
        return;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: authorization.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      setState(() {
        _status = 'Successfully signed in!';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _status = 'Error signing in: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _signOut() async {
    setState(() {
      _isLoading = true;
      _status = 'Signing out...';
    });

    try {
      await _googleSignIn.signOut();
      await _auth.signOut();

      setState(() {
        _status = 'Signed out successfully';
        _isLoading = false;
        _firestoreTestResult = null;
        _currentUser = null;
      });
    } catch (e) {
      setState(() {
        _status = 'Error signing out: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _testFirestore() async {
    if (_firebaseUser == null) {
      setState(() {
        _firestoreTestResult = 'Please sign in first';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _firestoreTestResult = 'Testing Firestore...';
    });

    try {
      // Write test data
      final docRef = _firestore
          .collection('test')
          .doc('test_${DateTime.now().millisecondsSinceEpoch}');
      await docRef.set({
        'userId': _firebaseUser!.uid,
        'email': _firebaseUser!.email,
        'timestamp': FieldValue.serverTimestamp(),
        'message': 'Test from Flutter app',
      });

      // Read the data back
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        setState(() {
          _firestoreTestResult =
              'SUCCESS!\n\nWrite & Read test passed.\n\nData: ${data.toString()}';
          _isLoading = false;
        });
      } else {
        setState(() {
          _firestoreTestResult = 'Document was written but could not be read';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _firestoreTestResult = 'ERROR: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Test')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Authentication Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_status),
                    if (!_googleSignInInitialized)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Initializing Google Sign-In...',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    if (_firebaseUser != null) ...[
                      const SizedBox(height: 8),
                      Text('UID: ${_firebaseUser!.uid}'),
                      if (_firebaseUser!.photoURL != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              _firebaseUser!.photoURL!,
                            ),
                            radius: 30,
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_firebaseUser == null)
              ElevatedButton.icon(
                onPressed: (_isLoading || !_googleSignInInitialized)
                    ? null
                    : _signInWithGoogle,
                icon: const Icon(Icons.login),
                label: const Text('Sign In with Google'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              )
            else
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _signOut,
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: (_isLoading || _firebaseUser == null)
                  ? null
                  : _testFirestore,
              icon: const Icon(Icons.cloud),
              label: const Text('Test Firestore Write & Read'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.green,
              ),
            ),
            if (_firestoreTestResult != null) ...[
              const SizedBox(height: 16),
              Card(
                color: _firestoreTestResult!.startsWith('SUCCESS')
                    ? Colors.green[50]
                    : Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Firestore Test Result',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(_firestoreTestResult!),
                    ],
                  ),
                ),
              ),
            ],
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
