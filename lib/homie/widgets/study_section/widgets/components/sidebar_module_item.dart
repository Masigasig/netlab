import 'package:flutter/material.dart';
import '../../models/content_module.dart';
import 'module_type_helpers.dart';

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
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.9),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 13,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${module.duration} min',
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 11,
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
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
