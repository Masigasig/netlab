import 'package:flutter/material.dart' show WidgetsBinding;
import 'package:ulid/ulid.dart' show Ulid;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/temp/simulation/sim_objects/sim_object.dart';
import 'package:netlab/temp/simulation/sim_object_widgets/sim_object_widget.dart';
import 'package:netlab/temp/simulation/sim_object_notifiers/sim_object_notifier.dart';

import 'package:netlab/temp/simulation/network_utils.dart';

export 'package:netlab/temp/simulation/network_utils.dart';
export 'package:netlab/temp/simulation/sim_object_notifiers/sim_object_notifier.dart';
export 'package:netlab/temp/simulation/sim_objects/sim_object.dart'
    show SimObjectType;

final wireModeProvider = NotifierProvider<WireModeNotifier, bool>(
  WireModeNotifier.new,
);

class WireModeNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void setFalse() {
    state = false;
  }

  void setTrue() {
    state = true;
  }

  void toggle() {
    state = !state;
  }
}

final messageModeProvider = NotifierProvider<MessageModeNotifier, bool>(
  MessageModeNotifier.new,
);

class MessageModeNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void setFalse() {
    state = false;
  }

  void setTrue() {
    state = true;
  }

  void toggle() {
    state = !state;
  }
}

final playingModeProvider = NotifierProvider<PlayingModeNotifier, bool>(
  PlayingModeNotifier.new,
);

class PlayingModeNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void setFalse() {
    state = false;
  }

  void setTrue() {
    state = true;
  }

  void toggle() {
    state = !state;
  }
}

final selectedDeviceOnConnProvider =
    NotifierProvider<SelectedDeviceOnConnNotifier, String>(
      SelectedDeviceOnConnNotifier.new,
    );

class SelectedDeviceOnConnNotifier extends Notifier<String> {
  @override
  String build() {
    return '';
  }

  void setSelectedDevice(String deviceId) {
    if (state == deviceId) {
      state = '';
    } else {
      state = deviceId;
    }
  }

  void clearSelectedDevice() {
    state = '';
  }
}

final selectedDeviceOnInfoProvider =
    NotifierProvider<SelectedDeviceOnInfoNotifier, String>(
      SelectedDeviceOnInfoNotifier.new,
    );

class SelectedDeviceOnInfoNotifier extends Notifier<String> {
  @override
  String build() {
    return '';
  }

  void setSelectedDevice(String deviceId) {
    if (state == deviceId) {
      state = '';
    } else {
      state = deviceId;
    }
  }

  void clearSelectedDevice() {
    state = '';
  }
}

final temporaryMapProvider =
    NotifierProvider<TemporaryMapNotifier, Map<String, dynamic>>(
      TemporaryMapNotifier.new,
    );

class TemporaryMapNotifier extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() => {};

  void setMap(Map<String, dynamic> newMap) {
    state = newMap;
  }

  void clearMap() {
    state = {};
  }
}

final simLogsProvider = NotifierProvider<SimLogsNotifier, List<String>>(
  SimLogsNotifier.new,
);

final simScreenState = NotifierProvider<SimScreenState, void>(
  SimScreenState.new,
);

class SimLogsNotifier extends Notifier<List<String>> {
  final List<String> _logs = [];

  @override
  List<String> build() {
    return const [];
  }

  void addLog(String message) {
    _logs.add(message);
    state = List.unmodifiable(_logs);
  }

  void clearLogs() {
    _logs.clear();
    state = const [];
  }
}

class SimScreenState extends Notifier<void> {
  final List<Map<String, String>> _selectedDevices = [];
  final Map<SimObjectType, int> _typeCounters = {};

  @override
  void build() {}

