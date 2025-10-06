import 'package:flutter/material.dart';
import '../models/recent_activity.dart';
import 'quick_actions_section.dart';
import 'recent_activity_list.dart';

class DashboardSidebar extends StatelessWidget {
  final List<RecentActivity> activities;
  final VoidCallback? onContinueLearning;
  final VoidCallback? onBrowseTopics;

  const DashboardSidebar({
    super.key,
    required this.activities,
    this.onContinueLearning,
    this.onBrowseTopics,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuickActionsSection(
              onContinueLearning: onContinueLearning,
              onBrowseTopics: onBrowseTopics,
            ),
            const SizedBox(height: 24),

            Expanded(child: RecentActivityList(activities: activities)),
          ],
        ),
      ),
    );
  }
}
