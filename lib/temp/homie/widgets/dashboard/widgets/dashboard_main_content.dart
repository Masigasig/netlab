import 'package:flutter/material.dart';
import '../models/dashboard_stats.dart';
import 'welcome_card.dart';
import 'stats_grid.dart';
import 'progress_card.dart';

class DashboardMainContent extends StatelessWidget {
  final DashboardStats stats;
  final int streak;

  const DashboardMainContent({
    super.key,
    required this.stats,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WelcomeCard(streak: streak),
          const SizedBox(height: 20),
          StatsGrid(stats: stats),
          const SizedBox(height: 24),
          const Text(
            'Learning Progress',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ProgressCard(stats: stats),
        ],
      ),
    );
  }
}
