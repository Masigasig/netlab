import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/core/constants/app_constants.dart' show SimObjectType;

import 'package:netlab/simulation/model/sim_object/sim_object.dart';
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

    final connection = Connection(id: simObjectId, conA: conA, conB: conB);

    addObject(connection);

    final widget = ConnectionWidget(simObjectId: simObjectId);

    ref
        .read(connectionWidgetProvider.notifier)
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

SimObject createSimObject({
  required SimObjectType type,
  required String simObjectId,
  double posX = 0,
  double posY = 0,
  String conA = '',
  String conB = '',
}) {
  switch (type) {
    case SimObjectType.router:
      return Router(id: simObjectId, posX: posX, posY: posY);
    case SimObjectType.switch_:
      return Switch(id: simObjectId, posX: posX, posY: posY);
    case SimObjectType.host:
      return Host(id: simObjectId, posX: posX, posY: posY);
    case SimObjectType.connection:
      return Connection(id: simObjectId, conA: conA, conB: conB);
  }
}

SimObjectWidget createSimObjectWidget({
  required SimObjectType type,
  required String simObjectId,
}) {
  switch (type) {
    case SimObjectType.router:
      return RouterWidget(simObjectId: simObjectId);
    case SimObjectType.host:
      return HostWidget(simObjectId: simObjectId);
    case SimObjectType.switch_:
      return SwitchWidget(simObjectId: simObjectId);
    case SimObjectType.connection:
      return ConnectionWidget(simObjectId: simObjectId);
  }
}

final wireModeProvider = StateNotifierProvider<WireModeNotifier, bool>(
  (ref) => WireModeNotifier(),
);

class WireModeNotifier extends StateNotifier<bool> {
  WireModeNotifier() : super(false);

  final List<String> _selectedDevices = [];

  bool get isWireModeEnabled => state;
  List<String> get selectedDevices => List.unmodifiable(_selectedDevices);

  void toggle() => state = !state;

  void addDevice(String deviceId) {
    if (!_selectedDevices.contains(deviceId) && _selectedDevices.length < 2) {
      _selectedDevices.add(deviceId);
    }
  }

  void clearDevices() {
    _selectedDevices.clear();
  }
}
