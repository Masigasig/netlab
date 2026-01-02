import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';

import 'package:netlab/google_auth_keys.dart';

final googleSignInProvider = Provider((ref) {
  return GoogleSignIn(
    params: const GoogleSignInParams(
      clientId: GoogleAuthKeys.clientId,
      clientSecret: GoogleAuthKeys.clientSecret,
    ),
  );
});

final backupServiceProvider = Provider((ref) => FirebaseBackupService());

class FirebaseBackupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Future<Map<String, dynamic>?> loadProgress() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user signed in');

    final doc = await _firestore.collection('user_backups').doc(user.uid).get();

    if (!doc.exists) return null;

    final data = doc.data();
    return data?['data'] as Map<String, dynamic>?;
  }

  Future<DateTime?> getLastBackupTime() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('user_backups').doc(user.uid).get();

    if (!doc.exists) return null;

    final timestamp = doc.data()?['lastBackup'] as Timestamp?;
    return timestamp?.toDate();
  }
}
