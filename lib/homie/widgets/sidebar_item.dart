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
  int _lastSelectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didUpdateWidget(SidebarItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    final isNowSelected = widget.index == widget.selectedIndex;
    final wasSelected = widget.index == oldWidget.selectedIndex;

    if (isNowSelected && !wasSelected) {
      _controller.reset();
      _controller.forward();
    } else if (isNowSelected && widget.selectedIndex != _lastSelectedIndex) {
      _controller.reset();
      _controller.forward();
    }

    if (widget.selectedIndex != oldWidget.selectedIndex) {
      _lastSelectedIndex = oldWidget.selectedIndex;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool selected = widget.index == widget.selectedIndex;

    return InkWell(
      onTap: () => widget.onTap(widget.index),
      borderRadius: BorderRadius.circular(8),
      hoverColor: Colors.white10,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 3,
              height: 32,
              decoration: BoxDecoration(
                color: selected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 24,
              height: 24,
              child: widget.lottiePath != null
                  ? Lottie.asset(
                      widget.lottiePath!,
                      controller: _controller,
                      onLoaded: (composition) {
                        _controller.duration = composition.duration;
                      },
                      fit: BoxFit.contain,
                    )
                  : (widget.icon != null
                      ? Icon(widget.icon, color: Colors.white, size: 20)
                      : const SizedBox.shrink()),
            ),
            if (widget.isExpanded)
              Expanded(
                child: AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w400,
                      ),
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
