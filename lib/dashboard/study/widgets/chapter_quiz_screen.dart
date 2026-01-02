import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/core/components/animations.dart';
import 'package:netlab/core/constants/app_text.dart';
import 'package:netlab/dashboard/study/provider/chapter_quiz_notifier.dart';
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
          ref
              .read(chapterQuizStatusProvider.notifier)
              .setChapterQuizCompleted(
                chapterId: widget.chapterId,
                isCompleted: isPassed,
              );

          setState(() {
            isQuizing = false;
          });
        },
      );
    }

    final chapterData = ref
        .read(materialDetailProvider.notifier)
        .getChapterData(widget.chapterId);

    final questionCount = ref
        .read(materialDetailProvider.notifier)
        .getShuffledQuestionsForChapterQuiz(widget.chapterId)
        .length;

    return Center(
      child: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Quiz Icon
              AnimationPresets.mediaEntrance(
                delay: 300,
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withAlpha(77),
                    shape: BoxShape.circle,
                  ),
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedQuiz03,
                    color: Theme.of(context).colorScheme.primary,
                    size: 64,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              AnimationPresets.titleFadeIn(
                delay: 100,
                child: Text(
                  "Chapter Test",
                  style: AppTextStyles.forSurface(
                    AppTextStyles.headerLarge,
                    context,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 8),

              AnimationPresets.textFadeIn(
                delay: 200,
                child: Text(
                  chapterData['title'] ?? '',
                  style: AppTextStyles.withOpacity(
                    AppTextStyles.forSurface(AppTextStyles.bodyMedium, context),
                    0.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 16),

              AnimationPresets.cardEntrance(
                delay: 400,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimationPresets.iconSlide(
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedFile02,
                          color: Theme.of(context).colorScheme.primary,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      AnimationPresets.textFadeIn(
                        delay: 500,
                        child: Text(
                          '$questionCount Questions',
                          style: AppTextStyles.forSurface(
                            AppTextStyles.bodyMedium,
                            context,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      AnimationPresets.iconSlide(
                        delay: 100,
                        slideFrom: 0.3,
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedClock01,
                          color: Theme.of(context).colorScheme.primary,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      AnimationPresets.textFadeIn(
                        delay: 600,
                        child: Text(
                          '~${(questionCount * 1.0).ceil()} min',
                          style: AppTextStyles.forSurface(
                            AppTextStyles.bodyMedium,
                            context,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              AnimationPresets.buttonBounce(
                delay: 700,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isQuizing = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Start Test',
                      style: AppTextStyles.withColor(
                        AppTextStyles.buttonLarge,
                        Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
