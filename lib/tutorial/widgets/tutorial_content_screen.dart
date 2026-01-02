import 'package:flutter/material.dart';

import 'package:netlab/tutorial/models/tutorial_content.dart';

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
          right: BorderSide(color: cs.outline.withAlpha(26), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tutorial',
                  style: TextStyle(
                    fontSize: 42,
                    height: 1.2,
                    letterSpacing: -1.0,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Guides to help you master the app',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: cs.onSurface.withAlpha(179),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
            child: Text(
              'TOPICS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: cs.onSurface.withAlpha(128),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
              itemCount: sections.length,
              itemBuilder: (context, index) {
                final section = sections[index];
                final isExpanded = expandedSections.contains(section.id);

                return Column(
                  children: [
                    TutorialSectionCard(
                      section: section,
                      isExpanded: isExpanded,
                      onTap: () => onToggleSection(section.id),
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
          ? cs.primaryContainer.withAlpha(77)
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
                  color: cs.primaryContainer.withAlpha(128),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(section.icon, size: 20, color: cs.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isExpanded
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${section.items.length} tutorial${section.items.length != 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurface.withAlpha(153),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isExpanded
                    ? Icons.keyboard_arrow_down_rounded
                    : Icons.keyboard_arrow_right_rounded,
                color: cs.onSurface.withAlpha(102),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
                  ? cs.primaryContainer.withAlpha(128)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 18,
                  color: isSelected ? cs.primary : cs.onSurface.withAlpha(153),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected
                          ? cs.primary
                          : cs.onSurface.withAlpha(204),
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
