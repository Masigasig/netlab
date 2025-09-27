import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const String _prefixChapter = 'chapter_progress_';
  static const String _prefixStudyTime = 'study_time_';
  static const String _lastStudyTimeKey = 'last_study_time';

  static Future<void> markChapterAsCompleted(String topicId, String moduleId, {bool completed = true}) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefixChapter${topicId}_$moduleId';
    // print('Marking chapter for topic: $topicId, module: $moduleId as ${completed ? "completed" : "incomplete"} with key: $key');
    await prefs.setBool(key, completed);
    
    // Update last study time when marking as complete
    if (completed) {
      await prefs.setString(_lastStudyTimeKey, DateTime.now().toIso8601String());
    }
    
    // Verify the save
    // final saved = await prefs.getBool(key);
    // print('Verified save for $key: $saved');
    // print('All keys in SharedPreferences: ${prefs.getKeys()}');
  }

  static Future<bool> isChapterCompleted(String topicId, String moduleId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefixChapter${topicId}_$moduleId';
    final completed = prefs.getBool(key) ?? false;
    //print('Checking completion for topic: $topicId, module: $moduleId = $completed (key: $key)');
    return completed;
  }

  static Future<List<String>> getCompletedChaptersByTopic(String topicId) async {
    final prefs = await SharedPreferences.getInstance();
    final prefix = '$_prefixChapter$topicId';
    
    final completedChapters = prefs.getKeys()
        .where((key) => key.startsWith(prefix))
        .where((key) => prefs.getBool(key) ?? false)
        .map((key) => key.substring(prefix.length + 1)) // +1 to skip the underscore
        .toList();
    
    // print('Completed chapters for topic $topicId: $completedChapters');
    return completedChapters;
  }

  static Future<void> updateStudyTime(String topicId, String moduleId, int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefixStudyTime${topicId}_$moduleId';
    final currentTime = prefs.getInt(key) ?? 0;
    await prefs.setInt(key, currentTime + minutes);
    
    // Update last study time
    await prefs.setString(_lastStudyTimeKey, DateTime.now().toIso8601String());
  }

  static Future<DateTime?> getLastStudyTime() async {
    final prefs = await SharedPreferences.getInstance();
    final lastStudyStr = prefs.getString(_lastStudyTimeKey);
    return lastStudyStr != null ? DateTime.parse(lastStudyStr) : null;
  }

  static Future<int> getTopicStudyTime(String topicId) async {
    final prefs = await SharedPreferences.getInstance();
    final totalMinutes = prefs.getKeys()
        .where((key) => key.startsWith('$_prefixStudyTime$topicId'))
        .fold<int>(0, (sum, key) => sum + (prefs.getInt(key) ?? 0));
    return totalMinutes;
  }

  static Future<int> getTotalStudyTime() async {
    final prefs = await SharedPreferences.getInstance();
    final totalMinutes = prefs.getKeys()
        .where((key) => key.startsWith(_prefixStudyTime))
        .fold<int>(0, (sum, key) => sum + (prefs.getInt(key) ?? 0));
    return totalMinutes;
  }

  static Future<void> resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys()
        .where((key) => 
            key.startsWith(_prefixChapter) || 
            key.startsWith(_prefixStudyTime) ||
            key == _lastStudyTimeKey)
        .toList();
    
    for (final key in keys) {
      await prefs.remove(key);
    }
    //print('Reset all progress');
  }
}