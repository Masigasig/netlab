class DashboardStats {
  final int totalChapterQuizzes;
  final int completedChapterQuizzes;
  final int totalTopicQuizzes;
  final int completedTopicQuizzes;
  final double averageQuizTimeSeconds;
  final int totalStudyTimeMinutes;

  // Quiz performance breakdown
  final int correctAnswers;
  final int wrongAnswers;
  final int undiscoveredQuestions;

  DashboardStats({
    required this.totalChapterQuizzes,
    required this.completedChapterQuizzes,
    required this.totalTopicQuizzes,
    required this.completedTopicQuizzes,
    required this.averageQuizTimeSeconds,
    required this.totalStudyTimeMinutes,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.undiscoveredQuestions,
  });

  String get studyTimeFormatted {
    final hours = totalStudyTimeMinutes ~/ 60;
    return '${hours}h';
  }

  String get chapterQuizzesFormatted =>
      '$completedChapterQuizzes/$totalChapterQuizzes';
  String get topicQuizzesFormatted =>
      '$completedTopicQuizzes/$totalTopicQuizzes';
  String get avgQuizTimeFormatted =>
      '${averageQuizTimeSeconds.toStringAsFixed(1)}s';

  int get totalQuestions =>
      correctAnswers + wrongAnswers + undiscoveredQuestions;

  double get correctPercentage =>
      totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100 : 0.0;

  double get wrongPercentage =>
      totalQuestions > 0 ? (wrongAnswers / totalQuestions) * 100 : 0.0;

  double get undiscoveredPercentage =>
      totalQuestions > 0 ? (undiscoveredQuestions / totalQuestions) * 100 : 0.0;
}
