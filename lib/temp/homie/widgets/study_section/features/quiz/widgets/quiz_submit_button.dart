import 'package:flutter/material.dart';
import '../../quiz/controllers/quiz_controller.dart';
import 'quiz_progress_card.dart';
import 'quiz_result_bottom_sheet.dart';

class SubmitQuizButton extends StatelessWidget {
  final ModuleQuizController quizController;

  const SubmitQuizButton({super.key, required this.quizController});

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
            // Progress card (always show when not submitted)
            if (!isSubmitted) ...[
              QuizProgressCard(
                answeredCount: answeredCount,
                totalCount: totalCount,
                allAnswered: allAnswered,
              ),
              const SizedBox(height: 16),
            ],

            // Submit button
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
              // Show "View Results" button if already submitted
              OutlinedButton.icon(
                onPressed: () => _showResults(context),
                icon: const Icon(Icons.assessment),
                label: const Text('View Results'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

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

  Future<void> _handleSubmit(BuildContext context) async {
    try {
      await quizController.submitAnswers();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Quiz submitted successfully!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );

        // Show results in bottom sheet
        await _showResults(context);
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

  Future<void> _showResults(BuildContext context) async {
    await QuizResultBottomSheet.show(
      context,
      quizController: quizController,
      onRetry: () => _handleRetry(context),
    );
  }

  void _handleRetry(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Retry Quiz?'),
        content: const Text(
          'This will clear all your current answers and let you retake the quiz.',
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
