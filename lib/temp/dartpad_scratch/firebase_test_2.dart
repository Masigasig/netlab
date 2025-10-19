import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';

import 'package:netlab/firebase_options.dart';
import 'package:netlab/google_auth_keys.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Firebase Test',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: const FirebaseTestScreen(),
  );
}

class FirebaseTestScreen extends StatefulWidget {
  const FirebaseTestScreen({super.key});

  @override
  State<FirebaseTestScreen> createState() => _FirebaseTestScreenState();
}

class _FirebaseTestScreenState extends State<FirebaseTestScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    params: const GoogleSignInParams(
      clientId: GoogleAuthKeys.clientId,
      clientSecret: GoogleAuthKeys.clientSecret,
    ),
  );

  GoogleSignInCredentials? _currentUser;
  User? _firebaseUser;
  String _status = 'Not signed in';
  bool _isLoading = false;
  String? _firestoreTestResult;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _set({bool? loading, String? status, String? firestoreResult}) {
    if (!mounted) return;
    setState(() {
      if (loading != null) _isLoading = loading;
      if (status != null) _status = status;
      if (firestoreResult != null) _firestoreTestResult = firestoreResult;
    });
  }

  Future<void> _init() async {
    // try silent sign-in and wire up listeners
    _googleSignIn.silentSignIn();
    _auth.authStateChanges().listen((user) {
      _firebaseUser = user;
      _set(
        status: user != null ? 'Signed in as ${user.email}' : 'Not signed in',
      );
    });

    _googleSignIn.authenticationState.listen((creds) async {
      _currentUser = creds;
      if (creds != null && _auth.currentUser == null) {
        try {
          await _auth.signInWithCredential(
            GoogleAuthProvider.credential(
              accessToken: creds.accessToken,
              idToken: creds.idToken,
            ),
          );
        } catch (_) {}
      } else if (creds == null && _auth.currentUser != null) {
        await _auth.signOut();
      }
    });
  }

  Future<void> _signInWithGoogle() async {
    _set(loading: true, status: 'Signing in...');
    try {
      _currentUser = await _googleSignIn.signIn();
      if (_currentUser == null) {
        _set(loading: false, status: 'Sign in cancelled');
        return;
      }
      await _auth.signInWithCredential(
        GoogleAuthProvider.credential(
          accessToken: _currentUser!.accessToken,
          idToken: _currentUser!.idToken,
        ),
      );
      _set(loading: false, status: 'Successfully signed in!');
    } catch (e) {
      _set(loading: false, status: 'Error signing in: $e');
    }
  }

  Future<void> _signOut() async {
    _set(loading: true, status: 'Signing out...');
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      _set(
        loading: false,
        status: 'Signed out successfully',
        firestoreResult: null,
      );
      _currentUser = null;
    } catch (e) {
      _set(loading: false, status: 'Error signing out: $e');
    }
  }

  Future<void> _testFirestore() async {
    if (_firebaseUser == null) {
      _set(firestoreResult: 'Please sign in first');
      return;
    }
    _set(loading: true, firestoreResult: 'Testing Firestore...');
    try {
      final docRef = _firestore
          .collection('test')
          .doc('test_${DateTime.now().millisecondsSinceEpoch}');
      await docRef.set({
        'userId': _firebaseUser!.uid,
        'email': _firebaseUser!.email,
        'timestamp': FieldValue.serverTimestamp(),
        'message': 'Test from Flutter app',
      });

      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        _set(
          loading: false,
          firestoreResult: 'SUCCESS!\n\nData: ${docSnapshot.data()}',
        );
      } else {
        _set(
          loading: false,
          firestoreResult: 'Document was written but could not be read',
        );
      }
    } catch (e) {
      _set(loading: false, firestoreResult: 'ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final signedIn = _firebaseUser != null;
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Test')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
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
                    if (signedIn) ...[
                      const SizedBox(height: 8),
                      Text('UID: ${_firebaseUser!.uid}'),
                      if (_firebaseUser!.photoURL != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
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
            if (!signedIn)
              kIsWeb
                  ? (_googleSignIn.signInButton() ?? const SizedBox.shrink())
                  : ElevatedButton.icon(
                      onPressed: _isLoading ? null : _signInWithGoogle,
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
              onPressed: (_isLoading || !signedIn) ? null : _testFirestore,
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
                  padding: const EdgeInsets.all(16),
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
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
