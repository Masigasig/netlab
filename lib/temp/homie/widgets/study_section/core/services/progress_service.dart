import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const String _prefixChapter = 'chapter_progress_';
  static const String _prefixStudyTime = 'study_time_';
  static const String _lastStudyTimeKey = 'last_study_time';
  static const String _prefixQuizScore = 'quiz_score_';
  static const String _prefixQuizAttempts = 'quiz_attempts_';
  static const String _prefixQuizAnswer = 'quiz_answer_';
  static const String _prefixCompletionTime = 'completion_time_';
  static const String _studyDatesKey = 'study_dates';
  static const String _totalChaptersKey = 'total_chapters_';

  static Future<void> setTotalChaptersByTopic(String topicId, int total) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${_totalChaptersKey}$topicId', total);
  }

  static Future<int> getTotalChaptersByTopic(String topicId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('${_totalChaptersKey}$topicId') ?? 0;
  }

  static Future<void> markChapterAsCompleted(
    String topicId,
    String moduleId, {
    bool completed = true,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefixChapter${topicId}_$moduleId';
    await prefs.setBool(key, completed);

    if (completed) {
      // Save completion timestamp
      final timestampKey = '$_prefixCompletionTime${topicId}_$moduleId';
      await prefs.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);

      // Update last study time
      await prefs.setString(
        _lastStudyTimeKey,
        DateTime.now().toIso8601String(),
      );

      // Update study dates for streak calculation
      await _updateLastStudyDate();
    } else {
      // If uncompleting, remove timestamp
      final timestampKey = '$_prefixCompletionTime${topicId}_$moduleId';
      await prefs.remove(timestampKey);
    }
  }

  // Check if chapter is completed
  static Future<bool> isChapterCompleted(
    String topicId,
    String moduleId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefixChapter${topicId}_$moduleId';
    return prefs.getBool(key) ?? false;
  }

  // Get all completed chapters for a topic
  static Future<List<String>> getCompletedChaptersByTopic(
    String topicId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final prefix = '$_prefixChapter$topicId';

    final completedChapters = prefs
        .getKeys()
        .where((key) => key.startsWith(prefix))
        .where((key) => prefs.getBool(key) ?? false)
        .map((key) => key.substring(prefix.length + 1))
        .toList();

    return completedChapters;
  }

  // Update study time (minutes)
  static Future<void> updateStudyTime(
    String topicId,
    String moduleId,
    int minutes,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefixStudyTime${topicId}_$moduleId';
    final currentTime = prefs.getInt(key) ?? 0;
    await prefs.setInt(key, currentTime + minutes);

    await prefs.setString(_lastStudyTimeKey, DateTime.now().toIso8601String());
  }

  static Future<DateTime?> getLastStudyTime() async {
    final prefs = await SharedPreferences.getInstance();
    final lastStudyStr = prefs.getString(_lastStudyTimeKey);
    return lastStudyStr != null ? DateTime.parse(lastStudyStr) : null;
  }

  static Future<int> getTopicStudyTime(String topicId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs
        .getKeys()
        .where((key) => key.startsWith('$_prefixStudyTime$topicId'))
        .fold<int>(0, (sum, key) => sum + (prefs.getInt(key) ?? 0));
  }

  static Future<int> getTotalStudyTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs
        .getKeys()
        .where((key) => key.startsWith(_prefixStudyTime))
        .fold<int>(0, (sum, key) => sum + (prefs.getInt(key) ?? 0));
  }

  // Save quiz result
  static Future<void> saveQuizResult(
    String topicId,
    String moduleId,
    int questionIndex,
    bool isCorrect,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final scoreKey = '$_prefixQuizScore${topicId}_${moduleId}_$questionIndex';
    final attemptsKey =
        '$_prefixQuizAttempts${topicId}_${moduleId}_$questionIndex';

    await prefs.setBool(scoreKey, isCorrect);
    final currentAttempts = prefs.getInt(attemptsKey) ?? 0;
    await prefs.setInt(attemptsKey, currentAttempts + 1);
    await prefs.setString(_lastStudyTimeKey, DateTime.now().toIso8601String());
  }

  // Save and retrieve quiz answers
  static Future<void> saveQuizAnswer(
    String topicId,
    String moduleId,
    int questionIndex,
    int selectedAnswerIndex,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefixQuizAnswer${topicId}_${moduleId}_$questionIndex';
    await prefs.setInt(key, selectedAnswerIndex);
  }

  static Future<int?> getQuizAnswer(
    String topicId,
    String moduleId,
    int questionIndex,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefixQuizAnswer${topicId}_${moduleId}_$questionIndex';
    return prefs.getInt(key);
  }

  static Future<bool?> getQuizResult(
    String topicId,
    String moduleId,
    int questionIndex,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefixQuizScore${topicId}_${moduleId}_$questionIndex';
    return prefs.getBool(key);
  }

  static Future<int> getQuizAttempts(
    String topicId,
    String moduleId,
    int questionIndex,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefixQuizAttempts${topicId}_${moduleId}_$questionIndex';
    return prefs.getInt(key) ?? 0;
  }

  static Future<Map<String, dynamic>> getModuleQuizStats(
    String topicId,
    String moduleId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final prefix = '$_prefixQuizScore${topicId}_${moduleId}_';
    final scores = prefs
        .getKeys()
        .where((key) => key.startsWith(prefix))
        .map((key) => prefs.getBool(key) ?? false)
        .toList();

    final correct = scores.where((score) => score).length;
    final total = scores.length;

    return {
      'correct': correct,
      'total': total,
      'percentage': total > 0 ? (correct / total * 100).toInt() : 0,
    };
  }

  // Get completion timestamp for module
  static Future<DateTime?> getCompletionTimestamp(
    String topicId,
    String moduleId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefixCompletionTime${topicId}_$moduleId';
    final timestamp = prefs.getInt(key);
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  // Get study time for specific module
  static Future<int> getStudyTime(String topicId, String moduleId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefixStudyTime${topicId}_$moduleId';
    return prefs.getInt(key) ?? 0;
  }

  // Calculate current streak (continuous study days)
  static Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final studyDatesJson = prefs.getStringList(_studyDatesKey) ?? [];

    if (studyDatesJson.isEmpty) return 0;

    final studyDates = studyDatesJson.map((d) => DateTime.parse(d)).toList()
      ..sort((a, b) => b.compareTo(a));

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final mostRecent = DateTime(
      studyDates.first.year,
      studyDates.first.month,
      studyDates.first.day,
    );

    if (mostRecent != today && mostRecent != yesterday) return 0;

    int streak = 1;
    DateTime currentDate = mostRecent;

    for (int i = 1; i < studyDates.length; i++) {
      final checkDate = DateTime(
        studyDates[i].year,
        studyDates[i].month,
        studyDates[i].day,
      );
      final expectedDate = currentDate.subtract(const Duration(days: 1));

      if (checkDate == expectedDate) {
        streak++;
        currentDate = checkDate;
      } else if (checkDate != currentDate) {
        break;
      }
    }

    return streak;
  }

  // Update last study date list (for streaks)
  static Future<void> _updateLastStudyDate() async {
    final prefs = await SharedPreferences.getInstance();
    final studyDatesJson = prefs.getStringList(_studyDatesKey) ?? [];

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayString = today.toIso8601String();

    if (!studyDatesJson.contains(todayString)) {
      studyDatesJson.add(todayString);
      await prefs.setStringList(_studyDatesKey, studyDatesJson);
    }
  }

  static Future<void> resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs
        .getKeys()
        .where(
          (key) =>
              key.startsWith(_prefixChapter) ||
              key.startsWith(_prefixStudyTime) ||
              key.startsWith(_prefixQuizScore) ||
              key.startsWith(_prefixQuizAttempts) ||
              key.startsWith(_prefixQuizAnswer) ||
              key.startsWith(_prefixCompletionTime) ||
              key == _lastStudyTimeKey ||
              key == _studyDatesKey,
        )
        .toList();

    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}
