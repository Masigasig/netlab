import 'package:flutter/material.dart';
import 'package:netlab/temp/homie/widgets/study_section/features/study_content/models/quiz_data.dart';
import 'package:netlab/temp/core/constants/app_text.dart';
import 'package:netlab/core/themes/app_theme.dart';
import '../controllers/quiz_controller.dart';

class QuizWidget extends StatefulWidget {
  final QuizData quizData;
  final ModuleQuizController quizController;
  final int questionIndex;

  const QuizWidget({
    super.key,
    required this.quizData,
    required this.quizController,
    required this.questionIndex,
  });

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: widget.quizController,
      builder: (context, _) {
        final selectedAnswer = widget.quizController.getAnswer(
          widget.questionIndex,
        );
        final isSubmitted = widget.quizController.isSubmitted;
        final isCorrect = widget.quizController.isAnswerCorrect(
          widget.questionIndex,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Question
            Text.rich(
              TextSpan(
                children: [
                  WidgetSpan(
                    child: Icon(Icons.quiz, color: cs.primary, size: 22),
                  ),
                  const WidgetSpan(child: SizedBox(width: 8)),
                  TextSpan(
                    text: widget.quizData.question,
                    style: AppTextStyles.headerLarge.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Options
            ...widget.quizData.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final isSelected = selectedAnswer == index;
              final isCorrectOption =
                  index == widget.quizData.correctAnswerIndex;

              BoxDecoration optionDecoration;
              IconData? icon;

              if (isSubmitted) {
                // After submission, show correct/incorrect styling
                if (isCorrectOption) {
                  optionDecoration = AppStyles.achievementCard(context);
                  icon = Icons.check_circle;
                } else if (isSelected && !isCorrectOption) {
                  optionDecoration = AppStyles.errorCard(context);
                  icon = Icons.cancel;
                } else {
                  optionDecoration = AppStyles.outlineCard(context);
                }
              } else {
                // Before submission, just show selection state
                optionDecoration = isSelected
                    ? AppStyles.infoCard(context)
                    : AppStyles.outlineCard(context);
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: optionDecoration,
                child: InkWell(
                  onTap: isSubmitted
                      ? null
                      : () {
                          widget.quizController.setAnswer(
                            widget.questionIndex,
                            index,
                          );
                        },
                  borderRadius: BorderRadius.circular(AppStyles.cardRadius),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Option letter (A, B, C, D)
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSubmitted && isCorrectOption
                                ? cs.primary
                                : isSubmitted && isSelected && !isCorrectOption
                                ? cs.error
                                : isSelected
                                ? cs.primary
                                : Colors.transparent,
                            border: Border.all(
                              color: isSubmitted && isCorrectOption
                                  ? cs.primary
                                  : isSubmitted &&
                                        isSelected &&
                                        !isCorrectOption
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
                                    isSubmitted &&
                                        (isCorrectOption ||
                                            (isSelected && !isCorrectOption))
                                    ? cs.onPrimary
                                    : isSelected
                                    ? cs.onPrimary
                                    : cs.onSurface,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Option text
                        Expanded(
                          child: Text(
                            option,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: cs.onSurface,
                              height: 1.3,
                            ),
                          ),
                        ),

                        // Feedback icon (only after submission)
                        if (isSubmitted && icon != null) ...[
                          const SizedBox(width: 8),
                          Icon(
                            icon,
                            color: isCorrectOption ? cs.primary : cs.error,
                            size: 20,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }),

            // Show feedback only after submission
            if (isSubmitted) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: isCorrect == true
                    ? AppStyles.achievementCard(context)
                    : AppStyles.errorCard(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isCorrect == true ? Icons.check_circle : Icons.cancel,
                          color: isCorrect == true ? cs.primary : cs.error,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isCorrect == true ? 'Correct!' : 'Incorrect',
                          style: AppTextStyles.subtitleMedium.copyWith(
                            color: isCorrect == true ? cs.primary : cs.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (widget.quizData.explanation != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.quizData.explanation!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: cs.onSurface.withAlpha(204),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
