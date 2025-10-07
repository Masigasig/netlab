import 'progress_service.dart';

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

    // Get total chapters and completed chapters for the previous topic
    final completedChapters = await ProgressService.getCompletedChaptersByTopic(
      previousTopicId,
    );
    final totalChapters = await ProgressService.getTotalChaptersByTopic(
      previousTopicId,
    );

    // Topic is accessible if all chapters in the previous topic are completed
    return totalChapters > 0 && completedChapters.length == totalChapters;
  }
}
