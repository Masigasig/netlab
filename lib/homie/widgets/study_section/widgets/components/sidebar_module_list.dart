import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/study_topic.dart';
import '../../models/content_module.dart';
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
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: Border(
          right: BorderSide(
            color: Colors.white.withOpacity(0.1),
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
                const Text(
                  'Modules',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
                .animate()
                .fadeIn(duration: 500.ms, curve: Curves.easeOut)
                .blur(begin: const Offset(0, 2), duration: 500.ms, curve: Curves.easeOut)
                .slideX(begin: -0.3, duration: 500.ms, curve: Curves.easeOutCubic),
                
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                )
                .animate()
                .fadeIn(duration: 400.ms, delay: 200.ms, curve: Curves.easeOut)
                .scale(begin: const Offset(0.8, 0.8), duration: 400.ms, delay: 200.ms, curve: Curves.easeOutBack),
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