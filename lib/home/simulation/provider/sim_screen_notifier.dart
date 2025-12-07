import 'package:ulid/ulid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart' show WidgetsBinding;

import 'package:netlab/home/simulation/core/enums.dart';
import 'package:netlab/home/simulation/core/ipv4_address_manager.dart';
import 'package:netlab/home/simulation/core/mac_address_manager.dart';
import 'package:netlab/home/simulation/model/sim_objects/sim_object.dart';
import 'package:netlab/home/simulation/model/log_entry.dart';
import 'package:netlab/home/simulation/model/sim_screen.dart';
import 'package:netlab/home/simulation/provider/logs_notifier.dart';
import 'package:netlab/home/simulation/provider/sim_clock.dart';
import 'package:netlab/home/simulation/provider/sim_object_notifiers/sim_object_notifier.dart';
import 'package:netlab/home/simulation/widgets/sim_object_widgets/sim_object_widget.dart';

final simScreenProvider = NotifierProvider<SimScreenNotifier, SimScreen>(
  SimScreenNotifier.new,
);

class SimScreenNotifier extends Notifier<SimScreen> {
  final Map<SimObjectType, int> _typeCounters = {};
  final List<Map<String, String>> _selectedDevices = [];
  Map<String, dynamic> _tempMap = {};
  String _tempSelectedDeviceOnInfo = '';

  @override
  SimScreen build() {
    ref.onDispose(() {
      _typeCounters.clear();
      _selectedDevices.clear();
      _tempMap = {};
      _tempSelectedDeviceOnInfo = '';
    });
    return const SimScreen();
  }

  void playSimulation() {
    _tempMap = exportSimulation();
    _tempSelectedDeviceOnInfo = state.selectedDeviceOnInfo;

    final messageIds = ref.read(messageMapProvider).keys;
    final hostsIds = <String>{};
    for (final messageId in messageIds) {
      final message = ref.read(messageProvider(messageId));
      if (message.srcId.startsWith(SimObjectType.host.label)) {
        final host = ref.read(hostProvider(message.srcId));
        ref
            .read(messageProvider(messageId).notifier)
            .updatePosition(host.posX, host.posY);
      } else if (message.srcId.startsWith(SimObjectType.wirelessHost.label)) {
        final wirelessHost = ref.read(wirelessHostProvider(message.srcId));

        ref
            .read(messageProvider(messageId).notifier)
            .updatePosition(wirelessHost.posX, wirelessHost.posY);
      }

      hostsIds.add(message.srcId);
    }

    _selectedDevices.clear();

    state = state.copyWith(
      isPlaying: true,
      isDevicePanelOpen: false,
      isConnectionModeOn: false,
      isMessageModeOn: false,
      selectedDeviceOnConn: '',
    );

    ref.read(simClockProvider.notifier).start();
    final time = ref.read(simClockProvider.notifier).elapsedTime();
    ref
        .read(systemLogProvider.notifier)
        .addLog(
          LogEntry(
            message: 'Simulation started',
            time: time,
            type: LogType.info,
          ),
        );

    for (final hostId in hostsIds) {
      if (hostId.startsWith(SimObjectType.host.label)) {
        ref.read(hostProvider(hostId).notifier).startMessageProcessing();
      } else if (hostId.startsWith(SimObjectType.wirelessHost.label)) {
        ref
            .read(wirelessHostProvider(hostId).notifier)
            .startMessageProcessing();
      }
    }
  }

