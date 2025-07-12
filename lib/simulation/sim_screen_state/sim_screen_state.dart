import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/simulation/sim_object/sim_object.dart';
import 'package:netlab/simulation/sim_object_widget/sim_object_widget.dart';

export 'package:netlab/simulation/sim_object/sim_object.dart' show SimObjectType, SimObjectTypeX;

part 'device_provider.dart';
part 'device_widget_provider.dart';
part 'connection_provider.dart';
part 'connection_widget_provider.dart';


final wireModeProvider = StateProvider<bool>((ref) => false);
final simScreenState = StateNotifierProvider<SimScreenState, void>(
  (ref) => SimScreenState(ref),
);

class SimScreenState extends StateNotifier<void> {
  final Ref ref;
  SimScreenState(this.ref) : super(null);

  StateController<bool> get _wireModeNotifier =>
      ref.read(wireModeProvider.notifier);
  DeviceNotifier get _deviceNotifier => ref.read(deviceProvider.notifier);
  DeviceWidgetNotifier get _deviceWidgetNotifier =>
      ref.read(deviceWidgetProvider.notifier);
  ConnectionNotifier get _connectionNotifier =>
      ref.read(connectionProvider.notifier);
  ConnectionWidgetNotifier get _connectionWidgetNotifier =>
      ref.read(connectionWidgetProvider.notifier);

  final List<String> _selectedDevices = [];

  void createDevice({
    required SimObjectType type,
    required double posX,
    required double posY,
  }) {
    final simObjectId = DateTime.now().millisecondsSinceEpoch.toString();

    final (simObject, widget) = _createSimObjectAndWidget(
      type: type,
      simObjectId: simObjectId,
      posX: posX,
      posY: posY,
    );

    _deviceNotifier.addDevice(simObject as Device);
    _deviceWidgetNotifier.addDevice(simObjectId, widget as DeviceWidget);
  }

  void createConnection({required String simObjectId}) {
    if (!_wireModeNotifier.state) return;

    // Add device to selection if valid
    if (!_selectedDevices.contains(simObjectId) &&
        _selectedDevices.length < 2) {
      _selectedDevices.add(simObjectId);

      // Only proceed if we have 2 selected devices
      if (_selectedDevices.length == 2) {
        final conA = _selectedDevices[0];
        final conB = _selectedDevices[1];

        // Check for duplicates
        final isDuplicate = _connectionNotifier.state.values.any(
          (conn) =>
              (conn.conA == conA && conn.conB == conB) ||
              (conn.conA == conB && conn.conB == conA),
        );
        if (isDuplicate) {
          _selectedDevices.clear();
          return;
        }

        // Create the connection
        final simObjectId = DateTime.now().millisecondsSinceEpoch.toString();
        final (simObject, widget) = _createSimObjectAndWidget(
          type: SimObjectType.connection,
          simObjectId: simObjectId,
          conA: conA,
          conB: conB,
        );

        _connectionNotifier.addConnection(simObject as Connection);
        _connectionWidgetNotifier.addConnection(
          simObjectId,
          widget as ConnectionWidget,
        );

        toggleWireMode();
      }
    }
  }

  void toggleWireMode() {
    _wireModeNotifier.state = !_wireModeNotifier.state;
    _selectedDevices.clear();
  }

  (SimObject, SimObjectWidget) _createSimObjectAndWidget({
    required SimObjectType type,
    required String simObjectId,
    double posX = 0,
    double posY = 0,
    String conA = '',
    String conB = '',
  }) {
    return switch (type) {
      SimObjectType.host => (
        Host(id: simObjectId, posX: posX, posY: posY),
        HostWidget(simObjectId: simObjectId),
      ),
      SimObjectType.router => (
        Router(id: simObjectId, posX: posX, posY: posY),
        RouterWidget(simObjectId: simObjectId),
      ),
      SimObjectType.switch_ => (
        Switch(id: simObjectId, posX: posX, posY: posY),
        SwitchWidget(simObjectId: simObjectId),
      ),
      SimObjectType.connection => (
        Connection(id: simObjectId, conA: conA, conB: conB),
        ConnectionWidget(simObjectId: simObjectId),
      ),
    };
  }
}
