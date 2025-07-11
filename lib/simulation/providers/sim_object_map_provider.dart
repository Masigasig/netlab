import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/simulation/model/sim_object/sim_object.dart';
import 'package:netlab/simulation/utils/sim_object_creation.dart'
    show createSimObject, createSimObjectWidget;
import 'package:netlab/simulation/widgets/sim_object_widget/sim_object_widget.dart';

final simObjectMapProvider =
    StateNotifierProvider<SimObjectMapNotifier, Map<String, SimObject>>(
      (ref) => SimObjectMapNotifier(ref),
    );

final deviceWidgetProvider =
    StateNotifierProvider<DeviceWidgetNotifier, Map<String, DeviceWidget>>(
      (ref) => DeviceWidgetNotifier(),
    );

final connectionWidgetProvider =
    StateNotifierProvider<
      ConnectionWidgetNotifier,
      Map<String, ConnectionWidget>
    >((ref) => ConnectionWidgetNotifier());

class SimObjectMapNotifier extends StateNotifier<Map<String, SimObject>> {
  final Ref ref;

  SimObjectMapNotifier(this.ref) : super({});

  void addObject(SimObject object) {
    state = {...state, object.id: object};
  }

  void updatePosition(String deviceId, double x, double y) {
    if (state.containsKey(deviceId)) {
      final simObject = state[deviceId]!;
      if (simObject is Device) {
        final updatedDevice = simObject.copyWith(posX: x, posY: y);
        state = {...state, deviceId: updatedDevice};
      }
    }
  }

  void createDevice({
    required SimObjectType type,
    required double posX,
    required double posY,
  }) {
    final simObjectId = DateTime.now().millisecondsSinceEpoch.toString();

    final device = createSimObject(
      type: type,
      simObjectId: simObjectId,
      posX: posX,
      posY: posY,
    );

    addObject(device);

    final widget = createSimObjectWidget(type: type, simObjectId: simObjectId);
    ref
        .read(deviceWidgetProvider.notifier)
        .addDevice(simObjectId, widget as DeviceWidget);
  }

  void createConnection({required String conA, required String conB}) {
    // Prevent duplicate connections (regardless of order)
    final alreadyExists = state.values.any((obj) {
      if (obj is Connection) {
        return (obj.conA == conA && obj.conB == conB) ||
            (obj.conA == conB && obj.conB == conA);
      }
      return false;
    });

    if (alreadyExists) return;

    final simObjectId = DateTime.now().millisecondsSinceEpoch.toString();

    final connection = Connection(
      id: simObjectId,
      conA: conA,
      conB: conB,
    );

    addObject(connection);

    final widget = ConnectionWidget(simObjectId: simObjectId);

    ref.read(connectionWidgetProvider.notifier)
       .addConnection(simObjectId, widget);
  }
}

class DeviceWidgetNotifier extends StateNotifier<Map<String, DeviceWidget>> {
  DeviceWidgetNotifier() : super({});

  void addDevice(String key, DeviceWidget device) {
    state = {...state, key: device};
  }
}

class ConnectionWidgetNotifier
    extends StateNotifier<Map<String, ConnectionWidget>> {
  ConnectionWidgetNotifier() : super({});

  void addConnection(String key, ConnectionWidget connection) {
    state = {...state, key: connection};
  }
}