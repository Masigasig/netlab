import 'package:flutter/material.dart';
import '../models/tutorial_section.dart';
import 'package:netlab/temp/core/constants/app_text.dart';

class TutorialSectionCard extends StatelessWidget {
  final TutorialSection section;
  final bool isExpanded;
  final VoidCallback onTap;

  const TutorialSectionCard({
    super.key,
    required this.section,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: isExpanded ? cs.primaryContainer.withAlpha(80) : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cs.primaryContainer.withAlpha(80),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(section.icon, size: 20, color: cs.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.title,
                      style: isExpanded
                          ? AppTextStyles.forSurface(
                              AppTextStyles.bodyMedium,
                              context,
                            ).copyWith(fontWeight: FontWeight.w600)
                          : AppTextStyles.forSurface(
                              AppTextStyles.bodyMedium,
                              context,
                            ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${section.items.length} tutorials',
                      style: AppTextStyles.forPrimary(
                        AppTextStyles.subtitleSmall,
                        context,
                      ).copyWith(color: cs.onSurface.withAlpha(179)),
                    ),
                  ],
                ),
              ),
              Icon(
                isExpanded
                    ? Icons.keyboard_arrow_down_rounded
                    : Icons.keyboard_arrow_right_rounded,
                color: isExpanded
                    ? cs.primaryContainer
                    : cs.onSurface.withAlpha(77),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
