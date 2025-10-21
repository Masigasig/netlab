import 'package:flutter/material.dart';

class FontSizeSelector extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const FontSizeSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Row(
        children: [
          Expanded(
            child: Slider(
              value: value,
              min: 12,
              max: 24,
              divisions: 6,
              label: '${value.toInt()}',
              onChanged: onChanged,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${value.toInt()}',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
