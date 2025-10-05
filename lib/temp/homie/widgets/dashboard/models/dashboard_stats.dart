class DashboardStats {
  final int completedModules;
  final int totalModules;
  final double averageQuizScore;
  final int totalStudyTimeMinutes;
  final int topicsInProgress;
  final int totalTopics;
  final double overallProgressPercentage;

  DashboardStats({
    required this.completedModules,
    required this.totalModules,
    required this.averageQuizScore,
    required this.totalStudyTimeMinutes,
    required this.topicsInProgress,
    required this.totalTopics,
    required this.overallProgressPercentage,
  });

  String get studyTimeFormatted {
    final hours = totalStudyTimeMinutes ~/ 60;
    return '${hours}h';
  }

  int get remainingModules => totalModules - completedModules;
}
