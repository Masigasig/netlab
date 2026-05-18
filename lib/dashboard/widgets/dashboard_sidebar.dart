import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/core/components/animations.dart';
import 'package:netlab/core/routing/go_router.dart';
import 'package:netlab/core/themes/app_colors.dart';
import 'package:netlab/dashboard/study/provider/lesson_history_notifier.dart';
import 'package:netlab/dashboard/study/provider/lesson_status_notifier.dart';
import 'package:netlab/dashboard/study/provider/material_details_notifier.dart';

class DashboardSidebar extends ConsumerWidget {
  final double width;
  const DashboardSidebar({super.key, required this.width});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final history = ref.watch(lessonHistoryProvider);

    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimationPresets.textFadeIn(
              delay: 100,
              child: Text(
                'Quick Actions',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 12),
            AnimationPresets.cardEntrance(
              delay: 200,
              child: _buildActionButton(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedPlay,
                  color: cs.onPrimary,
                  size: 20,
                ),
                label: history.isNotEmpty
                    ? 'Continue Learning'
                    : 'Start Learning',
                color: cs.primary,
                onTap: () => {
                  if (history.isNotEmpty)
                    {
                      context.go(
                        '${Routes.study}/${history[0]['chapterId']}/${history[0]['lessonId']}',
                      ),
                    }
                  else
                    {context.go(Routes.study)},
                },
              ),
            ),
            const SizedBox(height: 12),
            AnimationPresets.cardEntrance(
              delay: 300,
              child: _buildActionButton(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedSearch02,
                  color: cs.onPrimary,
                  size: 20,
                ),
                label: 'Browse Topics',
                color: cs.secondary,
                onTap: () => {context.go(Routes.study)},
              ),
            ),
            const SizedBox(height: 12),
            AnimationPresets.textFadeIn(
              delay: 400,
              child: Text(
                'Recent Activity',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (history.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final lessonId = history[index]['lessonId']!;
                    final chapterId = history[index]['chapterId']!;
                    final timestampStr = history[index]['timestamp'];
                    final timestamp = DateTime.tryParse(timestampStr ?? '');
                    final readableTimeStamp = timestamp != null
                        ? _formatTimeAgo(timestamp)
                        : 'Unknown time';

                    final lessonTitle = ref.read(
                      materialDetailProvider,
                    )[chapterId]['lessons'][lessonId]['title'];
                    final chapterTitle = ref.read(
                      materialDetailProvider,
                    )[chapterId]['title'];

                    final isComplete = ref
                        .watch(lessonStatusProvider.notifier)
                        .isLessonCompleted(chapterId, lessonId);

                    return AnimationPresets.listItemSlideLeft(
                      index: index,
                      staggerDelay: 80,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: cs.onSurface.withAlpha(100),
                          ),
                        ),
                        child: ListTile(
                          dense: true,
                          leading: Container(
                            padding: const EdgeInsets.all(6),
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: isComplete
                                  ? AppColors.successColor.withAlpha(30)
                                  : cs.primary.withAlpha(30),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: HugeIcon(
                              icon: isComplete
                                  ? HugeIcons.strokeRoundedBook03
                                  : HugeIcons.strokeRoundedBookOpen01,
                              color: isComplete
                                  ? AppColors.successColor
                                  : cs.primary,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            lessonTitle,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: cs.onSurface,
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            chapterTitle,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: cs.onSurface,
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text(
                            readableTimeStamp,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: cs.onSurface,
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              Expanded(
                child: AnimationPresets.textFadeIn(
                  delay: 500,
                  child: const Center(child: Text('No Recent Activity')),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required Widget icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Builder(
      builder: (context) {
        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds} sec ago';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} mins ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hrs ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = (diff.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    }
  }
}
