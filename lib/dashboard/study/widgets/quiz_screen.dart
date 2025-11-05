// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:netlab/core/themes/app_color.dart';
import 'package:netlab/dashboard/study/provider/question_status_notifier.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> questions;
  final void Function(bool isPassed) onClose;

  const QuizScreen({super.key, required this.questions, required this.onClose});

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
                _buildQuestionHeader(currentQuestion, cs),
                const SizedBox(height: 30),
                _buildAnswersList(currentQuestion, cs),
                if (isAnswerChecked) _buildExplanation(currentQuestion, cs),
              ],
            ),
          ),
        ),

        _buildBottomBar(isLastQuestion, cs),
      ],
    );
  }

  Widget _buildQuestionHeader(
    Map<String, dynamic> currentQuestion,
    ColorScheme cs,
  ) {
    return Text.rich(
      TextSpan(
        children: [
          WidgetSpan(child: Icon(Icons.quiz, color: cs.primary, size: 22)),
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
    );
  }

  Widget _buildAnswersList(
    Map<String, dynamic> currentQuestion,
    ColorScheme cs,
  ) {
    return Expanded(
      child: ListView.builder(
        itemCount: (currentQuestion['answers'] as List).length,
        itemBuilder: (context, index) {
          final answer = currentQuestion['answers'][index];
          final isCorrect = answer == currentQuestion['correctAnswer'];

          return _buildAnswerItem(
            answer: answer,
            isCorrect: isCorrect,
            index: index,
            cs: cs,
          );
        },
      ),
    );
  }

  Widget _buildAnswerItem({
    required String answer,
    required bool isCorrect,
    required int index,
    required ColorScheme cs,
  }) {
    final isSelected = selectedAnswer == answer;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: _getAnswerDecoration(isSelected, isCorrect, cs),
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
              _buildAnswerCircle(index, isSelected, isCorrect, cs),

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

              _buildAnswerIcon(isSelected, isCorrect, cs),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _getAnswerDecoration(
    bool isSelected,
    bool isCorrect,
    ColorScheme cs,
  ) {
    return BoxDecoration(
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
    );
  }

  Widget _buildAnswerCircle(
    int index,
    bool isSelected,
    bool isCorrect,
    ColorScheme cs,
  ) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isAnswerChecked && isCorrect
            ? cs.primary
            : isAnswerChecked && isSelected && !isCorrect
            ? AppColors.errorColor
            : isSelected
            ? cs.primary
            : Colors.transparent,
        border: Border.all(color: cs.onSurfaceVariant, width: 1),
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
            color: isSelected ? cs.onPrimary : cs.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerIcon(bool isSelected, bool isCorrect, ColorScheme cs) {
    if (isAnswerChecked && isCorrect) {
      return Icon(Icons.check_circle, color: cs.secondary);
    }
    if (isAnswerChecked && isSelected && !isCorrect) {
      return const Icon(Icons.cancel, color: AppColors.errorColor);
    }

    return const SizedBox.shrink();
  }

  Widget _buildExplanation(
    Map<String, dynamic> currentQuestion,
    ColorScheme cs,
  ) {
    return Container(
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
    );
  }

  Widget _buildBottomBar(bool isLastQuestion, ColorScheme cs) {
    return Container(
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
          _buildProgressIndicators(cs),
          const SizedBox(width: 20),
          _buildActionButton(isLastQuestion, cs),
        ],
      ),
    );
  }

  Widget _buildProgressIndicators(ColorScheme cs) {
    return Row(
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
    );
  }

  Widget _buildActionButton(bool isLastQuestion, ColorScheme cs) {
    return ElevatedButton(
      onPressed: selectedAnswer == null
          ? null
          : () {
              if (!isAnswerChecked) {
                checkAnswer();
              } else if (isLastQuestion) {
                finishQuiz(cs);
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
        'status': isCorrect ? 'correct' : 'incorrect',
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

  void finishQuiz(ColorScheme cs) {
    final totalQuestions = widget.questions.length;
    final correctAnswers = quizResults
        .where((r) => r['status'] == 'correct')
        .length;
    final score = (correctAnswers / totalQuestions) * 100;
    const passingScore = 80.0;
    final isPassed = score >= passingScore;

    final statusNotifier = ref.read(questionStatusProvider.notifier);

    for (final result in quizResults) {
      final chapterId = result['chapterId'] as String;
      final lessonId = result['lessonId'] as String;
      final questionId = result['questionId'] as String;
      final status = result['status'] as String;
      final time = result['time_answering'] as int;

      statusNotifier.setStatus(
        chapterId: chapterId,
        lessonId: lessonId,
        questionId: questionId,
        status: status,
        timeTaken: time,
      );
    }

    showResultDialog(
      context: context,
      isPassed: isPassed,
      score: score,
      correctAnswers: correctAnswers,
      totalQuestions: totalQuestions,
      passingScore: passingScore,
      onClose: () => widget.onClose(isPassed),
      cs: cs,
    );
  }

  void showResultDialog({
    required BuildContext context,
    required bool isPassed,
    required double score,
    required int correctAnswers,
    required int totalQuestions,
    required VoidCallback onClose,
    required double passingScore,
    required ColorScheme cs,
  }) {
    final Color color = isPassed ? cs.secondary : AppColors.errorColor;
    final String title = isPassed ? 'Excellent Work!' : 'Keep Practicing!';
    final String subtitle = isPassed
        ? 'You\'ve mastered this topic!'
        : 'Review the material and try again!';
    final String summary = '$correctAnswers out of $totalQuestions correct';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          height: 380,
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isPassed
                      ? cs.secondary.withAlpha(50)
                      : AppColors.errorColor.withAlpha(50),
                ),
                child: HugeIcon(
                  icon: isPassed
                      ? HugeIcons.strokeRoundedChampion
                      : HugeIcons.strokeRoundedBookEdit,
                  color: isPassed ? cs.secondary : AppColors.errorColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color.withAlpha(100), width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      'Your Score',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          score.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: color,
                            height: 1,
                          ),
                        ),
                        Text(
                          '%',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      summary,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Passing score: ${passingScore.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((_) => onClose());
  }
}
