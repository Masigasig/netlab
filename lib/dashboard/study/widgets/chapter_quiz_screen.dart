import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netlab/dashboard/study/provider/material_details_notifier.dart';
import 'package:netlab/dashboard/study/widgets/quiz_screen.dart';

class ChapterQuizScreen extends ConsumerStatefulWidget {
  final String chapterId;

  const ChapterQuizScreen({super.key, required this.chapterId});

  @override
  ConsumerState<ChapterQuizScreen> createState() => _ChapterQuizScreenState();
}

class _ChapterQuizScreenState extends ConsumerState<ChapterQuizScreen> {
  bool isQuizing = false;
  @override
  Widget build(BuildContext context) {
    if (isQuizing) {
      final questions = ref
          .read(materialDetailProvider.notifier)
          .getShuffledQuestionsForChapterQuiz(widget.chapterId);

      return QuizScreen(
        questions: questions,
        onClose: (isPassed) {
          if (isPassed) {
            //*TODO: set the chapter quiz completed
          }
          setState(() {
            isQuizing = false;
          });
        },
      );
    }

    return Center(
      child: Column(
        children: [
          const Text("Chapter Quiz"),

          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () => {
              setState(() {
                isQuizing = true;
              }),
            },
            child: const Text('Let\'s Go'),
          ),
        ],
      ),
    );
  }
}
