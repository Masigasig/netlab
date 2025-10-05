import 'package:flutter/material.dart';
import '../models/dashboard_stats.dart';

class ProgressCard extends StatelessWidget {
  final DashboardStats stats;

  const ProgressCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      constraints: const BoxConstraints(minHeight: 150),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow.withAlpha(179),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.primary.withAlpha(26), width: 1),
        boxShadow: [
          BoxShadow(
            color: cs.onSurface.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Overall Progress',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: cs.primary.withAlpha(51),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${stats.overallProgressPercentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: cs.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: stats.overallProgressPercentage / 100,
              minHeight: 8, // reduced from 12
              backgroundColor: cs.surfaceContainerHigh,
              valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
            ),
          ),

          const SizedBox(height: 16),

          // Progress details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildProgressDetail(
                'Completed',
                '${stats.completedModules}/${stats.totalModules}',
                cs,
              ),
              Container(height: 18, width: 1, color: cs.outline.withAlpha(77)),
              _buildProgressDetail(
                'In Progress',
                '${stats.topicsInProgress}',
                cs,
              ),
              Container(height: 18, width: 1, color: cs.outline.withAlpha(77)),
              _buildProgressDetail(
                'Remaining',
                '${stats.remainingModules}',
                cs,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressDetail(String label, String value, ColorScheme cs) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 10, color: cs.onSurface.withAlpha(190))),
      ],
    );
  }
}
