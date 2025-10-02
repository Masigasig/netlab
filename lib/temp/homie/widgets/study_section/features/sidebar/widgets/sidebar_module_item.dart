import 'package:flutter/material.dart';
import '../../../core/models/content_module.dart';
import 'package:netlab/temp/core/components/animations.dart';
import '../../../features/modules/helpers/module_type_helpers.dart';
import 'package:netlab/temp/core/constants/app_text.dart';
import '../controllers/sidebar_module_controller.dart';
import '../helpers/sidebar_module_helper.dart';

/// Displays a module item in the sidebar with status indicators
class SidebarModuleItem extends StatefulWidget {
  final ContentModule module;
  final bool isSelected;
  final VoidCallback onTap;
  final int index;
  final String topicId;
  final List<ContentModule> allModules;

  const SidebarModuleItem({
    super.key,
    required this.module,
    required this.isSelected,
    required this.onTap,
    required this.index,
    required this.topicId,
    required this.allModules,
  });

  @override
  State<SidebarModuleItem> createState() => _SidebarModuleItemState();
}

class _SidebarModuleItemState extends State<SidebarModuleItem> {
  late SidebarModuleController _controller;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    _controller = SidebarModuleController(
      topicId: widget.topicId,
      moduleId: widget.module.id,
      moduleIndex: widget.index,
      allModules: widget.allModules,
      onStateChanged: () {
        if (mounted) setState(() {});
      },
    );
    _controller.loadModuleStatus();
  }

  @override
  void didUpdateWidget(SidebarModuleItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload status when the widget updates
    _controller.refresh();
  }

  void _handleTap() {
    if (_controller.canTap()) {
      widget.onTap();
      // Refresh status after tap
      _controller.refresh();
    } else {
      SidebarModuleHelper.showLockedMessage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Loading state
    if (_controller.isLoading) {
      return _buildLoadingState(cs);
    }

    // Main module item
    return AnimationPresets.listItemSlideLeft(
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: widget.isSelected
              ? cs.primary.withAlpha(20)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: widget.isSelected
              ? Border.all(color: cs.primary.withAlpha(51))
              : null,
        ),
        child: Stack(
          children: [
            _buildModuleListTile(cs),

            // Lock overlay for inaccessible modules
            if (!_controller.isAccessible)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: cs.surface.withAlpha(77),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
          ],
        ),
      ),
      index: widget.index,
      staggerDelay: 80,
      duration: const Duration(milliseconds: 500),
    );
  }

  Widget _buildLoadingState(ColorScheme cs) {
    return AnimationPresets.listItemSlideLeft(
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          dense: true,
          leading: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: cs.onSurfaceVariant,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
          title: Container(height: 12, color: cs.onSurfaceVariant),
          subtitle: Container(
            height: 8,
            color: cs.onSurfaceVariant,
            margin: const EdgeInsets.only(top: 4),
          ),
        ),
      ),
      index: widget.index,
      staggerDelay: 80,
      duration: const Duration(milliseconds: 500),
    );
  }

  Widget _buildModuleListTile(ColorScheme cs) {
    final typeColor = ModuleTypeHelpers.getTypeColor(widget.module.type);

    return ListTile(
      dense: true,
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: SidebarModuleHelper.getContainerColor(
            isCompleted: _controller.isCompleted,
            isAccessible: _controller.isAccessible,
            typeColor: typeColor,
            colorScheme: cs,
          ),
          borderRadius: BorderRadius.circular(6),
          border: SidebarModuleHelper.getContainerBorder(
            isCompleted: _controller.isCompleted,
            colorScheme: cs,
          ),
        ),
        child: Icon(
          SidebarModuleHelper.getModuleIcon(
            isCompleted: _controller.isCompleted,
            isAccessible: _controller.isAccessible,
            moduleIcon: widget.module.icon,
          ),
          color: SidebarModuleHelper.getIconColor(
            isCompleted: _controller.isCompleted,
            isAccessible: _controller.isAccessible,
            colorScheme: cs,
          ),
          size: SidebarModuleHelper.getIconSize(
            isCompleted: _controller.isCompleted,
          ),
        ),
      ),
      title: Text(
        widget.module.title,
        style: AppTextStyles.primaryCustom(
          fontSize: 13,
          color: SidebarModuleHelper.getTitleColor(
            isAccessible: _controller.isAccessible,
            isSelected: widget.isSelected,
            colorScheme: cs,
          ),
          fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        children: [
          Text(
            '${widget.module.duration} min',
            style: AppTextStyles.secondaryCustom(
              fontSize: 11,
              color: SidebarModuleHelper.getSubtitleColor(
                isAccessible: _controller.isAccessible,
                colorScheme: cs,
              ),
            ),
          ),
          if (!_controller.isAccessible) ...[
            const SizedBox(width: 6),
            Icon(
              Icons.lock,
              size: 10,
              color: cs.onSurfaceVariant.withAlpha(128),
            ),
          ],
        ],
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: SidebarModuleHelper.getBadgeColor(
            isAccessible: _controller.isAccessible,
            typeColor: typeColor,
            colorScheme: cs,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          ModuleTypeHelpers.getShortTypeLabel(widget.module.type),
          style: AppTextStyles.primaryCustom(
            fontSize: 9,
            color: SidebarModuleHelper.getBadgeTextColor(
              isAccessible: _controller.isAccessible,
              colorScheme: cs,
            ),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      onTap: _handleTap,
    );
  }
}
