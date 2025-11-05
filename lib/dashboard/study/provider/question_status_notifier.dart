import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netlab/core/utils/async_shared_prefs_notifier.dart';
import 'package:netlab/dashboard/study/provider/material_details_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

final questionStatusProvider =
    NotifierProvider<QuestionStatusNotifier, Map<String, Map<String, String>>>(
      QuestionStatusNotifier.new,
    );

class QuestionStatusNotifier
    extends Notifier<Map<String, Map<String, String>>> {
  static const _prefix = 'question_meta_';
  late final SharedPreferencesAsync _prefs;

  @override
  Map<String, Map<String, String>> build() {
    _prefs = ref.read(asyncSharedPrefsProvider);
    return {};
  }

  Future<void> loadStatuses() async {
    final material = ref.read(materialDetailProvider);
    final Map<String, Map<String, String>> loaded = {};

    for (final chapterEntry in material.entries) {
      final chapterId = chapterEntry.key;
      final lessons = chapterEntry.value['lessons'] as Map<String, dynamic>;

      for (final lessonEntry in lessons.entries) {
        final lessonId = lessonEntry.key;
        final questions =
            lessonEntry.value['questions'] as Map<String, dynamic>;

        for (final questionEntry in questions.entries) {
          final questionId = questionEntry.key;
          final key = '${chapterId}_${lessonId}_$questionId';

          final status =
              await _prefs.getString('$_prefix${key}_status') ?? 'unanswered';
          final time = await _prefs.getString('$_prefix${key}_time') ?? '0';

          loaded[key] = {'status': status, 'time': time};
        }
      }
    }

    state = loaded;
  }

  Future<void> setStatus({
    required String chapterId,
    required String lessonId,
    required String questionId,
    required String status,
    required int timeTaken,
  }) async {
    final key = '${chapterId}_${lessonId}_$questionId';
    final timeStr = timeTaken.toString();

    state = {
      ...state,
      key: {'status': status, 'time': timeStr},
    };

    await _prefs.setString('$_prefix${key}_status', status);
    await _prefs.setString('$_prefix${key}_time', timeStr);
  }

  Future<void> reset() async {
    final material = ref.read(materialDetailProvider);
    final Map<String, Map<String, String>> resetState = {};

    for (final chapterEntry in material.entries) {
      final chapterId = chapterEntry.key;
      final lessons = chapterEntry.value['lessons'] as Map<String, dynamic>;

      for (final lessonEntry in lessons.entries) {
        final lessonId = lessonEntry.key;
        final questions =
            lessonEntry.value['questions'] as Map<String, dynamic>;

        for (final questionEntry in questions.entries) {
          final questionId = questionEntry.key;
          final key = '${chapterId}_${lessonId}_$questionId';

          // Reset in memory
          resetState[key] = {'status': 'unanswered', 'time': '0'};

          // Reset in SharedPreferences
          await _prefs.setString('$_prefix${key}_status', 'unanswered');
          await _prefs.setString('$_prefix${key}_time', '0');
        }
      }
    }

    state = resetState;
  }

  Map<String, int> getQuestionStats() {
    int total = state.length;
    int correct = 0;
    int incorrect = 0;
    int unanswered = 0;

    for (final meta in state.values) {
      final status = meta['status'];
      if (status == 'correct') {
        correct++;
      } else if (status == 'incorrect') {
        incorrect++;
      } else {
        unanswered++;
      }
    }

    return {
      'total': total,
      'correct': correct,
      'incorrect': incorrect,
      'unanswered': unanswered,
    };
  }

  double getAverageAnswerTime() {
    int totalTime = 0;
    int answeredCount = 0;

    for (final meta in state.values) {
      final timeStr = meta['time'];
      final time = int.tryParse(timeStr ?? '0') ?? 0;

      if (time > 0) {
        totalTime += time;
        answeredCount++;
      }
    }

    if (answeredCount == 0) return 0.0;
    return totalTime / answeredCount;
  }
}
