import 'package:flutter/material.dart';
import '../../models/content_module.dart';
import 'package:netlab/core/components/animations.dart';
import 'module_type_helpers.dart';
import 'package:netlab/core/constants/app_text.dart';

class SidebarModuleItem extends StatelessWidget {
  final ContentModule module;
  final bool isSelected;
  final VoidCallback onTap;
  final int index;

  const SidebarModuleItem({
    super.key,
    required this.module,
    required this.isSelected,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationPresets.listItemSlideLeft(
      child: Container(
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
              color: isSelected ? Colors.white : const Color(0xE6FFFFFF),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '${module.duration} min',
            style: AppTextStyles.secondaryCustom(
              fontSize: 11,
              color: const Color(0x99FFFFFF),
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
      ),
      index: index,
      staggerDelay: 80,
      duration: const Duration(milliseconds: 500),
    );
  }
}