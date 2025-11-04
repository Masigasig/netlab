import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import 'package:netlab/dashboard/study/provider/material_content_notifier.dart';
import 'package:netlab/dashboard/study/provider/material_details_notifier.dart';
import 'package:netlab/dashboard/study/provider/quiz_state_notifier.dart';
import 'package:netlab/dashboard/study/widgets/quiz_screen.dart';

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
  @override
  void didUpdateWidget(covariant LessonContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.lessonId != oldWidget.lessonId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(quizStateProvider.notifier).setQuizState(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isQuizing = ref.watch(quizStateProvider);

    final lessonContent = ref
        .read(materialContentProvider.notifier)
        .getLessonContent(widget.chapterId, widget.lessonId);

    if (isQuizing) {
      final questions = ref
          .read(materialDetailProvider.notifier)
          .getShuffledQuestionForShortQuiz(
            chapterId: widget.chapterId,
            lessonId: widget.lessonId,
          );

      return QuizScreen(questions: questions);
    } else {
      return Column(
        children: [
          Expanded(
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

          Container(
            height: 60,
            width: double.infinity,
            color: cs.surfaceContainerLow.withAlpha(100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => {
                    ref.read(quizStateProvider.notifier).setQuizState(true),
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
}
