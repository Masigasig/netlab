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
  final bool isToggleButton;

  const SidebarItem({
    super.key,
    this.icon,
    this.lottiePath,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.isExpanded,
    required this.onTap,
    this.isToggleButton = false,
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
    
    if (!widget.isToggleButton &&
        widget.index >= 0 &&
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
    
    // Different styling based on item type
    Color iconColor = Colors.white;
    FontWeight fontWeight = FontWeight.w400;
    double fontSize = 14;
    
    // Header styling (index -1)
    if (widget.index == -1) {
      fontWeight = FontWeight.w600;
      fontSize = 18;
    }
    // Toggle button styling
    else if (widget.isToggleButton) {
      iconColor = Colors.white70;
    }
    // Regular navigation items
    else if (widget.index >= 0) {
      fontWeight = isSelected ? FontWeight.w600 : FontWeight.w400;
    }

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
            
            // Icon or Lottie animation
            SizedBox(
              width: 24,
              height: 24,
              child: _buildIcon(iconColor),
            ),
            
            // Label
            if (widget.isExpanded) ...[
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
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
        fit: BoxFit.contain,
      );
    }
    
    if (widget.icon != null) {
      return Icon(widget.icon, color: iconColor, size: 20);
    }
    
    return const SizedBox.shrink();
  }
}