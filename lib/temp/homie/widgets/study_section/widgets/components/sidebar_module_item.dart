import 'package:flutter/material.dart';
import '../../models/content_module.dart';
import 'package:netlab/temp/core/components/animations.dart';
import 'module_type_helpers.dart';
import 'package:netlab/temp/core/constants/app_text.dart';
import '../../services/progress_service.dart';

// ignore_for_file: deprecated_member_use
class SidebarModuleItem extends StatefulWidget {
  final ContentModule module;
  final bool isSelected;
  final VoidCallback onTap;
  final int index;
  final String topicId;

  const SidebarModuleItem({
    super.key,
    required this.module,
    required this.isSelected,
    required this.onTap,
    required this.index,
    required this.topicId,
  });

  @override
  State<SidebarModuleItem> createState() => _SidebarModuleItemState();
}

class _SidebarModuleItemState extends State<SidebarModuleItem> {
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadCompletionStatus();
  }

  Future<void> _loadCompletionStatus() async {
    final isCompleted = await ProgressService.isChapterCompleted(widget.topicId, widget.module.id);
    
    if (mounted) {
      setState(() {
        _isCompleted = isCompleted;
      });
    }
  }

  @override
  void didUpdateWidget(SidebarModuleItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload completion status when the widget updates
    _loadCompletionStatus();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnimationPresets.listItemSlideLeft(
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: widget.isSelected ? cs.primary.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: widget.isSelected
              ? Border.all(color: cs.primary.withOpacity(0.2))
              : null,
        ),
        child: Stack(
          children: [
            ListTile(
              dense: true,
              leading: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _isCompleted 
                    ? cs.primary.withOpacity(0.2)
                    : ModuleTypeHelpers.getTypeColor(widget.module.type),
                  borderRadius: BorderRadius.circular(6),
                  border: _isCompleted
                    ? Border.all(color: cs.primary, width: 1.5)
                    : null,
                ),
                child: Icon(
                  _isCompleted ? Icons.check_circle : widget.module.icon,
                  color: _isCompleted ? cs.primary : cs.onPrimary,
                  size: _isCompleted ? 18 : 16
                ),
              ),
              title: Text(
                widget.module.title,
                style: AppTextStyles.primaryCustom(
                  fontSize: 13,
                  color: widget.isSelected
                      ? cs.onSurface.withOpacity(0.9)
                      : cs.onSurface.withOpacity(0.8),
                  fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                '${widget.module.duration} min',
                style: AppTextStyles.secondaryCustom(
                  fontSize: 11,
                  color: cs.onSurfaceVariant.withOpacity(0.7),
                ),
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: ModuleTypeHelpers.getTypeColor(widget.module.type),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  ModuleTypeHelpers.getShortTypeLabel(widget.module.type),
                  style: AppTextStyles.primaryCustom(
                    fontSize: 9,
                    color: cs.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              onTap: () {
                widget.onTap();
                // Check completion status after tap
                _loadCompletionStatus();
              },
            ),
            if (_isCompleted)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 12,
                    color: Colors.white,
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
}