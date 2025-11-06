import 'package:hugeicons/hugeicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/core/routing/go_router.dart';
import 'package:netlab/core/themes/app_theme.dart';
import 'package:netlab/dashboard/study/provider/chapter_quiz_notifier.dart';
import 'package:netlab/dashboard/study/provider/lesson_status_notifier.dart';
import 'package:netlab/dashboard/study/provider/material_details_notifier.dart';
import 'package:netlab/temp/core/components/animations.dart';

class ChapterScreen extends ConsumerWidget {
  final String chapterId;
  final Widget child;

  const ChapterScreen({
    super.key,
    required this.chapterId,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final chapterData = ref
        .read(materialDetailProvider.notifier)
        .getChapterData(chapterId);

    final lessons = chapterData['lessons'] as Map<String, dynamic>;

    final currentLessonId = GoRouterState.of(
      context,
    ).pathParameters['lessonId'];

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 315,
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow.withAlpha(100),
              border: Border(
                right: BorderSide(color: cs.secondary.withAlpha(40), width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => {context.go(Routes.study)},
                        child: Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedArrowLeft02,
                            color: cs.onSurface,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        chapterData['title'],
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: chapterData['lessons'].length + 1,
                    itemBuilder: (context, index) {
                      if (index == chapterData['lessons'].length) {
                        final isSelected = currentLessonId == 'chapter_quiz';
                        final isComplete = ref
                            .read(chapterQuizStatusProvider.notifier)
                            .isChapterQuizCompleted(chapterId);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? cs.primary.withAlpha(20)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: isSelected
                                ? Border.all(color: cs.secondary.withAlpha(51))
                                : null,
                          ),
                          child: ListTile(
                            dense: true,
                            leading: SizedBox(
                              width: 40,
                              height: 40,
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? cs.secondary.withAlpha(30)
                                            : cs.primary.withAlpha(30),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: HugeIcon(
                                        icon: HugeIcons.strokeRoundedPen02,
                                        color: isComplete
                                            ? AppColors.successColor
                                            : isSelected
                                            ? cs.secondary
                                            : cs.primary,
                                      ),
                                    ),
                                  ),
                                  if (isComplete)
                                    const Positioned(
                                      top: 0,
                                      left: 0,
                                      child: SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: HugeIcon(
                                          icon: HugeIcons.strokeRoundedTick04,
                                          color: AppColors.successColor,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            title: Text(
                              'Chapter Test',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: cs.onSurface,
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              isComplete ? 'Passed' : ' ',
                              style: const TextStyle(
                                color: AppColors.successColor,
                              ),
                            ),
                            onTap: () {
                              context.go(
                                '${Routes.study}/$chapterId/chapter_quiz',
                              );
                            },
                          ),
                        );
                      }

                      final lessonId = lessons.keys.elementAt(index);
                      final lessonData = lessons[lessonId];
                      final isSelected = currentLessonId == lessonId;
                      final isComplete = ref
                          .watch(lessonStatusProvider.notifier)
                          .isLessonCompleted(chapterId, lessonId);

                      return AnimationPresets.listItemSlideLeft(
                        index: index,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? cs.primary.withAlpha(20)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: isSelected
                                ? Border.all(color: cs.secondary.withAlpha(51))
                                : null,
                          ),
                          child: ListTile(
                            dense: true,
                            leading: SizedBox(
                              width: 40,
                              height: 40,
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? cs.secondary.withAlpha(30)
                                            : cs.primary.withAlpha(30),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: HugeIcon(
                                        icon: isSelected
                                            ? HugeIcons.strokeRoundedBookOpen02
                                            : isComplete
                                            ? HugeIcons.strokeRoundedBook03
                                            : HugeIcons.strokeRoundedBookOpen01,
                                        color: isComplete
                                            ? AppColors.successColor
                                            : isSelected
                                            ? cs.secondary
                                            : cs.primary,
                                      ),
                                    ),
                                  ),
                                  if (isComplete)
                                    const Positioned(
                                      top: 0,
                                      left: 0,
                                      child: SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: HugeIcon(
                                          icon: HugeIcons.strokeRoundedTick04,
                                          color: AppColors.successColor,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            title: Text(
                              lessonData['title'],
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: cs.onSurface,
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              isComplete ? 'Passed' : ' ',
                              style: const TextStyle(
                                color: AppColors.successColor,
                              ),
                            ),
                            onTap: () {
                              context.go(
                                '${Routes.study}/$chapterId/$lessonId',
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          Expanded(child: child),
        ],
      ),
    );
  }
}
