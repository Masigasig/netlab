import 'package:ulid/ulid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/simulation/core/sim_object_type.dart';
import 'package:netlab/simulation/core/mac_address_manager.dart';
import 'package:netlab/simulation/model/sim_objects/sim_object.dart';
import 'package:netlab/simulation/model/sim_screen.dart';
import 'package:netlab/simulation/provider/sim_clock.dart';
import 'package:netlab/simulation/provider/sim_object_notifiers/sim_object_notifier.dart';
import 'package:netlab/simulation/widgets/sim_object_widgets/sim_object_widget.dart';

final simScreenProvider = NotifierProvider<SimScreenNotifier, SimScreen>(
  SimScreenNotifier.new,
);

class SimScreenNotifier extends Notifier<SimScreen> {
  final Map<SimObjectType, int> _typeCounters = {};
  final List<Map<String, String>> _selectedDevices = [];

  @override
  SimScreen build() {
    ref.onDispose(() {
      _typeCounters.clear();
      _selectedDevices.clear();
    });
    return const SimScreen();
  }

  void playSimulation() {
    state = state.copyWith(
      isPlaying: true,
      isDevicePanelOpen: false,
      isLogPanelOpen: false,
      isConnectionModeOn: false,
      isMessageModeOn: false,
      selectedDeviceOnConn: '',
      selectedDeviceOnInfo: '',
    );

    ref.read(simClockProvider.notifier).start();
  }

  void stopSimulation() {
    ref.read(simClockProvider.notifier).reset();

    state = state.copyWith(isPlaying: false);
  }

  void openDevicePanel() {
    state = state.copyWith(isDevicePanelOpen: true);
  }

  void closeDevicePanel() {
    state = state.copyWith(isDevicePanelOpen: false);
  }

  void openLogPanel() {
    state = state.copyWith(isLogPanelOpen: true);
  }

  void closeLogPanel() {
    state = state.copyWith(isLogPanelOpen: false);
  }

  void toggleConnectionMode() {
    _selectedDevices.clear();
    state = state.copyWith(
      isConnectionModeOn: !state.isConnectionModeOn,
      isMessageModeOn: false,
      selectedDeviceOnConn: '',
    );
  }

  void toggleMessageMode() {
    _selectedDevices.clear();
    state = state.copyWith(
      isMessageModeOn: !state.isMessageModeOn,
      isConnectionModeOn: false,
      selectedDeviceOnConn: '',
    );
  }

  void createDevice({
    required SimObjectType type,
    required double posX,
    required double posY,
  }) {
    final name = '${type.label} ${_getNextCounter(type)}';

    final device = type.createSimObject(name: name, posX: posX, posY: posY);

    final deviceWidget = type.createSimObjectWidget(device.id);

    _addSimObjectAndWidgetToProvider(type, device, deviceWidget);
  }

  void createConnection(String deviceId, String conName) {
    //* TODO: finish this
    if (!state.isConnectionModeOn) return;

    _selectedDevices.add({'id': deviceId, 'name': conName});

    if (_selectedDevices.length == 2) {
      final conAId = _selectedDevices[0]['id']!;
      final conAName = _selectedDevices[0]['name']!;
      final conBId = _selectedDevices[1]['id']!;
      final conBName = _selectedDevices[1]['name']!;

      if (conAId == conBId) {
        toggleConnectionMode();
        return;
      }

      final connection = SimObjectType.connection.createSimObject(
        name:
            '${SimObjectType.connection.label} ${_getNextCounter(SimObjectType.connection)}',
        conAId: conAId,
        conBId: conBId,
      );

      final connectionWidget = SimObjectType.connection.createSimObjectWidget(
        connection.id,
      );
    }
  }

  int _getNextCounter(SimObjectType type) {
    _typeCounters[type] = (_typeCounters[type] ?? 0) + 1;
    return _typeCounters[type]!;
  }

  void _addSimObjectAndWidgetToProvider(
    SimObjectType type,
    SimObject object,
    SimObjectWidget widget,
  ) {
    switch (type) {
      case SimObjectType.connection:
        ref
            .read(connectionMapProvider.notifier)
            .addSimObject(object as Connection);
        ref
            .read(connectionWidgetsProvider.notifier)
            .addSimObjectWidget(widget as ConnectionWidget);
      case SimObjectType.host:
        ref.read(hostMapProvider.notifier).addSimObject(object as Host);
        ref
            .read(hostWidgetsProvider.notifier)
            .addSimObjectWidget(widget as HostWidget);
      case SimObjectType.message:
        ref.read(messageMapProvider.notifier).addSimObject(object as Message);
        ref
            .read(messageWidgetsProvider.notifier)
            .addSimObjectWidget(widget as MessageWidget);
      case SimObjectType.router:
        ref.read(routerMapProvider.notifier).addSimObject(object as Router);
        ref
            .read(routerWidgetsProvider.notifier)
            .addSimObjectWidget(widget as RouterWidget);
      case SimObjectType.switch_:
        ref.read(switchMapProvider.notifier).addSimObject(object as Switch);
        ref
            .read(switchWidgetsProvider.notifier)
            .addSimObjectWidget(widget as SwitchWidget);
    }
  }
}

extension SimObjectCreation on SimObjectType {
  String generatePrefixedId() => '${label}_${Ulid().toUuid()}';

  SimObjectWidget createSimObjectWidget(String simObjectId) {
    return switch (this) {
      SimObjectType.connection => ConnectionWidget(simObjectId: simObjectId),
      SimObjectType.host => HostWidget(simObjectId: simObjectId),
      SimObjectType.message => MessageWidget(simObjectId: simObjectId),
      SimObjectType.router => RouterWidget(simObjectId: simObjectId),
      SimObjectType.switch_ => SwitchWidget(simObjectId: simObjectId),
    };
  }

  SimObject createSimObject({
    required String name,
    double posX = 0,
    double posY = 0,
    String conAId = '',
    String conBId = '',
    String srcId = '',
    String dstId = '',
  }) {
    final id = generatePrefixedId();

    return switch (this) {
      SimObjectType.connection => Connection(
        id: id,
        name: name,
        conAId: conAId,
        conBId: conBId,
      ),
      SimObjectType.host => Host(
        id: id,
        name: name,
        posX: posX,
        posY: posY,
        macAddress: MacAddressManager.generateMacAddress(),
      ),
      SimObjectType.message => Message(
        id: id,
        name: name,
        srcId: srcId,
        dstId: dstId,
      ),
      SimObjectType.router => Router(
        id: id,
        name: name,
        posX: posX,
        posY: posY,
        eth0MacAddress: MacAddressManager.generateMacAddress(),
        eth1MacAddress: MacAddressManager.generateMacAddress(),
        eth2MacAddress: MacAddressManager.generateMacAddress(),
        eth3MacAddress: MacAddressManager.generateMacAddress(),
      ),
      SimObjectType.switch_ => Switch(
        id: id,
        name: name,
        posX: posX,
        posY: posY,
      ),
    };
  }
}
