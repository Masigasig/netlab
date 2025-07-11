import 'package:flutter/material.dart' hide Router, Switch;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/core/constants/app_image.dart';
import 'package:netlab/core/constants/app_constants.dart';

import 'package:netlab/simulation/model/sim_object/sim_object.dart';

import 'package:netlab/simulation/providers/sim_object_map_provider.dart';

import 'package:netlab/simulation/providers/wire_mode_provider.dart';

part 'device_widget.dart';
part 'router_widget.dart';
part 'switch_widget.dart';
part 'host_widget.dart';
part 'connection_widget.dart';

abstract class SimObjectWidget extends ConsumerStatefulWidget {
  final String simObjectId;

  const SimObjectWidget({super.key, required this.simObjectId});
}

abstract class _SimObjectWidgetState<T extends SimObjectWidget>
    extends ConsumerState<T> {}