import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';

import 'package:netlab/dashboard/study/provider/chapter_quiz_notifier.dart';
import 'package:netlab/dashboard/study/provider/lesson_history_notifier.dart';
import 'package:netlab/dashboard/study/provider/lesson_status_notifier.dart';
import 'package:netlab/dashboard/study/provider/question_status_notifier.dart';
import 'package:netlab/dashboard/study/provider/study_time_notifier.dart';
import 'package:netlab/settings/providers/firebase_backup_service.dart';

class LoadDialog extends ConsumerStatefulWidget {
  const LoadDialog({super.key});

  @override
  ConsumerState<LoadDialog> createState() => _LoadDialogState();
}

class _LoadDialogState extends ConsumerState<LoadDialog> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? _errorMessage;
  GoogleSignInCredentials? _currentUser;

  @override
  void initState() {
    super.initState();
    _signOutUser();

    // Listen for Google Sign-In state changes (web button emits here)
    ref.read(googleSignInProvider).authenticationState.listen((creds) async {
      _currentUser = creds;

      if (creds != null && _auth.currentUser == null) {
        try {
          await _auth.signInWithCredential(
            GoogleAuthProvider.credential(
              accessToken: creds.accessToken,
              idToken: creds.idToken,
            ),
          );
        } catch (e) {
          debugPrint('Error linking Google creds to Firebase: $e');
        }
      } else if (creds == null && _auth.currentUser != null) {
        await _auth.signOut();
      }

      if (mounted) setState(() {});
    });
  }

  Future<void> _signOutUser() async {
    try {
      await ref.read(googleSignInProvider).signOut();
      await _auth.signOut();
      if (mounted) {
        setState(() {
          _currentUser = null;
        });
      }
    } catch (e) {
      debugPrint('Sign out error: $e');
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

  Future<void> _loadFromCloud() async {
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

      final data = await backupService.loadProgress();

      if (data == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'No backup found for this account';
        });
        return;
      }

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

      await ref.read(googleSignInProvider).signOut();
      await _auth.signOut();

      if (mounted) {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Progress loaded successfully'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
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
    final googleSignIn = ref.read(googleSignInProvider);

    return AlertDialog(
      title: const Text('Load Progress'),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Sign in to load your progress from the cloud.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            if (isSignedIn) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
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
                onPressed: _isLoading ? null : _loadFromCloud,
                icon: const Icon(Icons.download),
                label: const Text('Load Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ] else ...[
              if (kIsWeb)
                googleSignIn.signInButton()!
              else
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
