import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netlab/core/utils/async_shared_prefs_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

final lessonHistoryProvider =
    NotifierProvider<LessonHistoryNotifier, List<Map<String, String>>>(
      LessonHistoryNotifier.new,
    );

class LessonHistoryNotifier extends Notifier<List<Map<String, String>>> {
  static const _key = 'lesson_history';
  static const _maxLength = 5;

  late final SharedPreferencesAsync _prefs;

  @override
  List<Map<String, String>> build() {
    _prefs = ref.read(asyncSharedPrefsProvider);
    return [];
  }

  Future<void> loadHistory() async {
    final rawList = await _prefs.getStringList(_key) ?? [];
    final parsed = rawList.map((entry) {
      final parts = entry.split('|');
      return {
        'chapterId': parts[0],
        'lessonId': parts[1],
        'timestamp': parts.length > 2 ? parts[2] : '',
      };
    }).toList();

    state = parsed;
  }

  Future<void> addToHistory(String chapterId, String lessonId) async {
    final newItem = {
      'chapterId': chapterId,
      'lessonId': lessonId,
      'timestamp': DateTime.now().toIso8601String(),
    };

    state = state
        .where(
          (item) =>
              item['chapterId'] != chapterId || item['lessonId'] != lessonId,
        )
        .toList();

    state = [newItem, ...state];

    if (state.length > _maxLength) {
      state = state.sublist(0, _maxLength);
    }

    final encoded = state
        .map(
          (item) =>
              '${item['chapterId']}|${item['lessonId']}|${item['timestamp']}',
        )
        .toList();
    await _prefs.setStringList(_key, encoded);
  }

  Future<void> clearHistory() async {
    state = [];
    await _prefs.remove(_key);
  }

  Future<List<Map<String, dynamic>>> exportData() async {
    return state.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  Future<void> restoreFromBackup(List<Map<String, dynamic>> data) async {
    final List<Map<String, String>> restored = data.map((item) {
      return {
        'chapterId': item['chapterId'] as String? ?? '',
        'lessonId': item['lessonId'] as String? ?? '',
        'timestamp': item['timestamp'] as String? ?? '',
      };
    }).toList();

    state = restored;

    final encoded = restored
        .map(
          (item) =>
              '${item['chapterId']}|${item['lessonId']}|${item['timestamp']}',
        )
        .toList();
    await _prefs.setStringList(_key, encoded);
  }
}
