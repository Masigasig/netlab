import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final materialDetailProvider =
    NotifierProvider<MaterialDetailNotifier, Map<String, dynamic>>(
      MaterialDetailNotifier.new,
    );

class MaterialDetailNotifier extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() {
    return {};
  }

  void setContent(Map<String, dynamic> json) {
    state = json;
  }

  Map<String, dynamic> getChapterData(String chapterId) {
    return state[chapterId];
  }

  Map<String, dynamic> getLessonData(String chapterId, String lessonId) {
    return state[chapterId]['lessons'][lessonId];
  }

  List<Map<String, dynamic>> getShuffledQuestionForShortQuiz({
    required String chapterId,
    required String lessonId,
  }) {
    final List<Map<String, dynamic>> selectedQuestions = [];

    final chapter = state[chapterId];
    if (chapter == null) return [];

    final lesson = chapter['lessons'][lessonId];
    if (lesson == null) return [];

    final questions = lesson['questions'] as Map<String, dynamic>;
    questions.forEach((questionId, questionData) {
      final List<String> shuffledAnswers = List<String>.from(
        questionData['answers'],
      );
      shuffledAnswers.shuffle(Random());

      selectedQuestions.add({
        'chapterId': chapterId,
        'lessonId': lessonId,
        'questionId': questionId,
        'question': questionData['question'],
        'answers': shuffledAnswers,
        'correctAnswer': questionData['correct_answer'],
        'explanation': questionData['explanation'],
      });
    });

    selectedQuestions.shuffle(Random());
    return selectedQuestions.take(3).toList();
  }

  List<Map<String, dynamic>> getShuffledQuestionsForChapterQuiz(
    String chapterId,
  ) {
    final List<Map<String, dynamic>> chapterQuizQuestions = [];

    final chapter = state[chapterId];
    if (chapter == null) return [];

    final lessons = chapter['lessons'] as Map<String, dynamic>;
    final random = Random();

    lessons.forEach((lessonId, lessonData) {
      final questions = lessonData['questions'] as Map<String, dynamic>;
      final questionEntries = questions.entries.toList();

      questionEntries.shuffle(random);

      final selectedQuestions = questionEntries.take(2);

      for (final entry in selectedQuestions) {
        final questionId = entry.key;
        final questionData = entry.value;

        final List<String> shuffledAnswers = List<String>.from(
          questionData['answers'],
        );
        shuffledAnswers.shuffle(random);

        chapterQuizQuestions.add({
          'chapterId': chapterId,
          'lessonId': lessonId,
          'questionId': questionId,
          'question': questionData['question'],
          'answers': shuffledAnswers,
          'correctAnswer': questionData['correct_answer'],
          'explanation': questionData['explanation'],
        });
      }
    });

    chapterQuizQuestions.shuffle(random);
    return chapterQuizQuestions;
  }
}
