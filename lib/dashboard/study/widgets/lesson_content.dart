import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import 'package:netlab/dashboard/study/provider/material_content_notifier.dart';
import 'package:netlab/dashboard/study/provider/material_details_notifier.dart';
import 'package:netlab/dashboard/study/provider/lesson_status_notifier.dart';
import 'package:netlab/dashboard/study/provider/lesson_history_notifier.dart';
import 'package:netlab/dashboard/study/provider/study_time_notifier.dart';
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

class _LessonContentState extends ConsumerState<LessonContent>
    with WidgetsBindingObserver {
  late DateTime _entryTime;
  bool isQuizing = false;

  @override
  void initState() {
    super.initState();
    _entryTime = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(lessonHistoryProvider.notifier)
          .addToHistory(widget.chapterId, widget.lessonId);
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void deactivate() {
    final exitTime = DateTime.now();
    final duration = exitTime.difference(_entryTime);
    final seconds = duration.inSeconds;

    final notifier = ref.read(studyTimeProvider.notifier);

    Future(() {
      notifier.addTime(seconds);
    });
    super.deactivate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      final duration = DateTime.now().difference(_entryTime);
      final notifier = ref.read(studyTimeProvider.notifier);
      Future(() {
        notifier.addTime(duration.inSeconds);
      });
      _entryTime = DateTime.now();
    }
  }

  @override
  void didUpdateWidget(covariant LessonContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.lessonId != oldWidget.lessonId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(lessonHistoryProvider.notifier)
            .addToHistory(widget.chapterId, widget.lessonId);
      });
      setState(() {
        isQuizing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

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

      return QuizScreen(
        questions: questions,
        onClose: (isPassed) {
          ref
              .read(lessonStatusProvider.notifier)
              .setLessonCompleted(
                chapterId: widget.chapterId,
                lessonId: widget.lessonId,
                isCompleted: isPassed,
              );

          setState(() {
            isQuizing = false;
          });
        },
      );
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
                  p: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    height: 1.5,
                    color: cs.onSurface,
                  ),
                  h1: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                  h3: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    height: 1.5,
                    color: cs.onSurface,
                  ),
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
}
