import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import 'package:netlab/dashboard/study/provider/material_content_notifier.dart';
import 'package:netlab/dashboard/study/provider/material_details_notifier.dart';

class LessonContent extends ConsumerStatefulWidget {
  final String chapterId;
  final String lessonId;

  const LessonContent({
    super.key,
    required this.chapterId,
    required this.lessonId,
  });

  @override
  ConsumerState<LessonContent> createState() => _LessonContentState();
}

class _LessonContentState extends ConsumerState<LessonContent> {
  bool isQuizing = false;

  @override
  void didUpdateWidget(covariant LessonContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.lessonId != oldWidget.lessonId) {
      setState(() {
        isQuizing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final lessonData = ref
        .read(materialDetailProvider.notifier)
        .getLessonData(widget.chapterId, widget.lessonId);

    final lessonContent = ref
        .read(materialContentProvider.notifier)
        .getLessonContent(widget.chapterId, widget.lessonId);

    return Column(
      children: [
        isQuizing
            ? const Expanded(child: Placeholder()) //* will be quiz screen
            : Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
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

        if (!isQuizing)
          Container(
            height: 60,
            width: double.infinity,
            color: cs.surfaceContainerLow.withAlpha(100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => {
                    setState(() {
                      isQuizing = true;
                    }),
                  },
                  child: const Text('Start Quiz'),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
      ],
    );
  }
}
