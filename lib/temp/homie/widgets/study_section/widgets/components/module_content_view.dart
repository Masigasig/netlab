import 'package:flutter/material.dart';
import '../../models/content_module.dart';
import '../../models/study_topic.dart';
import 'module_type_helpers.dart';
import '../../topics/content/content_renderer.dart';
import '../../topics/content/content_registry.dart';

class ModuleContentView extends StatelessWidget {
  final ContentModule module;
  final StudyTopic topic;

  const ModuleContentView({
    super.key,
    required this.module,
    required this.topic,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Module Header
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: ModuleTypeHelpers.getTypeColor(module.type),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(module.icon, color: cs.onPrimary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      module.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface, // 🔹 adapts to theme
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: ModuleTypeHelpers.getTypeColor(module.type),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            ModuleTypeHelpers.getTypeLabel(module.type),
                            style: TextStyle(
                              color: cs.onPrimary, // 🔹 readable always
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${module.duration} minutes',
                          style: TextStyle(
                            fontSize: 14,
                            color: cs.onSurfaceVariant, // 🔹 softer
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow, // 🔹 matches theme
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: cs.outline.withOpacity(0.15), // 🔹 subtle border
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContentRenderer(blocks: ContentRegistry.getContent(module.id)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
