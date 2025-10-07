import 'progress_service.dart';
import '../../features/modules/helpers/module_quiz_manager.dart';

class TopicProgressService {
  static Future<bool> isTopicAccessible({
    required String topicId,
    required List<String> orderedTopicIds,
  }) async {
    // First topic is always accessible
    final currentIndex = orderedTopicIds.indexOf(topicId);
    if (currentIndex == 0) return true;

    // Check if the previous topic is completed
    final previousTopicId = orderedTopicIds[currentIndex - 1];

    // Get all completed chapters for the previous topic
    final completedChapters = await ProgressService.getCompletedChaptersByTopic(
      previousTopicId,
    );

    final totalChapters = await ProgressService.getTotalChaptersByTopic(
      previousTopicId,
    );

    if (totalChapters == 0 || completedChapters.length != totalChapters) {
      return false;
    }

    // Check quiz completions for each completed chapter
    for (String moduleId in completedChapters) {
      if (ModuleQuizManager.hasQuizzes(moduleId)) {
        // If module has quizzes, verify they're completed
        final quizStats = await ProgressService.getModuleQuizStats(
          previousTopicId,
          moduleId,
        );

        // If there are quiz questions but no answers, or not all questions are answered
        if (quizStats['total'] > 0 && quizStats['correct'] == 0) {
          return false;
        }
      }
    }

    // All checks passed - topic is accessible
    return true;
  }
}
