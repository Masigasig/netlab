import 'package:flutter/material.dart' hide Router, Switch;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/core/constants/app_image.dart';

import 'package:netlab/simulation/sim_screen_state/sim_screen_state.dart';

part 'device_widget.dart';
part 'router_widget.dart';
part 'switch_widget.dart';
part 'host_widget.dart';
part 'connection_widget.dart';

abstract class SimObjectWidget extends ConsumerStatefulWidget {
  final String simObjectId;

  const SimObjectWidget({super.key, required this.simObjectId});

  factory SimObjectWidget.fromType(SimObjectType type, String simObjectId) {
    switch (type) {
      case SimObjectType.connection:
        return ConnectionWidget.fromId(simObjectId);
      case SimObjectType.host:
        return HostWidget.fromId(simObjectId);
      case SimObjectType.message:
        throw UnimplementedError(
          'Message widget not implemented',
        ); // TODO: Implement
      case SimObjectType.router:
        return RouterWidget.fromId(simObjectId);
      case SimObjectType.switch_:
        return SwitchWidget.fromId(simObjectId);
    }
  }
}

abstract class _SimObjectWidgetState<T extends SimObjectWidget>
    extends ConsumerState<T> {}
