import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../models/dashboard_stats.dart';
import 'package:netlab/core/themes/app_theme.dart';
import 'stat_card.dart';

class StatsGrid extends StatelessWidget {
  final DashboardStats stats;

  const StatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        StatCard(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedQuiz05,
            color: cs.primary,
            size: 16,
          ),
          title: 'Chapter Quizzes',
          value: stats.chapterQuizzesFormatted,
          subtitle: 'Completed',
          color: cs.primary,
        ),
        StatCard(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedBookOpen01,
            color: AppColors.warningColor,
            size: 16,
          ),
          title: 'Topic Quizzes',
          value: stats.topicQuizzesFormatted,
          subtitle: 'Completed',
          color: AppColors.warningColor,
        ),
        StatCard(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedClock01,
            color: AppColors.successColor,
            size: 16,
          ),
          title: 'Study Time',
          value: stats.studyTimeFormatted,
          subtitle: 'Total',
          color: AppColors.successColor,
        ),
        StatCard(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedTimer02,
            color: Colors.purple,
            size: 16,
          ),
          title: 'Avg Quiz Time',
          value: stats.avgQuizTimeFormatted,
          subtitle: 'Per Question',
          color: Colors.purple,
        ),
      ],
    );
  }
}