  WireModeNotifier get _wireModeNotifier => ref.read(wireModeProvider.notifier);
  MessageModeNotifier get _messageModeNotifier =>
      ref.read(messageModeProvider.notifier);
  PlayingModeNotifier get _playingModeNotifier =>
      ref.read(playingModeProvider.notifier);
  SelectedDeviceOnConnNotifier get _selectedDeviceOnConnNotifier =>
      ref.read(selectedDeviceOnConnProvider.notifier);
  SelectedDeviceOnInfoNotifier get _selectedDeviceOnInfoNotifier =>
      ref.read(selectedDeviceOnInfoProvider.notifier);

  ConnectionMapNotifier get _connectionMapNotifier =>
      ref.read(connectionMapProvider.notifier);
  HostMapNotifier get _hostMapNotifier => ref.read(hostMapProvider.notifier);
  MessageMapNotifier get _messageMapNotifier =>
      ref.read(messageMapProvider.notifier);
  RouterMapNotifier get _routerMapNotifier =>
      ref.read(routerMapProvider.notifier);
  SwitchMapNotifier get _switchMapNotifier =>
      ref.read(switchMapProvider.notifier);

  ConnectionWidgetNotifier get _connectionWidgetNotifier =>
      ref.read(connectionWidgetProvider.notifier);
  HostWidgetNotifier get _hostWidgetNotifier =>
      ref.read(hostWidgetProvider.notifier);
  MessageWidgetNotifier get _messageWidgetNotifier =>
      ref.read(messageWidgetProvider.notifier);
  RouterWidgetNotifier get _routerWidgetNotifier =>
      ref.read(routerWidgetProvider.notifier);
  SwitchWidgetNotifier get _switchWidgetNotifier =>
      ref.read(switchWidgetProvider.notifier);

  void startSimulation() {
    final messageIds = ref.read(messageMapProvider).keys;
    final hostsIds = <String>{};
    for (final messageId in messageIds) {
      final message = ref.read(messageProvider(messageId));
      final host = ref.read(hostProvider(message.srcId));

      ref
          .read(messageProvider(messageId).notifier)
          .updatePosition(host.posX, host.posY);

      hostsIds.add(message.srcId);
    }

    _wireModeNotifier.setFalse();
    _messageModeNotifier.setFalse();
    _selectedDeviceOnConnNotifier.clearSelectedDevice();
    _selectedDeviceOnInfoNotifier.clearSelectedDevice();
    _selectedDevices.clear();
    _playingModeNotifier.setTrue();

    for (final hostId in hostsIds) {
      ref.read(hostProvider(hostId).notifier).startMessageProcessing();
    }
  }

  void stopSimulation() {
    _playingModeNotifier.state = false;
  }

  void createDevice({
    required SimObjectType type,
    required double posX,
    required double posY,
  }) {
    final name = '${type.label} ${_getNextCounter(type)}';

    final device = type.createSimObject(name: name, posX: posX, posY: posY);

    final widget = type.createSimObjectWidget(simObjectId: device.id);

    _addSimObjAndWidgetToPovider(type, device, widget);
  }

