import 'package:flutter/material.dart';
import 'package:netlab/temp/homie/widgets/study_section/core/models/content_module.dart';
import 'package:netlab/temp/core/constants/app_text.dart';
import '../helpers/module_type_helpers.dart';

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
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cs.surface.withAlpha(25),
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
            color: cs.onPrimary, // ✅ adapts automatically
            size: 20,
          ),
        ),
        title: Text(
          module.title,
          style: AppTextStyles.forSurface(
            AppTextStyles.primaryCustom(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            context,
          ),
        ),
        subtitle: Text(
          '${module.description} • ${module.duration} min',
          style: AppTextStyles.forSecondary(
            AppTextStyles.secondaryCustom(fontSize: 12),
            context,
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
            style: AppTextStyles.forPrimary(
              AppTextStyles.primaryCustom(
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              context,
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
