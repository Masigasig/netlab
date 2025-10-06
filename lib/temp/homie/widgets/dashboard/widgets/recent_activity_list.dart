import 'package:flutter/material.dart';
import 'package:netlab/temp/core/constants/app_text.dart';
import '../models/recent_activity.dart';
import '../models/activity_type.dart';

class RecentActivityList extends StatelessWidget {
  final List<RecentActivity> activities;

  const RecentActivityList({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: AppTextStyles.forSurface(AppTextStyles.headerSmall, context),
        ),
        const SizedBox(height: 12),

        Expanded(
          child: ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) =>
                _buildActivityItem(activities[index], context),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: AppTextStyles.forSurface(AppTextStyles.headerSmall, context),
        ),
        const SizedBox(height: 12),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: cs.outline.withAlpha(51)),
          ),
          child: Text(
            'No recent activity',
            style: AppTextStyles.forSecondary(AppTextStyles.bodySmall, context),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(RecentActivity activity, BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final iconData = _getIconForActivityType(activity.type);
    final iconColor = _getColorForActivityType(activity.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.outline.withAlpha(51)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(26),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(iconData, color: iconColor, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: AppTextStyles.forSurface(
                    AppTextStyles.subtitleMedium,
                    context,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activity.subtitle,
                  style: AppTextStyles.withOpacity(
                    AppTextStyles.forSurface(AppTextStyles.caption, context),
                    0.5,
                  ),
                ),
              ],
            ),
          ),
          Text(
            activity.timeAgo,
            style: AppTextStyles.withOpacity(
              AppTextStyles.forSurface(AppTextStyles.caption, context),
              0.5,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForActivityType(ActivityType type) {
    switch (type) {
      case ActivityType.moduleCompleted:
        return Icons.check_circle;
      case ActivityType.quizCompleted:
        return Icons.quiz;
      case ActivityType.achievementUnlocked:
        return Icons.star;
      case ActivityType.topicStarted:
        return Icons.play_circle_filled;
    }
  }

  Color _getColorForActivityType(ActivityType type) {
    switch (type) {
      case ActivityType.moduleCompleted:
        return Colors.green;
      case ActivityType.quizCompleted:
        return Colors.blue;
      case ActivityType.achievementUnlocked:
        return Colors.orange;
      case ActivityType.topicStarted:
        return Colors.purple;
    }
  }
}
