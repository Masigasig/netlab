import 'package:flutter/material.dart';
import 'package:netlab/core/components/app_theme.dart';
import 'package:netlab/temp/core/constants/app_text.dart';
import '../../quiz/controllers/quiz_controller.dart';

class QuizResultsCard extends StatelessWidget {
  final ModuleQuizController quizController;
  final VoidCallback onRetry;

  const QuizResultsCard({
    super.key,
    required this.quizController,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final stats = quizController.getStats();
    final percentage = stats['percentage'] as int;
    final correct = stats['correct'] as int;
    final total = stats['total'] as int;

    Color performanceColor;
    String performanceText;
    IconData performanceIcon;

    if (percentage >= 80) {
      performanceColor = cs.primary;
      performanceText = 'Excellent Work!';
      performanceIcon = Icons.emoji_events;
    } else if (percentage >= 60) {
      performanceColor = Colors.orange;
      performanceText = 'Good Job!';
      performanceIcon = Icons.thumb_up;
    } else {
      performanceColor = cs.error;
      performanceText = 'Keep Practicing!';
      performanceIcon = Icons.school;
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: performanceColor.withAlpha(26),
            borderRadius: BorderRadius.circular(AppStyles.cardRadius),
            border: Border.all(color: performanceColor.withAlpha(77), width: 2),
          ),
          child: Column(
            children: [
              Icon(performanceIcon, color: performanceColor, size: 48),
              const SizedBox(height: 12),
              Text(
                performanceText,
                style: AppTextStyles.headerLarge.copyWith(
                  color: performanceColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You scored',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$percentage',
                    style: AppTextStyles.headerLarge.copyWith(
                      color: performanceColor,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  Text(
                    '%',
                    style: AppTextStyles.headerLarge.copyWith(
                      color: performanceColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '$correct out of $total correct',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text('Try Again'),
        ),
      ],
    );
  }
}
