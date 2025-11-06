import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';
import 'package:netlab/dashboard/study/provider/chapter_quiz_notifier.dart';
import 'package:netlab/dashboard/study/provider/lesson_history_notifier.dart';
import 'package:netlab/dashboard/study/provider/lesson_status_notifier.dart';
import 'package:netlab/dashboard/study/provider/question_status_notifier.dart';
import 'package:netlab/dashboard/study/provider/study_time_notifier.dart';
import 'package:netlab/google_auth_keys.dart';

// Import your providers here
// import 'package:netlab/your_providers_path.dart';

// Service for handling Firebase backups
class FirebaseBackupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Save all progress to Firebase
  Future<void> saveProgress({
    required Map<String, dynamic> questionStatus,
    required Map<String, dynamic> lessonStatus,
    required Map<String, dynamic> chapterQuizStatus,
    required Map<String, dynamic> studyTime,
    required List<Map<String, dynamic>> lessonHistory,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user signed in');

    final backup = {
      'userId': user.uid,
      'email': user.email,
      'lastBackup': FieldValue.serverTimestamp(),
      'data': {
        'questionStatus': questionStatus,
        'lessonStatus': lessonStatus,
        'chapterQuizStatus': chapterQuizStatus,
        'studyTime': studyTime,
        'lessonHistory': lessonHistory,
      },
    };

    await _firestore.collection('user_backups').doc(user.uid).set(backup);
  }

  // Load progress from Firebase
  Future<Map<String, dynamic>?> loadProgress() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user signed in');

    final doc = await _firestore.collection('user_backups').doc(user.uid).get();

    if (!doc.exists) return null;

    final data = doc.data();
    return data?['data'] as Map<String, dynamic>?;
  }

  // Check if backup exists for current user
  Future<DateTime?> getLastBackupTime() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('user_backups').doc(user.uid).get();

    if (!doc.exists) return null;

    final timestamp = doc.data()?['lastBackup'] as Timestamp?;
    return timestamp?.toDate();
  }
}

// Provider for the backup service
final backupServiceProvider = Provider((ref) => FirebaseBackupService());

// Google Sign In configuration
final googleSignInProvider = Provider((ref) {
  return GoogleSignIn(
    params: const GoogleSignInParams(
      clientId: GoogleAuthKeys.clientId,
      clientSecret: GoogleAuthKeys.clientSecret,
    ),
  );
});

// Backup dialog widget
class BackupDialog extends ConsumerStatefulWidget {
  final bool isLoad; // true for load, false for save

  const BackupDialog({super.key, required this.isLoad});

  @override
  ConsumerState<BackupDialog> createState() => _BackupDialogState();
}

class _BackupDialogState extends ConsumerState<BackupDialog> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? _errorMessage;
  GoogleSignInCredentials? _currentUser;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  void _checkCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _currentUser = const GoogleSignInCredentials(
          idToken: '',
          accessToken: '',
        );
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final googleSignIn = ref.read(googleSignInProvider);
      _currentUser = await googleSignIn.signIn();

      if (_currentUser == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Sign in cancelled';
        });
        return;
      }

      await _auth.signInWithCredential(
        GoogleAuthProvider.credential(
          accessToken: _currentUser!.accessToken,
          idToken: _currentUser!.idToken,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error signing in: $e';
      });
    }
  }

  Future<void> _performBackupOperation() async {
    if (_auth.currentUser == null) {
      setState(() => _errorMessage = 'Please sign in first');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final backupService = ref.read(backupServiceProvider);

      if (widget.isLoad) {
        // Load progress
        final data = await backupService.loadProgress();

        if (data == null) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'No backup found for this account';
          });
          return;
        }

        // Restore all data to providers
        if (data['questionStatus'] != null) {
          await ref
              .read(questionStatusProvider.notifier)
              .restoreFromBackup(data['questionStatus']);
        }
        if (data['lessonStatus'] != null) {
          await ref
              .read(lessonStatusProvider.notifier)
              .restoreFromBackup(data['lessonStatus']);
        }
        if (data['chapterQuizStatus'] != null) {
          await ref
              .read(chapterQuizStatusProvider.notifier)
              .restoreFromBackup(data['chapterQuizStatus']);
        }
        if (data['studyTime'] != null) {
          await ref
              .read(studyTimeProvider.notifier)
              .restoreFromBackup(data['studyTime']);
        }
        if (data['lessonHistory'] != null) {
          await ref
              .read(lessonHistoryProvider.notifier)
              .restoreFromBackup(
                List<Map<String, dynamic>>.from(data['lessonHistory']),
              );
        }

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Progress loaded successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Save progress
        final questionStatus = await ref
            .read(questionStatusProvider.notifier)
            .exportData();
        final lessonStatus = await ref
            .read(lessonStatusProvider.notifier)
            .exportData();
        final chapterQuizStatus = await ref
            .read(chapterQuizStatusProvider.notifier)
            .exportData();
        final studyTime = await ref
            .read(studyTimeProvider.notifier)
            .exportData();
        final lessonHistory = await ref
            .read(lessonHistoryProvider.notifier)
            .exportData();

        await backupService.saveProgress(
          questionStatus: questionStatus,
          lessonStatus: lessonStatus,
          chapterQuizStatus: chapterQuizStatus,
          studyTime: studyTime,
          lessonHistory: lessonHistory,
        );

        // Sign out after saving
        await ref.read(googleSignInProvider).signOut();
        await _auth.signOut();

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Progress saved and signed out!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final isSignedIn = user != null;

    return AlertDialog(
      title: Text(widget.isLoad ? 'Load Progress' : 'Save Progress'),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.isLoad
                  ? 'Sign in to load your saved progress from the cloud.'
                  : 'Sign in to save your progress to the cloud. You will be signed out after saving.',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            if (isSignedIn) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Signed in as:',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            user.email ?? 'Unknown',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _performBackupOperation,
                icon: Icon(widget.isLoad ? Icons.download : Icons.upload),
                label: Text(widget.isLoad ? 'Load Now' : 'Save Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.isLoad ? Colors.blue : Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ] else ...[
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _signInWithGoogle,
                icon: const Icon(Icons.login),
                label: const Text('Sign In with Google'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red.shade900, fontSize: 12),
                ),
              ),
            ],
            if (_isLoading) ...[
              const SizedBox(height: 12),
              const Center(child: CircularProgressIndicator()),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
