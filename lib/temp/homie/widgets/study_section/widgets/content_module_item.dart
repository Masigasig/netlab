import 'package:flutter/material.dart';
import '../models/content_module.dart';
import 'package:netlab/temp/core/constants/app_text.dart';
import 'package:netlab/temp/homie/widgets/study_section/widgets/components/module_type_helpers.dart';

class ContentModuleItem extends StatelessWidget {
  final ContentModule module;
  final VoidCallback onTap;

  const ContentModuleItem({
    super.key,
    required this.module,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: ModuleTypeHelpers.getTypeColor(module.type),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            ModuleTypeHelpers.getActionIcon(module.type),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          module.title,
          style: AppTextStyles.primaryCustom(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          '${module.description} • ${module.duration} min',
          style: AppTextStyles.secondaryCustom(
            fontSize: 12,
            color: const Color(0xB3FFFFFF),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: ModuleTypeHelpers.getTypeColor(module.type),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            ModuleTypeHelpers.getShortTypeLabel(module.type),
            style: AppTextStyles.primaryCustom(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