  void createConnection(String deviceId, String name) {
    if (!_wireModeNotifier.state) return;

    _selectedDevices.add({'id': deviceId, 'name': name});

    if (_selectedDevices.length == 2) {
      final conAId = _selectedDevices[0]['id']!;
      final conAName = _selectedDevices[0]['name']!;
      final conBId = _selectedDevices[1]['id']!;
      final conBName = _selectedDevices[1]['name']!;

      if (conAId == conBId) {
        toggleWireMode();
        return;
      }

      final connection = SimObjectType.connection.createSimObject(
        conAId: conAId,
        conBId: conBId,
      );

      final widget = SimObjectType.connection.createSimObjectWidget(
        simObjectId: connection.id,
      );

      if (conAId.startsWith(SimObjectType.host.label)) {
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

      if (conBId.startsWith(SimObjectType.host.label)) {
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

      _addSimObjAndWidgetToPovider(
        SimObjectType.connection,
        connection,
        widget,
      );
      toggleWireMode();
    }
  }

  void createMessage(String hostId) {
    if (!_messageModeNotifier.state) return;
    if (!hostId.startsWith(SimObjectType.host.label)) return;

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

      final widget = SimObjectType.message.createSimObjectWidget(
        simObjectId: message.id,
      );

      _addSimObjAndWidgetToPovider(SimObjectType.message, message, widget);

      ref
          .read(messageProvider(message.id).notifier)
          .updateCurrentPlaceId(hostId1);
      ref.read(hostProvider(hostId1).notifier).enqueueMessage(message.id);

      toggleMessageMode();
    }
  }

  void toggleWireMode() {
    _wireModeNotifier.toggle();
    _messageModeNotifier.setFalse();
    _selectedDeviceOnConnNotifier.clearSelectedDevice();
    _selectedDevices.clear();
  }

  void toggleMessageMode() {
    _messageModeNotifier.toggle();
    _wireModeNotifier.setFalse();
    _selectedDeviceOnConnNotifier.clearSelectedDevice();
    _selectedDevices.clear();
  }

  Map<String, dynamic> exportSimulation() {
    return {
      'typeCounters': _typeCounters.map(
        (key, value) => MapEntry(key.name, value),
      ),
      'routers': _routerMapNotifier.exportToList(),
      'messages': _messageMapNotifier.exportToList(),
      'switches': _switchMapNotifier.exportToList(),
      'hosts': _hostMapNotifier.exportToList(),
      'connections': _connectionMapNotifier.exportToList(),
    };
  }

  void importSimulation(Map<String, dynamic> data) {
    if (data['typeCounters'] != null) {
      final countersMap = data['typeCounters'] as Map<String, dynamic>;
      countersMap.forEach((key, value) {
        final type = SimObjectType.values.firstWhere((t) => t.name == key);
        _typeCounters[type] = value as int;
      });
    }

    final routerList = List.from(data['routers']);
    final messageList = List.from(data['messages']);
    final switchList = List.from(data['switches']);
    final hostList = List.from(data['hosts']);
    final connectionList = List.from(data['connections']);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _routerMapNotifier.importFromList(routerList);
      _messageMapNotifier.importFromList(messageList);
      _switchMapNotifier.importFromList(switchList);
      _hostMapNotifier.importFromList(hostList);
      _connectionMapNotifier.importFromList(connectionList);

      _routerWidgetNotifier.importFromList(routerList);
      _messageWidgetNotifier.importFromList(messageList);
      _switchWidgetNotifier.importFromList(switchList);
      _hostWidgetNotifier.importFromList(hostList);
      _connectionWidgetNotifier.importFromList(connectionList);
    });
  }

  void clearAllState() {
    _typeCounters.clear();
    _selectedDevices.clear();
    _wireModeNotifier.state = false;

    final connectionIds = ref.read(connectionMapProvider).keys;
    final hostIds = ref.read(hostMapProvider).keys;
    final routerIds = ref.read(routerMapProvider).keys;
    final switchIds = ref.read(switchMapProvider).keys;
    final messageIds = ref.read(messageMapProvider).keys;

    _connectionWidgetNotifier.clearState();
    _messageWidgetNotifier.clearState();
    _hostWidgetNotifier.clearState();
    _switchWidgetNotifier.clearState();
    _routerWidgetNotifier.clearState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final id in connectionIds) {
        ref.invalidate(connectionProvider(id));
      }
      for (final id in hostIds) {
        ref.invalidate(hostProvider(id));
      }
      for (final id in routerIds) {
        ref.invalidate(routerProvider(id));
      }
      for (final id in switchIds) {
        ref.invalidate(switchProvider(id));
      }
      for (final id in messageIds) {
        ref.invalidate(messageProvider(id));
      }
    });
  }

  // void invalidateProviders() {
  //   ref.invalidate(connectionProvider);
  //   ref.invalidate(hostProvider);
  //   ref.invalidate(routerProvider);
  //   ref.invalidate(switchProvider);
  //   ref.invalidate(messageProvider);

  //   // for (final id in ref.read(connectionMapProvider).keys.toList()) {
  //   //   ref.invalidate(connectionProvider(id));
  //   // }

  //   // for (final id in ref.read(hostMapProvider).keys.toList()) {
  //   //   ref.invalidate(hostProvider(id));
  //   // }

  //   // for (final id in ref.read(routerMapProvider).keys.toList()) {
  //   //   ref.invalidate(routerProvider(id));
  //   // }

  //   // for (final id in ref.read(switchMapProvider).keys.toList()) {
  //   //   ref.invalidate(switchProvider(id));
  //   // }

  //   // for (final id in ref.read(messageMapProvider).keys.toList()) {
  //   //   ref.invalidate(messageProvider(id));
  //   // }
  // }

  int _getNextCounter(SimObjectType type) {
    _typeCounters[type] = (_typeCounters[type] ?? 0) + 1;
    return _typeCounters[type]!;
  }

  void _addSimObjAndWidgetToPovider(
    SimObjectType type,
    SimObject object,
    SimObjectWidget widget,
  ) {
    switch (type) {
      case SimObjectType.connection:
        _connectionMapNotifier.addSimObject(object as Connection);
        _connectionWidgetNotifier.addSimObjectWidget(
          widget as ConnectionWidget,
        );
      case SimObjectType.host:
        _hostMapNotifier.addSimObject(object as Host);
        _hostWidgetNotifier.addSimObjectWidget(widget as HostWidget);
      case SimObjectType.message:
        _messageMapNotifier.addSimObject(object as Message);
        _messageWidgetNotifier.addSimObjectWidget(widget as MessageWidget);
      case SimObjectType.router:
        _routerMapNotifier.addSimObject(object as Router);
        _routerWidgetNotifier.addSimObjectWidget(widget as RouterWidget);
      case SimObjectType.switch_:
        _switchMapNotifier.addSimObject(object as Switch);
        _switchWidgetNotifier.addSimObjectWidget(widget as SwitchWidget);
    }
  }
}

