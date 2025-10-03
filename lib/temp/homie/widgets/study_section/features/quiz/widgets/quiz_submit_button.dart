import 'package:flutter/material.dart';
import '../../quiz/controllers/quiz_controller.dart';
import 'package:netlab/temp/core/constants/app_text.dart';
import 'package:netlab/core/components/app_theme.dart';

class SubmitQuizButton extends StatelessWidget {
  final ModuleQuizController quizController;

  const SubmitQuizButton({
    super.key,
    required this.quizController,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: quizController,
      builder: (context, _) {
        final isSubmitted = quizController.isSubmitted;
        final isLoading = quizController.isLoading;
        final allAnswered = quizController.allQuestionsAnswered;
        final answeredCount = quizController.answeredQuestions;
        final totalCount = quizController.totalQuestions;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress indicator
            if (!isSubmitted) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: cs.outline.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      allAnswered ? Icons.check_circle : Icons.pending,
                      color: allAnswered ? cs.primary : cs.onSurfaceVariant,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quiz Progress',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: cs.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$answeredCount of $totalCount questions answered',
                            style: TextStyle(
                              fontSize: 12,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '$answeredCount/$totalCount',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: allAnswered ? cs.primary : cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Submit button or results
            if (!isSubmitted)
              ElevatedButton.icon(
                onPressed: allAnswered && !isLoading
                    ? () => _handleSubmit(context)
                    : null,
                icon: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: cs.onPrimary,
                        ),
                      )
                    : const Icon(Icons.send),
                label: Text(
                  isLoading ? 'Submitting...' : 'Submit All Answers',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )
            else
              _buildResultsCard(context),

            // Helper text
            if (!isSubmitted && !allAnswered) ...[
              const SizedBox(height: 8),
              Text(
                'Please answer all questions before submitting',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: cs.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildResultsCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final stats = quizController.getStats();
    final percentage = stats['percentage'] as int;
    final correct = stats['correct'] as int;
    final total = stats['total'] as int;

    // Determine performance
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
        // Results card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: performanceColor.withAlpha(26),
            borderRadius: BorderRadius.circular(AppStyles.cardRadius),
            border: Border.all(
              color: performanceColor.withAlpha(77),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                performanceIcon,
                color: performanceColor,
                size: 48,
              ),
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$percentage',
                    style: AppTextStyles.subtitleLarge.copyWith(
                      color: performanceColor,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, left: 2),
                    child: Text(
                      '%',
                      style: AppTextStyles.headerLarge.copyWith(
                        color: performanceColor,
                        fontWeight: FontWeight.bold,
                      ),
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
        const SizedBox(height: 16),

        // Try again button
        OutlinedButton.icon(
          onPressed: () => _handleRetry(context),
          icon: const Icon(Icons.refresh),
          label: const Text('Try Again'),
          style: OutlinedButton.styleFrom(
            foregroundColor: cs.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: BorderSide(color: cs.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppStyles.cardRadius),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSubmit(BuildContext context) async {
    try {
      await quizController.submitAnswers();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Quiz submitted successfully!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting quiz: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _handleRetry(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Retry Quiz?'),
        content: const Text(
          'This will clear all your current answers and let you retake the quiz. Your previous score will be replaced.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              quizController.reset();
              Navigator.of(context).pop();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}