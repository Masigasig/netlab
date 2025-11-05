import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netlab/core/utils/async_shared_prefs_notifier.dart';
import 'package:netlab/dashboard/study/provider/material_details_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

final chapterQuizStatusProvider =
    NotifierProvider<ChapterQuizStatusNotifier, Map<String, bool>>(
      ChapterQuizStatusNotifier.new,
    );

class ChapterQuizStatusNotifier extends Notifier<Map<String, bool>> {
  static const _prefix = 'chapter_quiz_status_';
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
      final status = await _prefs.getBool('$_prefix$chapterId') ?? false;
      loaded[chapterId] = status;
    }

    state = loaded;
  }

  Future<void> setChapterQuizCompleted({
    required String chapterId,
    required bool isCompleted,
  }) async {
    state = {...state, chapterId: isCompleted};
    await _prefs.setBool('$_prefix$chapterId', isCompleted);
  }

  bool isChapterQuizCompleted(String chapterId) {
    return state[chapterId] ?? false;
  }

  int getCompletedChapterCount() {
    return state.values.where((isCompleted) => isCompleted).length;
  }

  int getTotalChapterCount() {
    return state.length;
  }

  Future<void> resetAll() async {
    final material = ref.read(materialDetailProvider);
    final Map<String, bool> resetState = {};

    for (final chapterEntry in material.entries) {
      final chapterId = chapterEntry.key;
      resetState[chapterId] = false;
      await _prefs.setBool('$_prefix$chapterId', false);
    }

    state = resetState;
  }
}