  void stopSimulation() {
    final time = ref.read(simClockProvider.notifier).elapsedTime();
    ref
        .read(systemLogProvider.notifier)
        .addLog(
          LogEntry(
            message: 'Simulation stopped',
            time: time,
            type: LogType.info,
          ),
        );
    ref.read(simClockProvider.notifier).reset();

    ref.invalidate(connectionWidgetsProvider);
    ref.invalidate(messageWidgetsProvider);
    ref.invalidate(hostWidgetsProvider);
    ref.invalidate(switchWidgetsProvider);
    ref.invalidate(routerWidgetsProvider);

    state = state.copyWith(
      isPlaying: false,
      isInfoPanelOpen: false,
      selectedDeviceOnInfo: '',
    );
    _typeCounters.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Ipv4AddressManager.clearStorage();
      MacAddressManager.clearStorage();

      ref.invalidate(connectionProvider);
      ref.invalidate(messageProvider);
      ref.invalidate(hostProvider);
      ref.invalidate(switchProvider);
      ref.invalidate(routerProvider);

      ref.invalidate(connectionMapProvider);
      ref.invalidate(messageMapProvider);
      ref.invalidate(hostMapProvider);
      ref.invalidate(switchMapProvider);
      ref.invalidate(routerMapProvider);

      importSimulation(_tempMap);
      _tempMap.clear();

      setSelectedDeviceOnInfo(_tempSelectedDeviceOnInfo);
      openInfoPanel();

      _tempSelectedDeviceOnInfo = '';
    });
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

  void openInfoPanel() {
    state = state.copyWith(isInfoPanelOpen: true);
  }

  void closeInfoPanel() {
    state = state.copyWith(isInfoPanelOpen: false);
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

  void setSelectedDeviceOnConn(String deviceId) {
    if (state.selectedDeviceOnConn == deviceId) {
      state = state.copyWith(selectedDeviceOnConn: '');
    } else {
      state = state.copyWith(selectedDeviceOnConn: deviceId);
    }
  }

  void setSelectedDeviceOnInfo(String deviceId) {
    if (state.selectedDeviceOnInfo == deviceId) {
      state = state.copyWith(selectedDeviceOnInfo: '');
    } else {
      state = state.copyWith(selectedDeviceOnInfo: deviceId);
    }
  }

  void setMessageSpeed(double newSpeed) {
    state = state.copyWith(messageSpeed: newSpeed);
  }

  void setArpReqTimeout(double seconds) {
    state = state.copyWith(arpReqTimeout: seconds);
  }

  void clearAll() {
    ref.invalidate(connectionWidgetsProvider);
    ref.invalidate(wirelessConWidgetsProvider);
    ref.invalidate(messageWidgetsProvider);
    ref.invalidate(hostWidgetsProvider);
    ref.invalidate(wirelessHostWidgetsProvider);
    ref.invalidate(switchWidgetsProvider);
    ref.invalidate(accessPointWidgetsProvider);
    ref.invalidate(routerWidgetsProvider);

    ref.invalidateSelf();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Ipv4AddressManager.clearStorage();
      MacAddressManager.clearStorage();

      ref.invalidate(simObjectLogProvider);
      ref.invalidate(systemLogProvider);
      ref.invalidate(simClockProvider);

      ref.invalidate(connectionProvider);
      ref.invalidate(wirelessConProvider);
      ref.invalidate(messageProvider);
      ref.invalidate(hostProvider);
      ref.invalidate(wirelessHostProvider);
      ref.invalidate(switchProvider);
      ref.invalidate(accessPointProvider);
      ref.invalidate(routerProvider);

      ref.invalidate(connectionMapProvider);
      ref.invalidate(wirelessConMapProvider);
      ref.invalidate(messageMapProvider);
      ref.invalidate(hostMapProvider);
      ref.invalidate(wirelessHostMapProvider);
      ref.invalidate(switchMapProvider);
      ref.invalidate(accessPointMapProvider);
      ref.invalidate(routerMapProvider);
    });
  }

  void importSimulation(Map<String, dynamic> data) {
    final countersMap = data['typeCounters'] as Map<String, dynamic>;
    countersMap.forEach((key, value) {
      final type = SimObjectType.values.firstWhere((t) => t.name == key);
      _typeCounters[type] = value as int;
    });

    Ipv4AddressManager.importStorage(data['Ipv4Address']);
    MacAddressManager.importStorage(data['MacAddress']);

    final accessPointList = List.from(data['accessPoints']);
    final connectionList = List.from(data['connections']);
    final hostList = List.from(data['hosts']);
    final messageList = List.from(data['messages']);
    final routerList = List.from(data['routers']);
    final switchList = List.from(data['switches']);
    final wirelessConList = List.from(data['wirelessCons']);
    final wirelessHostList = List.from(data['wirelessHosts']);

    ref.read(accessPointMapProvider.notifier).importFromList(accessPointList);
    ref.read(connectionMapProvider.notifier).importFromList(connectionList);
    ref.read(hostMapProvider.notifier).importFromList(hostList);
    ref.read(messageMapProvider.notifier).importFromList(messageList);
    ref.read(routerMapProvider.notifier).importFromList(routerList);
    ref.read(switchMapProvider.notifier).importFromList(switchList);
    ref.read(wirelessConMapProvider.notifier).importFromList(wirelessConList);
    ref.read(wirelessHostMapProvider.notifier).importFromList(wirelessHostList);

    ref
        .read(accessPointWidgetsProvider.notifier)
        .importFromList(accessPointList);
    ref.read(connectionWidgetsProvider.notifier).importFromList(connectionList);
    ref.read(hostWidgetsProvider.notifier).importFromList(hostList);
    ref.read(messageWidgetsProvider.notifier).importFromList(messageList);
    ref.read(routerWidgetsProvider.notifier).importFromList(routerList);
    ref.read(switchWidgetsProvider.notifier).importFromList(switchList);
    ref
        .read(wirelessConWidgetsProvider.notifier)
        .importFromList(wirelessConList);
    ref
        .read(wirelessHostWidgetsProvider.notifier)
        .importFromList(wirelessHostList);
  }

  Map<String, dynamic> exportSimulation() {
    return {
      'typeCounters': _typeCounters.map(
        (key, value) => MapEntry(key.name, value),
      ),
      'Ipv4Address': Ipv4AddressManager.exportStorage(),
      'MacAddress': MacAddressManager.exportStorage(),
      'accessPoints': ref.read(accessPointMapProvider.notifier).exportToList(),
      'connections': ref.read(connectionMapProvider.notifier).exportToList(),
      'hosts': ref.read(hostMapProvider.notifier).exportToList(),
      'messages': ref.read(messageMapProvider.notifier).exportToList(),
      'routers': ref.read(routerMapProvider.notifier).exportToList(),
      'switches': ref.read(switchMapProvider.notifier).exportToList(),
      'wirelessCons': ref.read(wirelessConMapProvider.notifier).exportToList(),
      'wirelessHosts': ref
          .read(wirelessHostMapProvider.notifier)
          .exportToList(),
    };
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

      if (conAId.startsWith(SimObjectType.accessPoint.label)) {
        ref
            .read(accessPointProvider(conAId).notifier)
            .updatePort0conId(connection.id);
      } else if (conAId.startsWith(SimObjectType.host.label)) {
        ref
            .read(hostProvider(conAId).notifier)
            .updateConnectionId(connection.id);
      } else if (conAId.startsWith(SimObjectType.router.label)) {
        ref
            .read(routerProvider(conAId).notifier)
            .updateConIdByEthName(conAName, connection.id);
      } else if (conAId.startsWith(SimObjectType.switch_.label)) {
        ref
            .read(switchProvider(conAId).notifier)
            .updateConIdByPortName(conAName, connection.id);
      }

      if (conBId.startsWith(SimObjectType.accessPoint.label)) {
        ref
            .read(accessPointProvider(conBId).notifier)
            .updatePort0conId(connection.id);
      } else if (conBId.startsWith(SimObjectType.host.label)) {
        ref
            .read(hostProvider(conBId).notifier)
            .updateConnectionId(connection.id);
      } else if (conBId.startsWith(SimObjectType.router.label)) {
        ref
            .read(routerProvider(conBId).notifier)
            .updateConIdByEthName(conBName, connection.id);
      } else if (conBId.startsWith(SimObjectType.switch_.label)) {
        ref
            .read(switchProvider(conBId).notifier)
            .updateConIdByPortName(conBName, connection.id);
      }

      _addSimObjectAndWidgetToProvider(
        SimObjectType.connection,
        connection,
        connectionWidget,
      );

      toggleConnectionMode();
    }
  }

  String createWirelessConnection(String fromDeviceId, String toDeviceId) {
    final wirelessCon = SimObjectType.wirelessCon.createSimObject(
      name:
          '${SimObjectType.wirelessCon.label} ${_getNextCounter(SimObjectType.wirelessCon)}',
      conAId: fromDeviceId,
      conBId: toDeviceId,
    );

    final wirelessConWidget = SimObjectType.wirelessCon.createSimObjectWidget(
      wirelessCon.id,
    );

    _addSimObjectAndWidgetToProvider(
      SimObjectType.wirelessCon,
      wirelessCon,
      wirelessConWidget,
    );

    return wirelessCon.id;
  }

  void createMessage(String hostId) {
    if (!state.isMessageModeOn) return;
    if (!hostId.startsWith(SimObjectType.host.label) &&
        !hostId.startsWith(SimObjectType.wirelessHost.label)) {
      return;
    }

    _selectedDevices.add({'id': hostId});

    if (_selectedDevices.length == 2) {
      final hostId1 = _selectedDevices[0]['id']!;
      final hostId2 = _selectedDevices[1]['id']!;

      if (hostId1 == hostId2) {
        toggleMessageMode();
        return;
      }

      final message = SimObjectType.message.createSimObject(
        name:
            '${SimObjectType.message.label} ${_getNextCounter(SimObjectType.message)}',
        srcId: hostId1,
        dstId: hostId2,
      );

      final messageWidget = SimObjectType.message.createSimObjectWidget(
        message.id,
      );

      _addSimObjectAndWidgetToProvider(
        SimObjectType.message,
        message,
        messageWidget,
      );

      ref
          .read(messageProvider(message.id).notifier)
          .updateCurrentPlaceId(hostId1);

      if (hostId1.startsWith(SimObjectType.host.label)) {
        ref.read(hostProvider(hostId1).notifier).enqueueMessage(message.id);
      } else if (hostId1.startsWith(SimObjectType.wirelessHost.label)) {
        ref
            .read(wirelessHostProvider(hostId1).notifier)
            .enqueueMessage(message.id);
      }

      toggleMessageMode();
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
      case SimObjectType.accessPoint:
        ref
            .read(accessPointMapProvider.notifier)
            .addSimObject(object as AccessPoint);
        ref
            .read(accessPointWidgetsProvider.notifier)
            .addSimObjectWidget(widget as AccessPointWidget);
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
      case SimObjectType.wirelessCon:
        ref
            .read(wirelessConMapProvider.notifier)
            .addSimObject(object as WirelessCon);
        ref
            .read(wirelessConWidgetsProvider.notifier)
            .addSimObjectWidget(widget as WirelessConWidget);
      case SimObjectType.wirelessHost:
        ref
            .read(wirelessHostMapProvider.notifier)
            .addSimObject(object as WirelessHost);
        ref
            .read(wirelessHostWidgetsProvider.notifier)
            .addSimObjectWidget(widget as WirelessHostWidget);
    }
  }
}

