import 'package:flutter/material.dart' hide Router, Switch;
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/core/constants/app_image.dart';
import 'package:netlab/simulation/core/enums.dart';
import 'package:netlab/simulation/model/sim_objects/sim_object.dart'
    show Device, Host, Router, Switch;
import 'package:netlab/simulation/provider/sim_object_notifiers/sim_object_notifier.dart';
import 'package:netlab/simulation/provider/sim_screen_notifier.dart';

part 'connection_widget.dart';
part 'device_widget.dart';
part 'host_widget.dart';
part 'message_widget.dart';
part 'router_widget.dart';
part 'switch_widget.dart';

abstract class SimObjectWidget extends ConsumerStatefulWidget {
  final String simObjectId;

  const SimObjectWidget({super.key, required this.simObjectId});
}

abstract class _SimObjectWidgetState<T extends SimObjectWidget>
    extends ConsumerState<T> {}
