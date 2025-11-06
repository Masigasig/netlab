import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:netlab/core/themes/app_color.dart';
import 'package:netlab/dashboard/study/provider/question_status_notifier.dart';
import 'package:netlab/temp/core/components/animations.dart';

class QuestionPerformanceCard extends ConsumerWidget {
  const QuestionPerformanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final stats = ref.watch(questionStatusProvider.notifier).getQuestionStats();
    final correctAnswers = stats['correct']!;
    final wrongAnswers = stats['incorrect']!;
    final unansweredQuestions = stats['unanswered']!;
    final correctPercentage =
        (correctAnswers /
            (correctAnswers + wrongAnswers + unansweredQuestions)) *
        100;

    return AnimationPresets.cardEntrance(
      delay: 300,
      scaleFrom: 0.9,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 150),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.primary.withAlpha(52), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: cs.primary.withAlpha(30),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedQuiz05,
                    color: cs.primary,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Question Performance',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: cs.onSurface,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            Row(
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
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
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  height: 6,
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
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildProgressDetail(
                    'Correct',
                    '$correctAnswers',
                    AppColors.successColor,
                    cs.onSurface,
                  ),
                  Container(
                    height: 18,
                    width: 1,
                    color: cs.outline.withAlpha(77),
                  ),
                  _buildProgressDetail(
                    'Incorrect',
                    '$wrongAnswers',
                    AppColors.errorColor,
                    cs.onSurface,
                  ),
                  Container(
                    height: 18,
                    width: 1,
                    color: cs.outline.withAlpha(77),
                  ),
                  _buildProgressDetail(
                    'Unanswered',
                    '$unansweredQuestions',
                    cs.onSurfaceVariant,
                    cs.onSurface,
                  ),
                ],
              ),
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
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            color: labelColor.withValues(alpha: 0.75),
            fontSize: 10,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
