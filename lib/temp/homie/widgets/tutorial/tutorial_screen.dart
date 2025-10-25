import 'package:flutter/material.dart';
import 'models/tutorial_section.dart';
import 'data/tutorial_data.dart';
import 'widgets/tutorial_section_card.dart';
import 'widgets/tutorial_item_tile.dart';
import 'widgets/welcome_screen.dart';
import 'widgets/tutorial_content_screen.dart';
import 'package:netlab/temp/core/constants/app_text.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final Set<String> expandedSections = {};
  late final ColorScheme cs = Theme.of(context).colorScheme;
  String? selectedSectionId;
  int? selectedItemIndex;
  late final List<TutorialSection> sections = TutorialData.getSections();

  void toggleSection(String sectionId) {
    setState(() {
      if (expandedSections.contains(sectionId)) {
        expandedSections.remove(sectionId);
      } else {
        expandedSections.add(sectionId);
      }

      if (!expandedSections.contains(sectionId) &&
          selectedSectionId == sectionId) {
        selectedSectionId = null;
        selectedItemIndex = null;
      }
    });
  }

  void selectItem(String sectionId, int index) {
    setState(() {
      selectedSectionId = sectionId;
      selectedItemIndex = index;
      if (!expandedSections.contains(sectionId)) {
        expandedSections.add(sectionId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final selectedSection = selectedSectionId != null
        ? sections.firstWhere((s) => s.id == selectedSectionId)
        : null;

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Container(
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
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tutorial',
                          style: AppTextStyles.forSurface(
                            AppTextStyles.custom(
                              fontSize: 42,
                              height: 1.2,
                              letterSpacing: -1.0,
                              fontWeight: FontWeight.w700,
                            ),
                            context,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Guides to help you master the app',
                          style: AppTextStyles.forSurface(
                            AppTextStyles.bodyMedium.copyWith(height: 1.5),
                            context,
                          ).copyWith(color: cs.onSurface.withAlpha(179)),
                        ),
                      ],
                    ),
                  ),

                  // Topics Label
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
                    child: Text(
                      'Topics',
                      style: AppTextStyles.forSurface(
                        AppTextStyles.label.copyWith(letterSpacing: 0.5),
                        context,
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
                        final isExpanded = expandedSections.contains(
                          section.id,
                        );

                        return Column(
                          children: [
                            TutorialSectionCard(
                              section: section,
                              isExpanded: isExpanded,
                              onTap: () => toggleSection(section.id),
                            ),
                            if (isExpanded) ...[
                              const SizedBox(height: 8),
                              ...List.generate(section.items.length, (
                                itemIndex,
                              ) {
                                final item = section.items[itemIndex];
                                final isSelected =
                                    selectedSectionId == section.id &&
                                    selectedItemIndex == itemIndex;

                                return TutorialItemTile(
                                  item: item,
                                  isSelected: isSelected,
                                  onTap: () =>
                                      selectItem(section.id, itemIndex),
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
            ),

            // Content Area
            Expanded(
              child: selectedSection == null || selectedItemIndex == null
                  ? const WelcomeScreen()
                  : TutorialContentScreen(
                      section: selectedSection,
                      itemIndex: selectedItemIndex!,
                      onPrevious: selectedItemIndex! > 0
                          ? () => selectItem(
                              selectedSectionId!,
                              selectedItemIndex! - 1,
                            )
                          : null,
                      onNext:
                          selectedItemIndex! < selectedSection.items.length - 1
                          ? () => selectItem(
                              selectedSectionId!,
                              selectedItemIndex! + 1,
                            )
                          : null,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
