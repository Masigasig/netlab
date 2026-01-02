import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:netlab/core/provider/async_shared_prefs_provider.dart';
import 'package:netlab/dashboard/study/provider/material_details_notifier.dart';

final lessonStatusProvider =
    NotifierProvider<LessonStatusNotifier, Map<String, bool>>(
      LessonStatusNotifier.new,
    );

class LessonStatusNotifier extends Notifier<Map<String, bool>> {
  static const _prefix = 'lesson_status_';
  late final SharedPreferencesAsync _prefs;

  @override
  Map<String, bool> build() {
    _prefs = ref.read(asyncSharedPrefsProvider);
    return {};
  }

  Future<void> loadStatuses() async {
    final material = ref.read(materialDetailProvider);
    final Map<String, bool> loaded = {};

    for (final chapterEntry in material.entries) {
      final chapterId = chapterEntry.key;
      final lessons = chapterEntry.value['lessons'] as Map<String, dynamic>;

      for (final lessonEntry in lessons.entries) {
        final lessonId = lessonEntry.key;
        final key = '${chapterId}_$lessonId';

        final status = await _prefs.getBool('$_prefix$key') ?? false;
        loaded[key] = status;
      }
    }

    state = loaded;
  }

  Future<void> setLessonCompleted({
    required String chapterId,
    required String lessonId,
    required bool isCompleted,
  }) async {
    final key = '${chapterId}_$lessonId';
    state = {...state, key: isCompleted};
    await _prefs.setBool('$_prefix$key', isCompleted);
  }

  bool isLessonCompleted(String chapterId, String lessonId) {
    final key = '${chapterId}_$lessonId';
    return state[key] ?? false;
  }

  int getCompletedLessonCount() {
    return state.values.where((isCompleted) => isCompleted).length;
  }

  int getTotalLessonCount() {
    return state.length;
  }

  int getTotalLessonCountInChapter(String chapterId) {
    final material = ref.read(materialDetailProvider);
    final lessons = material[chapterId]?['lessons'] as Map<String, dynamic>?;

    return lessons?.length ?? 0;
  }

  int getCompletedLessonCountInChapter(String chapterId) {
    final material = ref.read(materialDetailProvider);
    final lessons = material[chapterId]?['lessons'] as Map<String, dynamic>?;

    if (lessons == null) return 0;

    int count = 0;
    for (final lessonId in lessons.keys) {
      final key = '${chapterId}_$lessonId';
      if (state[key] == true) {
        count++;
      }
    }
    return count;
  }

  Future<void> resetAll() async {
    final material = ref.read(materialDetailProvider);
    final Map<String, bool> resetState = {};

    for (final chapterEntry in material.entries) {
      final chapterId = chapterEntry.key;
      final lessons = chapterEntry.value['lessons'] as Map<String, dynamic>;

      for (final lessonEntry in lessons.entries) {
        final lessonId = lessonEntry.key;
        final key = '${chapterId}_$lessonId';

        resetState[key] = false;
        await _prefs.setBool('$_prefix$key', false);
      }
    }

    state = resetState;
  }

  Future<Map<String, dynamic>> exportData() async {
    return {'lessons': state};
  }

  Future<void> restoreFromBackup(Map<String, dynamic> data) async {
    final lessons = data['lessons'] as Map<String, dynamic>?;
    if (lessons == null) return;

    final Map<String, bool> restored = {};

    for (final entry in lessons.entries) {
      final key = entry.key;
      final isCompleted = entry.value as bool? ?? false;

      restored[key] = isCompleted;
      await _prefs.setBool('$_prefix$key', isCompleted);
    }

    state = restored;
  }
}
