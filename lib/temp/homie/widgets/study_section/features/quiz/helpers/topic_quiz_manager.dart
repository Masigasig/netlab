import 'dart:math';
import '../../../features/study_content/models/content_block.dart';

class TopicQuizManager {
  final Random _random = Random();

  List<ContentBlock> createTopicQuiz({
    required List<List<ContentBlock>> chapterQuizzes,
    required List<ContentBlock> topicSpecificQuestions,
    required int totalQuestions,
    int? questionsPerChapter,
  }) {
    final List<ContentBlock> allQuestions = [];

    for (final chapterQuiz in chapterQuizzes) {
      final questions = _getRandomQuestions(
        chapterQuiz,
        questionsPerChapter ?? (totalQuestions ~/ (chapterQuizzes.length + 1)),
      );
      allQuestions.addAll(questions);
    }

    final topicQuestions = _getRandomQuestions(
      topicSpecificQuestions,
      totalQuestions - allQuestions.length,
    );
    allQuestions.addAll(topicQuestions);

    return _shuffleQuestions(allQuestions);
  }

  List<ContentBlock> _getRandomQuestions(
    List<ContentBlock> questions,
    int count,
  ) {
    if (count >= questions.length) return List.from(questions);

    final List<ContentBlock> shuffled = List.from(questions)..shuffle(_random);
    return shuffled.take(count).toList();
  }

  List<ContentBlock> _shuffleQuestions(List<ContentBlock> questions) {
    return List.from(questions)..shuffle(_random);
  }
}
