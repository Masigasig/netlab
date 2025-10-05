import 'package:flutter/material.dart';
import '../models/dashboard_stats.dart';
import 'stat_card.dart';

// import '../models/dashboard_stats.dart';

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
          icon: Icons.book_outlined,
          title: 'Modules',
          value: '${stats.completedModules}',
          subtitle: 'Completed',
          color: cs.primary,
        ),
        StatCard(
          icon: Icons.quiz_outlined,
          title: 'Quizzes',
          value: '${stats.averageQuizScore.toStringAsFixed(0)}%',
          subtitle: 'Avg. Score',
          color: Colors.orange,
        ),
        StatCard(
          icon: Icons.timer_outlined,
          title: 'Study Time',
          value: stats.studyTimeFormatted,
          subtitle: 'Total',
          color: Colors.green,
        ),
        StatCard(
          icon: Icons.emoji_events_outlined,
          title: 'Topics',
          value: '${stats.topicsInProgress}',
          subtitle: 'In Progress',
          color: Colors.purple,
        ),
      ],
    );
  }
}
