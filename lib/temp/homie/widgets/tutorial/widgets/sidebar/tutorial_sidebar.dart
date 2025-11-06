import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../models/tutorial_content.dart';
import 'package:netlab/temp/core/constants/app_text.dart';
import 'package:netlab/temp/core/components/animations.dart';

class TutorialSidebar extends StatelessWidget {
  final List<TutorialSection> sections;
  final Set<String> expandedSections;
  final String? selectedSectionId;
  final int? selectedItemIndex;
  final Function(String) onToggleSection;
  final Function(String, int) onSelectItem;

  const TutorialSidebar({
    super.key,
    required this.sections,
    required this.expandedSections,
    required this.selectedSectionId,
    required this.selectedItemIndex,
    required this.onToggleSection,
    required this.onSelectItem,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(
          right: BorderSide(color: cs.outline.withAlpha(70), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimationPresets.titleFadeIn(
                  child: Text(
                    'Tutorial',
                    style: AppTextStyles.forSurface(
                      AppTextStyles.headerLarge.copyWith(
                        fontSize: 42,
                        height: 1.2,
                        letterSpacing: -1.0,
                      ),
                      context,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                AnimationPresets.textFadeIn(
                  delay: 200,
                  child: Text(
                    'Guides to help you master the app',
                    style: AppTextStyles.bodyMedium.copyWith(
                      height: 1.5,
                      color: cs.onSurface.withAlpha(150),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Topics Label
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
            child: Text(
              'TOPICS',
              style: AppTextStyles.bodySmall.copyWith(
                letterSpacing: 0.8,
                color: cs.onSurface.withAlpha(150),
              ),
            ),
          ),

          // Sections List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
              itemCount: sections.length,
              itemBuilder: (context, index) {
                final section = sections[index];
                final isExpanded = expandedSections.contains(section.id);

                return Column(
                  children: [
                    AnimationPresets.listItemSlideLeft(
                      child: TutorialSectionCard(
                        section: section,
                        isExpanded: isExpanded,
                        onTap: () => onToggleSection(section.id),
                      ),
                      index: index,
                    ),
                    if (isExpanded) ...[
                      const SizedBox(height: 8),
                      ...List.generate(section.items.length, (itemIndex) {
                        final item = section.items[itemIndex];
                        final isSelected =
                            selectedSectionId == section.id &&
                            selectedItemIndex == itemIndex;

                        return TutorialItemTile(
                          item: item,
                          isSelected: isSelected,
                          onTap: () => onSelectItem(section.id, itemIndex),
                        );
                      }),
                    ],
                    const SizedBox(height: 12),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Tutorial Section Card
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

    return Material(
      color: isExpanded
          ? cs.primaryContainer.withAlpha(30)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: cs.primaryContainer.withAlpha(50),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: section.isHugeIcon
                    ? HugeIcon(icon: section.icon, size: 20, color: cs.primary)
                    : Icon(section.icon, size: 20, color: cs.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: isExpanded
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${section.items.length} tutorial${section.items.length != 1 ? 's' : ''}',
                      style: AppTextStyles.forSurface(
                        AppTextStyles.bodySmall,
                        context,
                        // opacity: 0.6,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isExpanded
                    ? Icons.keyboard_arrow_down_rounded
                    : Icons.keyboard_arrow_right_rounded,
                color: cs.onSurface.withAlpha(40),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Tutorial Item Tile
class TutorialItemTile extends StatelessWidget {
  final TutorialItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const TutorialItemTile({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? cs.primaryContainer.withAlpha(50)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                item.isHugeIcon
                    ? HugeIcon(
                        icon: item.icon,
                        size: 18,
                        color: isSelected
                            ? cs.primary
                            : cs.onSurface.withAlpha(60),
                      )
                    : Icon(
                        item.icon,
                        size: 18,
                        color: isSelected
                            ? cs.primary
                            : cs.onSurface.withAlpha(60),
                      ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.title,
                    style: isSelected
                        ? AppTextStyles.forPrimary(
                            AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            context,
                          )
                        : AppTextStyles.forSurface(
                            AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                            context,
                          ).copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withAlpha(180),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
