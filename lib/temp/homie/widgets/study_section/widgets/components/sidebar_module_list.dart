import 'package:flutter/material.dart';
import '../../models/study_topic.dart';
import '../../models/content_module.dart';
import 'package:netlab/temp/core/components/animations.dart';
import 'sidebar_module_item.dart';

class SidebarModuleList extends StatelessWidget {
  final List<ContentModule> modules;
  final int? selectedModuleIndex;
  final StudyTopic topic;
  final Function(int index, ContentModule module) onModuleTap;

  const SidebarModuleList({
    super.key,
    required this.modules,
    required this.selectedModuleIndex,
    required this.topic,
    required this.onModuleTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: cs.surface, // 🔹 background uses surface
        border: Border(
          right: BorderSide(
            color: cs.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimationPresets.iconSlide(
                  child: Text(
                    'Modules',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface.withOpacity(0.9),
                    ),
                  ),
                  delay: 0,
                  duration: const Duration(milliseconds: 500),
                  slideFrom: -0.3,
                ),
                AnimationPresets.buttonBounce(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: topic.cardColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${modules.length}',
                      style: TextStyle(
                        fontSize: 12,
                        color: topic.cardColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  delay: 200,
                  duration: const Duration(milliseconds: 400),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: modules.length,
              itemBuilder: (context, index) {
                return SidebarModuleItem(
                  module: modules[index],
                  isSelected: selectedModuleIndex == index,
                  index: index,
                  onTap: () => onModuleTap(index, modules[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
