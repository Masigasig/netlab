class DashboardStats {
  final int totalTopics;
  final int totalChapters;
  final int completedQuizzes;
  final int totalQuizzes;
  final double averageQuizTimeSeconds;
  final int totalStudyTimeMinutes;

  // Quiz performance breakdown
  final int correctAnswers;
  final int wrongAnswers;
  final int undiscoveredQuestions;

  DashboardStats({
    required this.totalTopics,
    required this.totalChapters,
    required this.completedQuizzes,
    required this.totalQuizzes,
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

  String get topicsChaptersFormatted => '$totalTopics/$totalChapters';
  String get completedQuizzesFormatted => '$completedQuizzes/$totalQuizzes';
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