extension SimObjectCreation on SimObjectType {
  String generatePrefixedId() => '${label}_${Ulid().toUuid()}';

  SimObjectWidget createSimObjectWidget(String simObjectId) {
    return switch (this) {
      SimObjectType.accessPoint => AccessPointWidget(simObjectId: simObjectId),
      SimObjectType.connection => ConnectionWidget(simObjectId: simObjectId),
      SimObjectType.host => HostWidget(simObjectId: simObjectId),
      SimObjectType.message => MessageWidget(simObjectId: simObjectId),
      SimObjectType.router => RouterWidget(simObjectId: simObjectId),
      SimObjectType.switch_ => SwitchWidget(simObjectId: simObjectId),
      SimObjectType.wirelessCon => WirelessConWidget(simObjectId: simObjectId),
      SimObjectType.wirelessHost => WirelessHostWidget(
        simObjectId: simObjectId,
      ),
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
      SimObjectType.accessPoint => AccessPoint(
        id: id,
        name: name,
        posX: posX,
        posY: posY,
      ),
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
      SimObjectType.wirelessCon => WirelessCon(
        id: id,
        name: name,
        conAId: conAId,
        conBId: conBId,
      ),
      SimObjectType.wirelessHost => WirelessHost(
        id: id,
        name: name,
        posX: posX,
        posY: posY,
        macAddress: MacAddressManager.generateMacAddress(),
      ),
    };
  }
}
