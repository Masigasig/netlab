import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netlab/core/utils/async_shared_prefs_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

final studyTimeProvider = NotifierProvider<StudyTimeNotifier, String>(
  StudyTimeNotifier.new,
);

class StudyTimeNotifier extends Notifier<String> {
  static const _key = 'total_study_time';
  late final SharedPreferencesAsync _prefs;

  @override
  String build() {
    _prefs = ref.read(asyncSharedPrefsProvider);
    return '0';
  }

  Future<void> loadTime() async {
    final time = await _prefs.getString(_key) ?? '0';
    state = time;
  }

  Future<void> addTime(int seconds) async {
    final current = int.tryParse(state) ?? 0;
    final updated = current + seconds;
    state = updated.toString();
    await _prefs.setString(_key, state);
  }

  Future<void> reset() async {
    state = '0';
    await _prefs.setString(_key, '0');
  }

  String getFormattedTime() {
    final totalSeconds = int.tryParse(state) ?? 0;

    final days = totalSeconds ~/ 86400;
    final hours = (totalSeconds % 86400) ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    if (days > 0) {
      return '${days}d ${hours}h';
    } else if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}
