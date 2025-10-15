import 'package:flutter/material.dart';

class QuizProgressCard extends StatelessWidget {
  final int answeredCount;
  final int totalCount;
  final bool allAnswered;

  const QuizProgressCard({
    super.key,
    required this.answeredCount,
    required this.totalCount,
    required this.allAnswered,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withAlpha(102),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline.withAlpha(51)),
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
                    color: cs.onSurface.withAlpha(128),
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
              color: allAnswered ? cs.primary : cs.onSurface.withAlpha(128),
            ),
          ),
        ],
      ),
    );
  }
}
