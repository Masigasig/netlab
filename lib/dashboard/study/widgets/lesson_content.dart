import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import 'package:netlab/dashboard/study/provider/material_content_notifier.dart';
import 'package:netlab/dashboard/study/provider/material_details_notifier.dart';

class LessonContent extends ConsumerWidget {
  final String chapterId;
  final String lessonId;

  const LessonContent({
    super.key,
    required this.chapterId,
    required this.lessonId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final lessonData = ref
        .read(materialDetailProvider.notifier)
        .getLessonData(chapterId, lessonId);

    final lessonContent = ref
        .read(materialContentProvider.notifier)
        .getLessonContent(chapterId, lessonId);

    return Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Markdown(
              selectable: true,
              data: lessonContent,
              //* Costumize this as needed
              styleSheet: MarkdownStyleSheet(
                blockquote: TextStyle(
                  fontFamily: 'Poppins',
                  color: cs.onSurface,
                ),
                blockquoteDecoration: BoxDecoration(
                  color: cs.primary.withAlpha(52),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 1, color: cs.primary),
                ),
                blockquotePadding: const EdgeInsets.all(20),
                blockSpacing: 30,
                blockquoteAlign: WrapAlignment.start,
              ),
            ),
          ),
        ),

        Text(lessonData['title']),
        Text(lessonData['content_path']),
      ],
    );
  }
}
