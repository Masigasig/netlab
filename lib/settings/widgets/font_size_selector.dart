import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/settings/providers/settings_provider.dart';

class FontSizeSelector extends ConsumerWidget {
  const FontSizeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(fontMultiplierProvider);

    return SizedBox(
      width: 200,
      child: Row(
        children: [
          Expanded(
            child: Slider(
              value: value,
              min: 0.5,
              max: 1.5,
              divisions: 4,
              label: '${value.toStringAsFixed(2)}x',
              onChanged: (v) {
                ref.read(fontMultiplierProvider.notifier).setMultiplier(v);
              },
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${value.toStringAsFixed(2)}x',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
