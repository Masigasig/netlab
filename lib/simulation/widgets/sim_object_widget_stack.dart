import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/simulation/core/enums.dart';
import 'package:netlab/simulation/provider/sim_object_notifiers/sim_object_notifier.dart';
import 'package:netlab/simulation/simulation_screen.dart';

class SimObjectWidgetStack extends ConsumerWidget {
  final SimObjectType type;

  const SimObjectWidgetStack({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('${type.label}Widget Stack Rebuilt');

    final provider = switch (type) {
      SimObjectType.connection => connectionWidgetsProvider,
      SimObjectType.host => hostWidgetsProvider,
      SimObjectType.message => messageWidgetsProvider,
      SimObjectType.router => routerWidgetsProvider,
      SimObjectType.switch_ => switchWidgetsProvider,
    };

    final widgets = ref.watch(provider);

    return SizedBox(
      width: SimulationScreen.canvasSize.width,
      height: SimulationScreen.canvasSize.height,
      child: Stack(children: [...widgets.values]),
    );
  }
}
