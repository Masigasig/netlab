import 'package:flutter/material.dart';
import '../models/tutorial_section.dart';
import 'package:netlab/temp/homie/widgets/study_section/features/study_content/services/content_renderer.dart';
import 'package:netlab/temp/core/constants/app_text.dart';

class TutorialContentScreen extends StatelessWidget {
  final TutorialSection section;
  final int itemIndex;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const TutorialContentScreen({
    super.key,
    required this.section,
    required this.itemIndex,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final item = section.items[itemIndex];
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb
          Row(
            children: [
              Icon(section.icon, size: 16, color: cs.primary),
              const SizedBox(width: 8),
              Text(
                section.title,
                style: AppTextStyles.forSurface(
                  AppTextStyles.label,
                  context,
                ).copyWith(color: cs.primary),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                size: 16,
                color: cs.onSurface.withAlpha(80),
              ),
              const SizedBox(width: 8),
              Text(
                'Tutorial ${itemIndex + 1} of ${section.items.length}',
                style: AppTextStyles.forSurface(AppTextStyles.label, context),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Title
          Text(
            item.title,
            style: AppTextStyles.forSurface(
              AppTextStyles.headerLarge.copyWith(letterSpacing: -0.5),
              context,
            ),
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            item.description,
            style: AppTextStyles.forSurface(
              AppTextStyles.bodyLarge.copyWith(height: 1.5),
              context,
            ).copyWith(color: cs.onSurface.withAlpha(179)),
          ),

          const SizedBox(height: 32),

          // Content Area
          ContentRenderer(
            blocks: item.content.getContent(),
            topicId: section.id,
            moduleId:
                '${section.id}_${item.title.toLowerCase().replaceAll(' ', '_')}',
            quizController: null,
          ),

          const SizedBox(height: 32),

          // Navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (onPrevious != null)
                TextButton.icon(
                  onPressed: onPrevious,
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: Text('Previous', style: AppTextStyles.buttonMedium),
                )
              else
                const SizedBox(),
              if (onNext != null)
                TextButton.icon(
                  onPressed: onNext,
                  label: Text('Next', style: AppTextStyles.buttonMedium),
                  icon: const Icon(Icons.arrow_forward, size: 18),
                )
              else
                FilledButton.icon(
                  onPressed: () {},
                  label: Text(
                    'Complete',
                    style: AppTextStyles.buttonMedium.copyWith(
                      color: cs.onPrimary,
                    ),
                  ),
                  icon: const Icon(Icons.check_circle, size: 18),
                  style: FilledButton.styleFrom(
                    backgroundColor: cs.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
