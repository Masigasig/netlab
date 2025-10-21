import 'package:flutter/material.dart';

class SettingCard extends StatelessWidget {
  final String label;
  final Widget child;
  final Widget? icon;

  const SettingCard({
    super.key,
    required this.label,
    required this.child,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (icon != null) ...[icon!, const SizedBox(width: 12)],
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
            ),
            const SizedBox(width: 16),
            child,
          ],
        ),
      ),
    );
  }
}
