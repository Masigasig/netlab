import 'dart:ui' show Offset;
import 'dart:async' show Timer;
import 'dart:collection' show Queue;
import 'package:flutter/material.dart' show WidgetsBinding;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/temp/simulation/network_utils.dart';
import 'package:netlab/temp/simulation/sim_objects/sim_object.dart';
import 'package:netlab/temp/simulation/sim_object_widgets/sim_object_widget.dart';
import 'package:netlab/temp/simulation/sim_screen_state.dart'
    show SimLogsNotifier, SimObjectTypeX, simLogsProvider;

part 'connection_notifier.dart';
part 'device_notifier.dart';
part 'host_notifier.dart';
part 'message_notifier.dart';
part 'router_notifier.dart';
part 'switch_notifier.dart';

abstract class SimObjectNotifier<T extends SimObject> extends Notifier<T> {
  @override
  T build();

  SimLogsNotifier get simLogsNotifier => ref.read(simLogsProvider.notifier);

  ConnectionNotifier connectionNotifier(String connectionId) =>
      ref.read(connectionProvider(connectionId).notifier);

  HostNotifier hostNotifier(String hostId) =>
      ref.read(hostProvider(hostId).notifier);

  MessageNotifier messageNotifier(String messageId) =>
      ref.read(messageProvider(messageId).notifier);

  RouterNotifier routerNotifier(String routerId) =>
      ref.read(routerProvider(routerId).notifier);

  SwitchNotifier switchNotifier(String switchId) =>
      ref.read(switchProvider(switchId).notifier);

  ConnectionMapNotifier get connectionMapNotifier =>
      ref.read(connectionMapProvider.notifier);

  HostMapNotifier get hostMapNotifier => ref.read(hostMapProvider.notifier);

  MessageMapNotifier get messageMapNotifier =>
      ref.read(messageMapProvider.notifier);

  RouterMapNotifier get routerMapNotifier =>
      ref.read(routerMapProvider.notifier);

  SwitchMapNotifier get switchMapNotifier =>
      ref.read(switchMapProvider.notifier);

  DeviceNotifier getDeviceNotifierById(String simObjectId) {
    if (simObjectId.startsWith(SimObjectType.host.label)) {
      return hostNotifier(simObjectId);
    } else if (simObjectId.startsWith(SimObjectType.router.label)) {
      return routerNotifier(simObjectId);
    } else if (simObjectId.startsWith(SimObjectType.switch_.label)) {
      return switchNotifier(simObjectId);
    } else {
      throw Exception('Unknown SimObject Provider for : $simObjectId');
    }
  }

  Device getDeviceById(String simObjectId) {
    if (simObjectId.startsWith(SimObjectType.host.label)) {
      return ref.read(hostProvider(simObjectId));
    } else if (simObjectId.startsWith(SimObjectType.router.label)) {
      return ref.read(routerProvider(simObjectId));
    } else if (simObjectId.startsWith(SimObjectType.switch_.label)) {
      return ref.read(switchProvider(simObjectId));
    } else {
      throw Exception('Unknown SimObject Provider for : $simObjectId');
    }
  }

  void removeSelf();
}

abstract class SimObjectMapNotifier<T extends SimObject>
    extends Notifier<Map<String, T>> {
  @override
  Map<String, T> build() => {};

  void addSimObject(T simObject) => state = {...state, simObject.id: simObject};

  void removeSimObject(String objectId) => state = {...state}..remove(objectId);

  void invalidateSpecificId(String objectId);

  void removeAllState(String objectId);

  void clearState() => state = {};

  List<Map<String, dynamic>> exportToList();

  void importFromList(List<dynamic> list) {
    Map<String, T> newMap = {};
    for (final map in list) {
      final obj = SimObject.fromMap(map);
      newMap[obj.id] = obj as T;
    }
    state = newMap;
  }
}

abstract class SimObjectWidgetNotifier<T extends SimObjectWidget>
    extends Notifier<Map<String, T>> {
  @override
  Map<String, T> build() => {};

  void addSimObjectWidget(T simObjectWidget) =>
      state = {...state, simObjectWidget.simObjectId: simObjectWidget};

  void removeSimObjectWidget(String simObjectId) =>
      state = {...state}..remove(simObjectId);

  void clearState() => state = {};

  void importFromList(List<dynamic> list) {
    Map<String, T> newMap = {};
    for (final map in list) {
      final type = SimObjectType.values.byName(map['type']);
      final widget = SimObjectWidget.fromType(type, map['id']) as T;
      newMap[widget.simObjectId] = widget;
    }
    state = newMap;
  }
}
