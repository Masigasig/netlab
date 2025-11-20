// import 'dart:math';
import 'package:flutter/material.dart' hide Router, Switch;
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/core/constants/app_image.dart';
import 'package:netlab/home/simulation/core/enums.dart';
import 'package:netlab/home/simulation/model/sim_objects/sim_object.dart';
import 'package:netlab/home/simulation/provider/sim_object_notifiers/sim_object_notifier.dart';
import 'package:netlab/home/simulation/provider/sim_screen_notifier.dart';

part 'access_point_widget.dart';
part 'connection_widget.dart';
part 'device_widget.dart';
part 'host_widget.dart';
part 'message_widget.dart';
part 'phone_widget.dart';
part 'router_widget.dart';
part 'switch_widget.dart';
part 'wireless_con_widget.dart';

abstract class SimObjectWidget extends ConsumerStatefulWidget {
  final String simObjectId;

  const SimObjectWidget({super.key, required this.simObjectId});

  factory SimObjectWidget.fromType(SimObjectType type, String simObjectId) {
    switch (type) {
      case SimObjectType.accessPoint:
        return AccessPointWidget(simObjectId: simObjectId);
      case SimObjectType.connection:
        return ConnectionWidget(simObjectId: simObjectId);
      case SimObjectType.host:
        return HostWidget(simObjectId: simObjectId);
      case SimObjectType.message:
        return MessageWidget(simObjectId: simObjectId);
      case SimObjectType.phone:
        return PhoneWidget(simObjectId: simObjectId);
      case SimObjectType.router:
        return RouterWidget(simObjectId: simObjectId);
      case SimObjectType.switch_:
        return SwitchWidget(simObjectId: simObjectId);
      case SimObjectType.wirelessCon:
        return WirelessConWidget(simObjectId: simObjectId);
    }
  }
}

abstract class _SimObjectWidgetState<T extends SimObjectWidget>
    extends ConsumerState<T> {}
