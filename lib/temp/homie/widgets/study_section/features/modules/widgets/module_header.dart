import 'package:flutter/material.dart';
import '../../../core/models/content_module.dart';
import '../helpers/module_type_helpers.dart';

class ModuleHeader extends StatelessWidget {
  final ContentModule module;
  final bool isCompleted;
  final int currentModuleIndex;
  final int totalModules;

  const ModuleHeader({
    super.key,
    required this.module,
    required this.isCompleted,
    required this.currentModuleIndex,
    required this.totalModules,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        // Module icon
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: ModuleTypeHelpers.getTypeColor(module.type),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            module.icon,
            color: cs.onPrimary,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        
        // Module details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and completion indicator
              Row(
                children: [
                  Expanded(
                    child: Text(
                      module.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                  if (isCompleted)
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 24,
                    ),
                ],
              ),
              const SizedBox(height: 4),
              
              // Metadata row
              Row(
                children: [
                  // Module type badge
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
                        color: cs.onPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // Duration
                  Text(
                    '${module.duration} minutes',
                    style: TextStyle(
                      fontSize: 14,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // Progress indicator
                  Text(
                    '${currentModuleIndex + 1}/$totalModules',
                    style: TextStyle(
                      fontSize: 12,
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}