import 'package:flutter/material.dart';
import 'package:netlab/temp/core/constants/app_text.dart';
import 'package:netlab/core/themes/app_theme.dart';
import '../models/dashboard_stats.dart';

class ProgressCard extends StatelessWidget {
  final DashboardStats stats;

  const ProgressCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      constraints: const BoxConstraints(minHeight: 150),
      padding: const EdgeInsets.all(20),
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
                'Quiz Performance',
                style: AppTextStyles.forSurface(
                  AppTextStyles.subtitleXL,
                  context,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.successColor.withAlpha(51),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${stats.correctPercentage.toStringAsFixed(0)}%',
                  style: AppTextStyles.withColor(
                    AppTextStyles.subtitleMedium,
                    AppColors.successColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Three-segment progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 8,
              child: Row(
                children: [
                  if (stats.correctAnswers > 0)
                    Expanded(
                      flex: stats.correctAnswers,
                      child: Container(color: AppColors.successColor),
                    ),
                  if (stats.wrongAnswers > 0)
                    Expanded(
                      flex: stats.wrongAnswers,
                      child: Container(color: AppColors.errorColor),
                    ),
                  if (stats.undiscoveredQuestions > 0)
                    Expanded(
                      flex: stats.undiscoveredQuestions,
                      child: Container(color: cs.onSurfaceVariant),
                    ),
                  if (stats.correctAnswers == 0 &&
                      stats.wrongAnswers == 0 &&
                      stats.undiscoveredQuestions == 0)
                    Expanded(child: Container(color: cs.surfaceContainerHigh)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Progress details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildProgressDetail(
                'Correct',
                '${stats.correctAnswers}',
                AppColors.successColor,
              ),
              Container(height: 18, width: 1, color: cs.outline.withAlpha(77)),
              _buildProgressDetail(
                'Wrong',
                '${stats.wrongAnswers}',
                AppColors.errorColor,
              ),
              Container(height: 18, width: 1, color: cs.outline.withAlpha(77)),
              _buildProgressDetail(
                'Undiscovered',
                '${stats.undiscoveredQuestions}',
                cs.onSurfaceVariant,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressDetail(String label, String value, Color color) {
    return Builder(
      builder: (context) => Column(
        children: [
          Text(
            value,
            style: AppTextStyles.withColor(
              AppTextStyles.forSurface(AppTextStyles.headerSmall, context),
              color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.withOpacity(
              AppTextStyles.forSurface(AppTextStyles.caption, context),
              0.75,
            ),
          ),
        ],
      ),
    );
  }
}
