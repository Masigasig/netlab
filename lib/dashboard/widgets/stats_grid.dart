import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/core/components/animations.dart';
import 'package:netlab/core/themes/app_colors.dart';
import 'package:netlab/dashboard/study/provider/chapter_quiz_notifier.dart';
import 'package:netlab/dashboard/study/provider/lesson_status_notifier.dart';
import 'package:netlab/dashboard/study/provider/question_status_notifier.dart';
import 'package:netlab/dashboard/study/provider/study_time_notifier.dart';

class StatsGrid extends ConsumerWidget {
  const StatsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final averageQuizTime = ref
        .watch(questionStatusProvider.notifier)
        .getAverageAnswerTime();

    final totalNumberOfLessons = ref
        .watch(lessonStatusProvider.notifier)
        .getTotalLessonCount();
    final totalNumberOfCompletedLessons = ref
        .watch(lessonStatusProvider.notifier)
        .getCompletedLessonCount();

    final totalNumberOfChapter = ref
        .watch(chapterQuizStatusProvider.notifier)
        .getTotalChapterCount();
    final totalNumberOfCompletedChapter = ref
        .watch(chapterQuizStatusProvider.notifier)
        .getCompletedChapterCount();

    final totalStudyTime = ref
        .read(studyTimeProvider.notifier)
        .getFormattedTime();

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 16.0;
        final width = constraints.maxWidth;

        // Responsive columns: four across a desktop width, two on a
        // narrow window so the cards never get cramped.
        final crossAxisCount = width >= 860 ? 4 : 2;
        final cardWidth =
            (width - gap * (crossAxisCount - 1)) / crossAxisCount;

        // Scale the card content with the available width so cards stay
        // filled instead of becoming large boxes with tiny text. Clamped
        // so they never shrink too far or balloon on ultra-wide screens.
        final scale = (cardWidth / 240).clamp(0.85, 1.35).toDouble();
        // Card height grows more gently than the content so the cards are
        // comfortably tall without looking stretched on wide screens.
        final cardHeight = 175.0 * scale.clamp(0.85, 1.15);
        final iconSize = 19.0 * scale;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: gap,
          mainAxisSpacing: gap,
          childAspectRatio: cardWidth / cardHeight,
          children: [
            _StatCard(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedBookOpen02,
                color: cs.secondary,
                size: iconSize,
              ),
              title: 'Chapter Test',
              value: '$totalNumberOfCompletedChapter/$totalNumberOfChapter',
              subtitle: 'Completed',
              color: cs.secondary,
              scale: scale,
              index: 0,
            ),
            _StatCard(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedQuiz03,
                color: AppColors.warningColor,
                size: iconSize,
              ),
              title: 'Quizzes',
              value: '$totalNumberOfCompletedLessons/$totalNumberOfLessons',
              subtitle: 'Completed',
              color: AppColors.warningColor,
              scale: scale,
              index: 1,
            ),
            _StatCard(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedClock01,
                color: AppColors.successColor,
                size: iconSize,
              ),
              title: 'Study Time',
              value: totalStudyTime,
              subtitle: 'Total',
              color: AppColors.successColor,
              scale: scale,
              index: 2,
            ),
            _StatCard(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedTimer02,
                color: Colors.purple,
                size: iconSize,
              ),
              title: 'Quiz Time',
              value: '${averageQuizTime.toStringAsFixed(1)} s',
              subtitle: 'Per Questions',
              color: Colors.purple,
              scale: scale,
              index: 3,
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final double scale;
  final int index;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.scale,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnimationPresets.cardEntrance(
      delay: index * 100,
      child: Container(
        padding: EdgeInsets.all(12.0 * scale),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(52), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(7.0 * scale),
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: icon,
                ),
                SizedBox(width: 8.0 * scale),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: cs.onSurface,
                      fontSize: 13.0 * scale,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: cs.onSurface,
                    fontSize: 22.0 * scale,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.0 * scale),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: cs.onSurface.withAlpha(180),
                    fontSize: 11.0 * scale,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
