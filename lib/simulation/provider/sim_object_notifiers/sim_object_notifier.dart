import 'package:flutter/material.dart' show WidgetsBinding;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

import 'package:netlab/simulation/core/enums.dart';
import 'package:netlab/simulation/core/ipv4_address_manager.dart';
import 'package:netlab/simulation/model/sim_objects/sim_object.dart';
import 'package:netlab/simulation/provider/sim_screen_notifier.dart';
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

  void removeSelf();
}

abstract class SimObjectMapNotifier<T extends SimObject>
    extends Notifier<Map<String, T>> {
  final NotifierProvider<
    SimObjectMapNotifier<SimObject>,
    Map<String, SimObject>
  >
  mapProvider;
  final NotifierProviderFamily<SimObjectNotifier<SimObject>, SimObject, String>
  objectProvider;
  final NotifierProvider<
    SimObjectWidgetsNotifier<SimObjectWidget>,
    Map<String, SimObjectWidget>
  >
  widgetsProvider;

  SimObjectMapNotifier({
    required this.mapProvider,
    required this.objectProvider,
    required this.widgetsProvider,
  });

  @override
  Map<String, T> build() => {};

  void addSimObject(T simObject) => state = {...state, simObject.id: simObject};

  void removeSimObject(String objectId) => state = {...state}..remove(objectId);

  void invalidateSpecificId(String objectId) {
    if (ref.read(simScreenProvider).selectedDeviceOnInfo == objectId) {
      ref.read(simScreenProvider.notifier).setSelectedDeviceOnInfo('');
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(objectProvider(objectId));
    });
  }

  void removeAllState(String objectId) {
    ref.read(widgetsProvider.notifier).removeSimObjectWidget(objectId);

    invalidateSpecificId(objectId);
    removeSimObject(objectId);
  }
}

abstract class SimObjectWidgetsNotifier<T extends SimObjectWidget>
    extends Notifier<Map<String, T>> {
  @override
  Map<String, T> build() => {};

  void addSimObjectWidget(T simObjectWidget) =>
      state = {...state, simObjectWidget.simObjectId: simObjectWidget};

  void removeSimObjectWidget(String simObjectId) =>
      state = {...state}..remove(simObjectId);
}
