import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class SimulationControls extends StatelessWidget {
  final VoidCallback onCenterView;
  final VoidCallback onExit;

  const SimulationControls({
    super.key,
    required this.onCenterView,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('SimulationControls Widget Rebuilt');
    return Positioned(
      top: 0,
      bottom: 0,
      right: 10,
      child: Center(
        child: Wrap(
          direction: Axis.vertical,
          spacing: 8,
          children: [
            _ControlIconButton(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedArrowLeft02,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: onExit,
              activeColor: Theme.of(context).colorScheme.primary,
              disabledColor: Colors.grey.shade400,
              isDisabled: false,
            ),

            _ControlIconButton(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedKeyframeAlignCenter,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: onCenterView,
              activeColor: Theme.of(context).colorScheme.primary,
              disabledColor: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;
  final bool isDisabled;
  final Color activeColor;
  final Color disabledColor;

  const _ControlIconButton({
    required this.icon,
    required this.onPressed,
    this.isDisabled = false,
    required this.activeColor,
    required this.disabledColor,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: isDisabled ? null : onPressed,
      icon: icon,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          isDisabled ? disabledColor : activeColor,
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
