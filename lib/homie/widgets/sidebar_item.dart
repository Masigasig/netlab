import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SidebarItem extends StatefulWidget {
  final IconData? icon;
  final String? lottiePath;
  final String label;
  final int index;
  final int selectedIndex;
  final Function(int) onTap;

  const SidebarItem({
    super.key,
    this.icon,
    this.lottiePath,
    required this.label,
    required this.index,
    required this.selectedIndex,
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
    
    if (widget.index >= 0 &&
        widget.index == widget.selectedIndex && 
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
    
    // Icon color for all items
    Color iconColor = Colors.white;

    return InkWell(
      onTap: (widget.index == -1) ? null : () => widget.onTap(widget.index), // Header not clickable
      borderRadius: BorderRadius.circular(8),
      hoverColor: (widget.index == -1) ? Colors.transparent : Colors.white10,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            // Selection indicator (only for navigation items)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 3,
              height: 32,
              decoration: BoxDecoration(
                color: (widget.index >= 0 && isSelected) 
                    ? Colors.white 
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            
            // Icon or Lottie animation with uniform 24x24 size
            SizedBox(
              width: 24,
              height: 24,
              child: _buildIcon(iconColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(Color iconColor) {
    if (widget.lottiePath != null) {
      return Lottie.asset(
        widget.lottiePath!,
        controller: _controller,
        onLoaded: (composition) => _controller.duration = composition.duration,
        width: 24,
        height: 24,
        fit: BoxFit.contain,
      );
    }
    
    if (widget.icon != null) {
      return Icon(widget.icon, color: iconColor, size: 24);
    }
    
    return const SizedBox.shrink();
  }
}