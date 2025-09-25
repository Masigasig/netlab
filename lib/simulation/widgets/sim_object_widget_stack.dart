import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/simulation/core/sim_object_type.dart';
import 'package:netlab/simulation/simulation_screen.dart';
import 'package:netlab/simulation/widgets/sim_object_widgets/sim_object_widget.dart'
    show SimObjectWidget;

class SimObjectWidgetStack extends ConsumerWidget {
  final SimObjectType type;
  final NotifierProvider<dynamic, Map<String, SimObjectWidget>> provider;

  const SimObjectWidgetStack({
    super.key,
    required this.type,
    required this.provider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('${type.label}Widget Stack Rebuilt');

    final widgets = ref.watch(provider);

    return SizedBox(
      width: SimulationScreen.canvasSize.width,
      height: SimulationScreen.canvasSize.height,
      child: Stack(children: [...widgets.values]),
    );
  }
}
