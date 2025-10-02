import 'package:flutter/material.dart';
import 'package:netlab/temp/homie/widgets/study_section/features/study_content/models/quiz_data.dart';
import 'package:netlab/temp/core/constants/app_text.dart';
import 'package:netlab/core/components/app_theme.dart';
import 'package:netlab/temp/homie/widgets/study_section/core/services/progress_service.dart';

class QuizWidget extends StatefulWidget {
  final QuizData quizData;
  final String topicId;
  final String moduleId;
  final int questionIndex;

  const QuizWidget({
    super.key,
    required this.quizData,
    required this.topicId,
    required this.moduleId,
    required this.questionIndex,
  });

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  int? selectedAnswer;
  bool hasAnswered = false;
  bool showFeedback = false;

  @override
  void initState() {
    super.initState();
    _loadPreviousAnswer();
  }

  // Load if the user has already answered this question
  Future<void> _loadPreviousAnswer() async {
    final result = await ProgressService.getQuizResult(
      widget.topicId,
      widget.moduleId,
      widget.questionIndex,
    );
    
    if (result != null && mounted) {
      setState(() {
        hasAnswered = true;
        showFeedback = true;
        // Find which answer they selected (if we want to show it)
      });
    }
  }

  Future<Map<String, dynamic>> _getQuizStats() async {
    return await ProgressService.getModuleQuizStats(
      widget.topicId,
      widget.moduleId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quiz header
        Row(
          children: [
            Icon(Icons.quiz, color: cs.primary, size: 24),
            const SizedBox(width: 8),
            Text(
              'Quiz Question',
              style: AppTextStyles.subtitleMedium.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Question
        Text(
          widget.quizData.question,
          style: AppTextStyles.bodyLarge.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),

        // Options
        ...widget.quizData.options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final isSelected = selectedAnswer == index;
          final isCorrect = index == widget.quizData.correctAnswerIndex;

          BoxDecoration optionDecoration;
          IconData? icon;

          if (showFeedback) {
            if (isCorrect) {
              optionDecoration = AppStyles.achievementCard(context);
              icon = Icons.check_circle;
            } else if (isSelected && !isCorrect) {
              optionDecoration = AppStyles.errorCard(context);
              icon = Icons.cancel;
            } else {
              optionDecoration = AppStyles.outlineCard(context);
            }
          } else {
            optionDecoration = isSelected
                ? AppStyles.infoCard(context)
                : AppStyles.outlineCard(context);
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: optionDecoration,
            child: InkWell(
              onTap: hasAnswered
                  ? null
                  : () {
                      setState(() {
                        selectedAnswer = index;
                      });
                    },
              borderRadius: BorderRadius.circular(AppStyles.cardRadius),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Option letter (A, B, C, D)
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: showFeedback && isCorrect
                            ? cs.primary
                            : showFeedback && isSelected && !isCorrect
                            ? cs.error
                            : isSelected
                            ? cs.primary
                            : Colors.transparent,
                        border: Border.all(
                          color: showFeedback && isCorrect
                              ? cs.primary
                              : showFeedback && isSelected && !isCorrect
                              ? cs.error
                              : cs.onSurfaceVariant,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          String.fromCharCode(65 + index),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color:
                                showFeedback &&
                                    (isCorrect || (isSelected && !isCorrect))
                                ? cs.onPrimary
                                : isSelected
                                ? cs.onPrimary
                                : cs.onSurface,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Option text
                    Expanded(
                      child: Text(
                        option,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: cs.onSurface,
                          height: 1.4,
                        ),
                      ),
                    ),

                    // Feedback icon
                    if (showFeedback && icon != null) ...[
                      const SizedBox(width: 8),
                      Icon(
                        icon,
                        color: isCorrect ? cs.primary : cs.error,
                        size: 24,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),

        //.toList(), idk yet
        const SizedBox(height: 20),

        // Check Answer Button
        if (!hasAnswered)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: selectedAnswer != null ? _checkAnswer : null,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Check Answer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: cs.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppStyles.cardRadius),
                ),
              ),
            ),
          ),

        // Feedback
        if (showFeedback) ...[
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: _isCorrectAnswer()
                ? AppStyles.achievementCard(context)
                : AppStyles.errorCard(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _isCorrectAnswer() ? Icons.check_circle : Icons.cancel,
                      color: _isCorrectAnswer() ? cs.primary : cs.error,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isCorrectAnswer() ? 'Correct!' : 'Incorrect',
                      style: AppTextStyles.subtitleMedium.copyWith(
                        color: _isCorrectAnswer() ? cs.primary : cs.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (widget.quizData.explanation != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    widget.quizData.explanation!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: cs.onSurface.withAlpha(204),
                      height: 1.5,
                    ),
                  ),
                ],
                // Show current quiz performance
                const SizedBox(height: 12),
                FutureBuilder<Map<String, dynamic>>(
                  future: _getQuizStats(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox.shrink();
                    final stats = snapshot.data!;
                    if (stats['total'] == 0) return const SizedBox.shrink();
                    
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest.withAlpha(100),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.emoji_events,
                            color: cs.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Module Score: ${stats['correct']}/${stats['total']} (${stats['percentage']}%)',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: cs.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Try Again Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _resetQuiz,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: OutlinedButton.styleFrom(
                foregroundColor: cs.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppStyles.cardRadius),
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 32),
      ],
    );
  }

  Future<void> _checkAnswer() async {
    setState(() {
      hasAnswered = true;
      showFeedback = true;
    });

    // Save the quiz result
    final isCorrect = _isCorrectAnswer();
    await ProgressService.saveQuizResult(
      widget.topicId,
      widget.moduleId,
      widget.questionIndex,
      isCorrect,
    );
  }

  void _resetQuiz() {
    setState(() {
      selectedAnswer = null;
      hasAnswered = false;
      showFeedback = false;
    });
  }

  bool _isCorrectAnswer() {
    return selectedAnswer == widget.quizData.correctAnswerIndex;
  }
}
