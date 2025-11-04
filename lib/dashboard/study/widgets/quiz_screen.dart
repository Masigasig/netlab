// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netlab/core/themes/app_color.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> questions;

  const QuizScreen({super.key, required this.questions});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int currentQuestionIndex = 0;
  String? selectedAnswer;
  bool isAnswerChecked = false;
  List<Map<String, dynamic>> quizResults = [];
  DateTime? questionStartTime;

  @override
  void initState() {
    super.initState();
    questionStartTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final currentQuestion = widget.questions[currentQuestionIndex];
    final isLastQuestion = currentQuestionIndex == widget.questions.length - 1;

    final mainPadding = kIsWeb
        ? const EdgeInsets.fromLTRB(70, 70, 70, 40)
        : Platform.isWindows
        ? const EdgeInsets.fromLTRB(70, 70, 70, 40)
        : const EdgeInsets.fromLTRB(30, 30, 30, 15);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: mainPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(Icons.quiz, color: cs.primary, size: 22),
                      ),
                      const WidgetSpan(child: SizedBox(width: 8)),
                      TextSpan(
                        text: currentQuestion['question'],
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: kIsWeb
                              ? 24
                              : Platform.isWindows
                              ? 24
                              : 16,
                          color: cs.onSurface,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Expanded(
                  child: ListView.builder(
                    itemCount: (currentQuestion['answers'] as List).length,
                    itemBuilder: (context, index) {
                      final answer = currentQuestion['answers'][index];
                      final isSelected = selectedAnswer == answer;
                      final isCorrect =
                          answer == currentQuestion['correctAnswer'];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: isAnswerChecked && isCorrect
                              ? cs.secondary.withAlpha(26)
                              : isAnswerChecked && isSelected && !isCorrect
                              ? AppColors.errorColor.withAlpha(26)
                              : isSelected
                              ? cs.primary.withAlpha(26)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isAnswerChecked && isCorrect
                                ? cs.secondary.withAlpha(77)
                                : isAnswerChecked && isSelected && !isCorrect
                                ? AppColors.errorColor.withAlpha(77)
                                : cs.primary,
                            width: isSelected ? 1 : 2,
                          ),
                        ),
                        child: InkWell(
                          onTap: () => selectAnswer(answer),
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: EdgeInsets.all(
                              kIsWeb
                                  ? 16
                                  : Platform.isWindows
                                  ? 16
                                  : 8,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isAnswerChecked && isCorrect
                                        ? cs.primary
                                        : isAnswerChecked &&
                                              isSelected &&
                                              !isCorrect
                                        ? AppColors.errorColor
                                        : isSelected
                                        ? cs.primary
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: cs.onSurfaceVariant,
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      String.fromCharCode(65 + index),
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: kIsWeb
                                            ? 14
                                            : Platform.isWindows
                                            ? 14
                                            : 10,
                                        fontWeight: FontWeight.normal,
                                        color: isSelected
                                            ? cs.onPrimary
                                            : cs.onSurface,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Text(
                                    answer,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.normal,
                                      fontSize: kIsWeb
                                          ? 14
                                          : Platform.isWindows
                                          ? 14
                                          : 10,
                                      height: 1.3,
                                      color: cs.onSurface,
                                    ),
                                  ),
                                ),
                                if (isAnswerChecked && isCorrect)
                                  Icon(Icons.check_circle, color: cs.secondary),
                                if (isAnswerChecked && isSelected && !isCorrect)
                                  const Icon(
                                    Icons.cancel,
                                    color: AppColors.errorColor,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                if (isAnswerChecked)
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(12),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Explanation:',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.normal,
                            fontSize: kIsWeb
                                ? 14
                                : Platform.isWindows
                                ? 14
                                : 10,
                            height: 1.3,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          currentQuestion['explanation'],
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.normal,
                            fontSize: kIsWeb
                                ? 14
                                : Platform.isWindows
                                ? 14
                                : 10,
                            height: 1.3,
                            color: cs.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),

        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          color: cs.surfaceContainerLow.withAlpha(100),
          child: Row(
            children: [
              Text(
                'Question ${currentQuestionIndex + 1} of ${widget.questions.length}',
              ),

              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.questions.length, (index) {
                  Color circleColor = Colors.transparent;

                  if (index < quizResults.length) {
                    circleColor = quizResults[index]['status'] == 'correct'
                        ? cs.secondary
                        : AppColors.errorColor;
                  }

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: circleColor,
                      border: Border.all(color: cs.primary, width: 1),
                    ),
                  );
                }),
              ),

              const SizedBox(width: 20),

              ElevatedButton(
                onPressed: selectedAnswer == null
                    ? null
                    : () {
                        if (!isAnswerChecked) {
                          checkAnswer();
                        } else if (isLastQuestion) {
                          finishQuiz();
                        } else {
                          nextQuestion();
                        }
                      },

                child: Text(
                  !isAnswerChecked
                      ? 'Check Answer'
                      : isLastQuestion
                      ? 'Finish'
                      : 'Next Question',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void selectAnswer(String answer) {
    if (!isAnswerChecked) {
      setState(() {
        selectedAnswer = answer;
      });
    }
  }

  void checkAnswer() {
    if (selectedAnswer == null) return;

    final currentQuestion = widget.questions[currentQuestionIndex];
    final isCorrect = selectedAnswer == currentQuestion['correctAnswer'];
    final duration = DateTime.now().difference(questionStartTime!);

    setState(() {
      isAnswerChecked = true;
      quizResults.add({
        'chapterId': currentQuestion['chapterId'],
        'lessonId': currentQuestion['lessonId'],
        'questionId': currentQuestion['questionId'],
        'status': isCorrect ? 'correct' : 'wrong',
        'time_answering': duration.inSeconds,
        'selectedAnswer': selectedAnswer,
      });
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
        isAnswerChecked = false;
        questionStartTime = DateTime.now();
      });
    }
  }

  void finishQuiz() {
    final totalQuestions = widget.questions.length;
    final correctAnswers = quizResults
        .where((r) => r['status'] == 'correct')
        .length;
    final score = (correctAnswers / totalQuestions) * 100;
    const passingScore = 80.0;
    final isPassed = score >= passingScore;

    print('=== QUIZ RESULTS ===');
    print('Total Questions: $totalQuestions');
    print('Correct Answers: $correctAnswers');
    print('Score: ${score.toStringAsFixed(1)}%');
    print('Passing Score: ${passingScore.toStringAsFixed(0)}%');
    print('Status: ${isPassed ? 'PASSED ✓' : 'FAILED ✗'}');
    print('\nDetailed Results:');
    for (var i = 0; i < quizResults.length; i++) {
      print('\nQuestion ${i + 1}:');
      print('  Chapter ID: ${quizResults[i]['chapterId']}');
      print('  Lesson ID: ${quizResults[i]['lessonId']}');
      print('  Question ID: ${quizResults[i]['questionId']}');
      print('  Status: ${quizResults[i]['status']}');
      print('  Time Answering: ${quizResults[i]['time_answering']} seconds');
      print('  Selected Answer: ${quizResults[i]['selectedAnswer']}');
    }
    print('\n===================');
  }
}
