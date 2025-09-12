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
                child: Icon(module.icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      module.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                            style: const TextStyle(
                              color: Colors.white,
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
                            color: Colors.white.withValues(alpha: 0.7),
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
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
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
