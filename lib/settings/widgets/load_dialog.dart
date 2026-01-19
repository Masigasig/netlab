import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:netlab/core/constants/app_text.dart';
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
            title: Text(
              'Success',
              style: AppTextStyles.forSurface(
                AppTextStyles.headerMedium,
                context,
              ),
            ),
            content: Text(
              'Progress loaded successfully',
              style: AppTextStyles.forSurface(
                AppTextStyles.bodyMedium,
                context,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK', style: AppTextStyles.buttonMedium),
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
      title: Text(
        'Load Progress',
        style: AppTextStyles.forSurface(
          AppTextStyles.headerLarge.copyWith(fontSize: 26),
          context,
        ),
      ),
      content: SizedBox(
        width: 300,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Sign in to load your progress from the cloud.',
                  style: AppTextStyles.forSurface(
                    AppTextStyles.bodyMedium,
                    context,
                  ),
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
                              Text(
                                'Signed in as:',
                                style: AppTextStyles.forSurface(
                                  AppTextStyles.subtitleMedium,
                                  context,
                                ),
                              ),
                              Text(
                                user.email ?? 'Unknown',
                                style: AppTextStyles.forSurface(
                                  AppTextStyles.bodySmall,
                                  context,
                                ),
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
                    label: Text('Load Now', style: AppTextStyles.buttonMedium),
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
                      icon: const HugeIcon(icon: HugeIcons.strokeRoundedGoogle),
                      label: Text(
                        'Sign In with Google',
                        style: AppTextStyles.buttonMedium,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
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
                      style: AppTextStyles.withColor(
                        AppTextStyles.bodySmall,
                        Colors.red.shade900,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (_isLoading)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(51),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text('Cancel', style: AppTextStyles.buttonMedium),
        ),
      ],
    );
  }
}
