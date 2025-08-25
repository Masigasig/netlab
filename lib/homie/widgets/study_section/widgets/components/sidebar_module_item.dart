import 'package:flutter/material.dart';
import '../../models/content_module.dart';
import 'module_type_helpers.dart';
import 'package:netlab/core/constants/app_text.dart';

class SidebarModuleItem extends StatelessWidget {
  final ContentModule module;
  final bool isSelected;
  final VoidCallback onTap;

  const SidebarModuleItem({
    super.key,
    required this.module,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isSelected 
            ? Colors.white.withOpacity(0.1) 
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isSelected 
            ? Border.all(color: Colors.white.withOpacity(0.2)) 
            : null,
      ),
      child: ListTile(
        dense: true,
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: ModuleTypeHelpers.getTypeColor(module.type),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            module.icon,
            color: Colors.white,
            size: 16,
          ),
        ),
        title: Text(
          module.title,
          style: AppTextStyles.primaryCustom(
            fontSize: 13,
            color: isSelected ? Colors.white : const Color(0xE6FFFFFF), // Colors.white with ~90% opacity as solid color
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${module.duration} min',
          style: AppTextStyles.secondaryCustom(
            fontSize: 11,
            color: const Color(0x99FFFFFF), // Colors.white with ~60% opacity as solid color
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: ModuleTypeHelpers.getTypeColor(module.type),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            ModuleTypeHelpers.getShortTypeLabel(module.type),
            style: AppTextStyles.primaryCustom(
              fontSize: 9,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}