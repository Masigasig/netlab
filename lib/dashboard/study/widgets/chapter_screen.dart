import 'package:hugeicons/hugeicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/core/routing/go_router.dart';
import 'package:netlab/dashboard/study/provider/material_details_notifier.dart';

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
            width: 300,
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              // border: Border(
              //   right: BorderSide(color: cs.outline.withAlpha(10), width: 1),
              // ),
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
                    itemCount: chapterData['lessons'].length,
                    itemBuilder: (context, index) {
                      final lessonId = lessons.keys.elementAt(index);
                      final lessonData = lessons[lessonId];
                      final isSelected = currentLessonId == lessonId;

                      return ListTile(
                        selected: isSelected,
                        leading: CircleAvatar(
                          radius: 12,
                          backgroundColor: isSelected ? cs.primary : cs.outline,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: isSelected ? cs.onPrimary : cs.onSurface,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        title: Text(
                          lessonData['title'],
                          style: TextStyle(
                            color: isSelected ? cs.primary : cs.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                        onTap: () {
                          context.go('${Routes.study}/$chapterId/$lessonId');
                        },
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
