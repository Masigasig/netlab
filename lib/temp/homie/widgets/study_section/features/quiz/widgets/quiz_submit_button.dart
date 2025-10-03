import 'package:flutter/material.dart';
import '../../quiz/controllers/quiz_controller.dart';
import 'quiz_progress_card.dart';
import 'quiz_result_card.dart';

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
            if (!isSubmitted) ...[
              QuizProgressCard(
                answeredCount: answeredCount,
                totalCount: totalCount,
                allAnswered: allAnswered,
              ),
              const SizedBox(height: 16),
            ],

            // Submit button OR results
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
              QuizResultsCard(
                quizController: quizController,
                onRetry: () => _handleRetry(context),
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
