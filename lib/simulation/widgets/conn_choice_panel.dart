import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/core/constants/app_image.dart';
import 'package:netlab/simulation/core/enums.dart';
import 'package:netlab/simulation/model/sim_objects/sim_object.dart';
import 'package:netlab/simulation/provider/sim_object_notifiers/sim_object_notifier.dart';
import 'package:netlab/simulation/provider/sim_screen_notifier.dart';
import 'package:netlab/simulation/simulation_screen.dart';

class ConnChoicePanel extends ConsumerWidget {
  const ConnChoicePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('ConnChoicePanel Rebuilt');

    final selectedId = ref.watch(
      simScreenProvider.select((s) => s.selectedDeviceOnConn),
    );

    if (selectedId.isEmpty) return const Offstage(offstage: true);

    late final Device device;
    late final List<Map<String, String>> connection;

    if (selectedId.startsWith(SimObjectType.host.label)) {
      device = ref.watch(hostProvider(selectedId));
      connection = ref
          .read(hostProvider(selectedId).notifier)
          .getAllConnectionInfo();
    } else if (selectedId.startsWith(SimObjectType.router.label)) {
      device = ref.watch(routerProvider(selectedId));
      connection = ref
          .read(routerProvider(selectedId).notifier)
          .getAllConnectionInfo();
    } else if (selectedId.startsWith(SimObjectType.switch_.label)) {
      device = ref.watch(switchProvider(selectedId));
      connection = ref
          .read(switchProvider(selectedId).notifier)
          .getAllConnectionInfo();
    }

    return Positioned(
      left: device.posX - 55,
      bottom:
          SimulationScreen.canvasSize.height -
          device.posY +
          50, //* half of device widget,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(
          width: 110,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ...connection.map(
                  (entry) => _buildConnectionItem(entry, context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionItem(Map<String, String> entry, BuildContext context) {
    final name = entry[ConnInfoKey.name.name]!;
    final isAvailable = entry[ConnInfoKey.conId.name]!.isEmpty;

    return TextButton(
      onPressed: isAvailable ? () {} : null,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AppImage.ethernet,
            width: 20,
            height: 20,
            color: isAvailable
                ? Theme.of(context).colorScheme.onSurface
                : Colors.green,
          ),

          const SizedBox(width: 16),

          Text(
            name,
            style: TextStyle(
              color: isAvailable
                  ? Theme.of(context).colorScheme.onSurface
                  : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
