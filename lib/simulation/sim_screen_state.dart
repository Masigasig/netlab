import 'package:ulid/ulid.dart' show Ulid;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/simulation/sim_objects/sim_object.dart';
import 'package:netlab/simulation/sim_object_widgets/sim_object_widget.dart';
import 'package:netlab/simulation/sim_object_notifiers/sim_object_notifier.dart';

import 'package:netlab/simulation/network_utils.dart';

export 'package:netlab/simulation/network_utils.dart';
export 'package:netlab/simulation/sim_object_notifiers/sim_object_notifier.dart';
export 'package:netlab/simulation/sim_objects/sim_object.dart'
    show SimObjectType;

final wireModeProvider = StateProvider<bool>((ref) => false);
final selectedDeviceOnConnProvider = StateProvider<String>((ref) => '');
final simScreenState = StateNotifierProvider<SimScreenState, void>(
  (ref) => SimScreenState(ref),
);

class SimScreenState extends StateNotifier<void> {
  final Ref ref;
  final List<Map<String, String>> _selectedDevices = [];
  final Map<SimObjectType, int> _typeCounters = {};

  SimScreenState(this.ref) : super(null);

  StateController<bool> get _wireModeNotifier =>
      ref.read(wireModeProvider.notifier);
  StateController<String> get _selectedDeviceOnConnNotifier =>
      ref.read(selectedDeviceOnConnProvider.notifier);

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

  void createConnection({
    required String deviceId,
    required String macAddress,
  }) {
    if (!_wireModeNotifier.state) return;

    _selectedDevices.add({'id': deviceId, 'mac': macAddress});

    if (_selectedDevices.length == 2) {
      final conAId = _selectedDevices[0]['id']!;
      final conBId = _selectedDevices[1]['id']!;
      final conAmac = _selectedDevices[0]['mac']!;
      final conBmac = _selectedDevices[1]['mac']!;

      if (conAId == conBId) {
        toggleWireMode();
        return;
      }

      final connection = SimObjectType.connection.createSimObject(
        conAId: conAId,
        conBId: conBId,
        conAmac: conAmac,
        conBmac: conBmac,
      );

      final widget = SimObjectType.connection.createSimObjectWidget(
        simObjectId: connection.id,
      );

      if (conAId.startsWith(SimObjectType.host.label)) {
        ref
            .read(hostProvider(conAId).notifier)
            .updateConnectionId(connection.id);
      } else if (conAId.startsWith(SimObjectType.router.label)) {
        // ref.read(routerProvider(conAId).notifier).updateConnectionId(connection.id);
      } else if (conAId.startsWith(SimObjectType.switch_.label)) {
        // ref.read(switchProvider(conAId).notifier).updateConnectionId(connection.id);
      }

      if (conBId.startsWith(SimObjectType.host.label)) {
        ref
            .read(hostProvider(conBId).notifier)
            .updateConnectionId(connection.id);
      } else if (conBId.startsWith(SimObjectType.router.label)) {
        // ref.read(routerProvider(conBId).notifier).updateConnectionId(connection.id);
      } else if (conBId.startsWith(SimObjectType.switch_.label)) {
        // ref.read(switchProvider(conBId).notifier).updateConnectionId(connection.id);
      }

      _addSimObjAndWidgetToPovider(
        SimObjectType.connection,
        connection,
        widget,
      );
      toggleWireMode();
    }
  }

  void toggleWireMode() {
    _wireModeNotifier.state = !_wireModeNotifier.state;
    _selectedDeviceOnConnNotifier.state = '';
    _selectedDevices.clear();
  }

  Map<String, dynamic> exportSimulation() {
    return {
      'typeCounters': _typeCounters.map(
        (key, value) => MapEntry(key.name, value),
      ),
      'routers': _routerMapNotifier.exportToList(),
      'switches': _switchMapNotifier.exportToList(),
      'hosts': _hostMapNotifier.exportToList(),
      'connections': _connectionMapNotifier.exportToList(),
    };
  }

  void importSimulation(Map<String, dynamic> data) {
    _clearAllState();

    if (data['typeCounters'] != null) {
      final countersMap = data['typeCounters'] as Map<String, dynamic>;
      countersMap.forEach((key, value) {
        final type = SimObjectType.values.firstWhere((t) => t.name == key);
        _typeCounters[type] = value as int;
      });
    }

    final routerList = List.from(data['routers']);
    final switchList = List.from(data['switches']);
    final hostList = List.from(data['hosts']);
    final connectionList = List.from(data['connections']);

    _routerMapNotifier.importFromList(routerList);
    _switchMapNotifier.importFromList(switchList);
    _hostMapNotifier.importFromList(hostList);

    _routerWidgetNotifier.importFromList(routerList);
    _switchWidgetNotifier.importFromList(switchList);
    _hostWidgetNotifier.importFromList(hostList);

    _connectionMapNotifier.importFromList(connectionList);
    _connectionWidgetNotifier.importFromList(connectionList);
  }

  void _clearAllState() {
    _typeCounters.clear();
    _selectedDevices.clear();
    _wireModeNotifier.state = false;

    _connectionWidgetNotifier.clearState();
    _connectionMapNotifier.clearState();

    _hostWidgetNotifier.clearState();
    _switchWidgetNotifier.clearState();
    _routerWidgetNotifier.clearState();

    _hostMapNotifier.clearState();
    _switchMapNotifier.clearState();
    _routerMapNotifier.clearState();
  }

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
    String conAmac = '',
    String conBmac = '',
    String conAId = '',
    String conBId = '',
    String srcId = '',
    String dstId = '',
  }) {
    final id = generatePrefixedId();

    return switch (this) {
      SimObjectType.connection => Connection(
        id: id,
        conAmac: conAmac,
        conBmac: conBmac,
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
