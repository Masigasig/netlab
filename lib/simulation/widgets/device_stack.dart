import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netlab/core/constants/app_constants.dart';

import 'package:netlab/simulation/providers/device_stack_provider.dart';

class DeviceStack extends ConsumerWidget {
  const DeviceStack({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('DeviceStack rebuilding');
    final devices = ref.watch(deviceStackProvider);

    return SizedBox(
      width: AppConstants.canvasSize,
      height: AppConstants.canvasSize,
      child: Stack(children: [...devices.values]),
    );
  }
}
