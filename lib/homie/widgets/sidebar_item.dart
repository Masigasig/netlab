import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SidebarItem extends StatefulWidget {
  final IconData? icon;
  final String? lottiePath;
  final String label;
  final int index;
  final int selectedIndex;
  final bool isExpanded;
  final Function(int) onTap;

  const SidebarItem({
    super.key,
    this.icon,
    this.lottiePath,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<SidebarItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didUpdateWidget(SidebarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Play animation when item becomes selected
    if (widget.index == widget.selectedIndex && 
        widget.index != oldWidget.selectedIndex) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.index == widget.selectedIndex;

    return InkWell(
      onTap: () => widget.onTap(widget.index),
      borderRadius: BorderRadius.circular(8),
      hoverColor: Colors.white10,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // Selection indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 3,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            
            // Icon or Lottie animation
            SizedBox(
              width: 24,
              height: 24,
              child: _buildIcon(),
            ),
            
            // Label
            if (widget.isExpanded) ...[
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  overflow: TextOverflow.clip,
                  maxLines: 1,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (widget.lottiePath != null) {
      return Lottie.asset(
        widget.lottiePath!,
        controller: _controller,
        onLoaded: (composition) => _controller.duration = composition.duration,
        fit: BoxFit.contain,
      );
    }
    
    if (widget.icon != null) {
      return Icon(widget.icon, color: Colors.white, size: 20);
    }
    
    return const SizedBox.shrink();
  }
}