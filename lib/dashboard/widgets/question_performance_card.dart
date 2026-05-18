import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/core/components/animations.dart';
import 'package:netlab/core/themes/app_colors.dart';
import 'package:netlab/dashboard/study/provider/question_status_notifier.dart';

class QuestionPerformanceCard extends ConsumerWidget {
  const QuestionPerformanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final stats = ref.watch(questionStatusProvider.notifier).getQuestionStats();
    final correctAnswers = stats['correct']!;
    final wrongAnswers = stats['incorrect']!;
    final unansweredQuestions = stats['unanswered']!;
    final totalAnswers = correctAnswers + wrongAnswers + unansweredQuestions;
    final correctPercentage = totalAnswers == 0
        ? 0.0
        : (correctAnswers / totalAnswers) * 100;

    return AnimationPresets.cardEntrance(
      delay: 300,
      scaleFrom: 0.9,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.primary.withAlpha(52), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header — icon, title and the correct-percentage badge.
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cs.primary.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedQuiz05,
                    color: cs.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Question Performance',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: cs.onSurface,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.successColor.withAlpha(51),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${correctPercentage.toStringAsFixed(1)} %',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      color: AppColors.successColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Stacked progress bar of correct / incorrect / unanswered.
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 18,
                child: Row(
                  children: [
                    if (correctAnswers > 0)
                      Expanded(
                        flex: correctAnswers,
                        child: Container(color: AppColors.successColor),
                      ),
                    if (wrongAnswers > 0)
                      Expanded(
                        flex: wrongAnswers,
                        child: Container(color: AppColors.errorColor),
                      ),
                    if (unansweredQuestions > 0)
                      Expanded(
                        flex: unansweredQuestions,
                        child: Container(color: cs.onSurfaceVariant),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildProgressDetail(
                  'Correct',
                  '$correctAnswers',
                  AppColors.successColor,
                  cs.onSurface,
                ),
                Container(height: 34, width: 1, color: cs.outline.withAlpha(77)),
                _buildProgressDetail(
                  'Incorrect',
                  '$wrongAnswers',
                  AppColors.errorColor,
                  cs.onSurface,
                ),
                Container(height: 34, width: 1, color: cs.outline.withAlpha(77)),
                _buildProgressDetail(
                  'Unanswered',
                  '$unansweredQuestions',
                  cs.onSurfaceVariant,
                  cs.onSurface,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressDetail(
    String label,
    String value,
    Color color,
    Color labelColor,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: color,
            fontSize: 26,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            color: labelColor.withValues(alpha: 0.75),
            fontSize: 13,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
