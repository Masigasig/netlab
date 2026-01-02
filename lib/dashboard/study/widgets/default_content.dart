import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/core/components/animations.dart';
import 'package:netlab/core/constants/app_text.dart';
import 'package:netlab/dashboard/study/provider/material_details_notifier.dart';

class DefaultContent extends ConsumerWidget {
  final String chapterId;

  const DefaultContent({super.key, required this.chapterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapterData = ref
        .read(materialDetailProvider.notifier)
        .getChapterData(chapterId);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimationPresets.mediaEntrance(
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withAlpha(77),
                  shape: BoxShape.circle,
                ),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedMortarboard02,
                  color: Theme.of(context).colorScheme.primary,
                  size: 80,
                ),
              ),
            ),

            const SizedBox(height: 20),

            AnimationPresets.titleFadeIn(
              child: Text(
                "Welcome to\n${chapterData['title'] ?? 'Chapter'}",
                style: AppTextStyles.forSurface(
                  AppTextStyles.headerLarge,
                  context,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 12),

            AnimationPresets.textFadeIn(
              delay: 200,
              child: Text(
                'Select a lesson from the left to begin your learning journey',
                style: AppTextStyles.withOpacity(
                  AppTextStyles.forSurface(AppTextStyles.bodyMedium, context),
                  0.6,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 24),

            AnimationPresets.cardEntrance(
              delay: 400,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.secondary.withAlpha(77),
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimationPresets.iconSlide(
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedIdea01,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: AnimationPresets.textFadeIn(
                        delay: 500,
                        child: Text(
                          'Tip: Complete lessons in order for the best experience',
                          style: AppTextStyles.forSurface(
                            AppTextStyles.subtitleMedium,
                            context,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