extension SimObjectTypeX on SimObjectType {
  String get label {
    switch (this) {
      case SimObjectType.connection:
        return 'Connection';
      case SimObjectType.host:
        return 'Host';
      case SimObjectType.message:
        return 'Message';
      case SimObjectType.router:
        return 'Router';
      case SimObjectType.switch_:
        return 'Switch';
    }
  }

  String generatePrefixedId() => '${label}_${Ulid().toUuid()}';

  SimObjectWidget createSimObjectWidget({required String simObjectId}) {
    return switch (this) {
      SimObjectType.connection => ConnectionWidget(simObjectId: simObjectId),
      SimObjectType.host => HostWidget(simObjectId: simObjectId),
      SimObjectType.message => MessageWidget(simObjectId: simObjectId),
      SimObjectType.router => RouterWidget(simObjectId: simObjectId),
      SimObjectType.switch_ => SwitchWidget(simObjectId: simObjectId),
    };
  }

  SimObject createSimObject({
    String name = '',
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
        conAId: conAId,
        conBId: conBId,
      ),
      SimObjectType.host => Host(
        id: id,
        posX: posX,
        posY: posY,
        name: name,
        macAddress: MacAddressManager.generateUniqueMacAddress(),
      ),
      SimObjectType.message => Message(
        id: id,
        name: name,
        srcId: srcId,
        dstId: dstId,
      ),
      SimObjectType.router => Router(
        id: id,
        posX: posX,
        posY: posY,
        name: name,
        eth0MacAddress: MacAddressManager.generateUniqueMacAddress(),
        eth1MacAddress: MacAddressManager.generateUniqueMacAddress(),
        eth2MacAddress: MacAddressManager.generateUniqueMacAddress(),
        eth3MacAddress: MacAddressManager.generateUniqueMacAddress(),
      ),
      SimObjectType.switch_ => Switch(
        id: id,
        posX: posX,
        posY: posY,
        name: name,
      ),
    };
  }
}
