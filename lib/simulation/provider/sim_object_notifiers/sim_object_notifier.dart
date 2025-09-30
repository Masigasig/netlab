import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/simulation/core/enums.dart';
import 'package:netlab/simulation/core/ipv4_address_manager.dart';
import 'package:netlab/simulation/model/sim_objects/sim_object.dart';
import 'package:netlab/simulation/widgets/sim_object_widgets/sim_object_widget.dart';

part 'connection_notifier.dart';
part 'device_notifier.dart';
part 'host_notifier.dart';
part 'message_notifier.dart';
part 'router_notifier.dart';
part 'switch_notifier.dart';

abstract class SimObjectNotifier<T extends SimObject> extends Notifier<T> {
  @override
  T build();

  void updateName(String newName) {
    state = state.copyWith(name: newName) as T;
  }
}

abstract class SimObjectMapNotifier<T extends SimObject>
    extends Notifier<Map<String, T>> {
  @override
  Map<String, T> build() => {};

  void addSimObject(T simObject) => state = {...state, simObject.id: simObject};
}

abstract class SimObjectWidgetsNotifier<T extends SimObjectWidget>
    extends Notifier<Map<String, T>> {
  @override
  Map<String, T> build() => {};

  void addSimObjectWidget(T simObjectWidget) =>
      state = {...state, simObjectWidget.simObjectId: simObjectWidget};
}
