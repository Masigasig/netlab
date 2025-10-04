import 'package:flutter/material.dart';
import '../../../core/services/progress_service.dart';
import '../controllers/quiz_controller.dart';

// Displays quiz performance summary after submission
class QuizPerformanceSummary extends StatelessWidget {
  final String topicId;
  final String moduleId;
  final ModuleQuizController quizController;

  const QuizPerformanceSummary({
    super.key,
    required this.topicId,
    required this.moduleId,
    required this.quizController,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: quizController,
      builder: (context, _) {
        if (!quizController.isSubmitted) {
          return const SizedBox.shrink();
        }

        return FutureBuilder<Map<String, dynamic>>(
          future: ProgressService.getModuleQuizStats(topicId, moduleId),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!['total'] == 0) {
              return const SizedBox.shrink();
            }

            // Use current stats from controller
            final stats = quizController.getStats();
            final percentage = stats['percentage'] as int;

            // Get performance details
            final performance = _getPerformanceDetails(percentage, cs);

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: performance.color.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: performance.color.withAlpha(77)),
              ),
              child: Row(
                children: [
                  Icon(
                    performance.icon,
                    color: performance.color,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quiz Performance',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${performance.text} You answered ${stats['correct']} out of ${stats['total']} questions correctly',
                          style: TextStyle(
                            color: cs.onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: performance.color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$percentage%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  _PerformanceDetails _getPerformanceDetails(
    int percentage,
    ColorScheme colorScheme,
  ) {
    if (percentage >= 80) {
      return _PerformanceDetails(
        color: colorScheme.primary,
        text: 'Excellent!',
        icon: Icons.emoji_events,
      );
    } else if (percentage >= 60) {
      return _PerformanceDetails(
        color: Colors.orange,
        text: 'Good job!',
        icon: Icons.thumb_up,
      );
    } else {
      return _PerformanceDetails(
        color: colorScheme.error,
        text: 'Keep practicing!',
        icon: Icons.school,
      );
    }
  }
}

class _PerformanceDetails {
  final Color color;
  final String text;
  final IconData icon;

  _PerformanceDetails({
    required this.color,
    required this.text,
    required this.icon,
  });
}