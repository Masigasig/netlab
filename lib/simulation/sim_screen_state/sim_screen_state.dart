import 'package:ulid/ulid.dart' show Ulid;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/simulation/sim_object/sim_object.dart';
import 'package:netlab/simulation/sim_object_widget/sim_object_widget.dart';
import 'package:netlab/simulation/sim_screen_state/network_utils.dart';

export 'package:netlab/simulation/sim_object/sim_object.dart'
    show SimObjectType;

part 'connection_notifier.dart';
part 'device_notifier.dart';
part 'host_notifier.dart';
part 'router_notifier.dart';
part 'sim_object_notifier.dart';
part 'switch_notifier.dart';

final wireModeProvider = StateProvider<bool>((ref) => false);
final simScreenState = StateNotifierProvider<SimScreenState, void>(
  (ref) => SimScreenState(ref),
);

class SimScreenState extends StateNotifier<void> {
  final Ref ref;
  final List<String> _selectedDevices = [];
  final Map<SimObjectType, int> _typeCounters = {};

  SimScreenState(this.ref) : super(null);

  StateController<bool> get _wireModeNotifier =>
      ref.read(wireModeProvider.notifier);

  ConnectionNotifier get _connectionNotifier =>
      ref.read(connectionProvider.notifier);
  HostNotifier get _hostNotifier => ref.read(hostProvider.notifier);
  RouterNotifier get _routerNotifier => ref.read(routerProvider.notifier);
  SwitchNotifier get _switchNotifier => ref.read(switchProvider.notifier);

  ConnectionWidgetNotifier get _connectionWidgetNotifier =>
      ref.read(connectionWidgetProvider.notifier);
  HostWidgetNotifier get _hostWidgetNotifier =>
      ref.read(hostWidgetProvider.notifier);
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

  void createConnection({required String simObjectId}) {
    if (!_wireModeNotifier.state) return;

    if (!_selectedDevices.contains(simObjectId) &&
        _selectedDevices.length < 2) {
      _selectedDevices.add(simObjectId);

      if (_selectedDevices.length == 2) {
        final conA = _selectedDevices[0];
        final conB = _selectedDevices[1];

        final isDuplicate = _connectionNotifier.state.values.any(
          (conn) =>
              (conn.conA == conA && conn.conB == conB) ||
              (conn.conA == conB && conn.conB == conA),
        );
        if (isDuplicate) {
          _selectedDevices.clear();
          return;
        }

        final connection = SimObjectType.connection.createSimObject(
          conA: conA,
          conB: conB,
        );

        final widget = SimObjectType.connection.createSimObjectWidget(
          simObjectId: connection.id,
        );

        _addSimObjAndWidgetToPovider(
          SimObjectType.connection,
          connection,
          widget,
        );
        toggleWireMode();
      }
    }
  }

  void toggleWireMode() {
    _wireModeNotifier.state = !_wireModeNotifier.state;
    _selectedDevices.clear();
  }

  Map<String, dynamic> exportSimulation() {
    return {
      'typeCounters': _typeCounters.map(
        (key, value) => MapEntry(key.name, value),
      ),
      'connections': ref
          .read(connectionProvider)
          .values
          .map((c) => c.toMap())
          .toList(),
      'hosts': ref.read(hostProvider).values.map((h) => h.toMap()).toList(),
      'routers': ref.read(routerProvider).values.map((r) => r.toMap()).toList(),
      'switches': ref
          .read(switchProvider)
          .values
          .map((s) => s.toMap())
          .toList(),
    };
  }

  Future<void> importSimulation(Map<String, dynamic> data) async {
    await _clearAllState();

    if (data['typeCounters'] != null) {
      final countersMap = data['typeCounters'] as Map<String, dynamic>;
      countersMap.forEach((key, value) {
        final type = SimObjectType.values.firstWhere((t) => t.name == key);
        _typeCounters[type] = value as int;
      });
    }

    for (final hostMap in (data['hosts'] as List)) {
      final host = Host.fromMap(hostMap as Map<String, dynamic>);
      final widget = SimObjectType.host.createSimObjectWidget(
        simObjectId: host.id,
      );

      _addSimObjAndWidgetToPovider(SimObjectType.host, host, widget);
    }

    for (final routerMap in (data['routers'] as List)) {
      final router = Router.fromMap(routerMap as Map<String, dynamic>);
      final widget = SimObjectType.router.createSimObjectWidget(
        simObjectId: router.id,
      );

      _addSimObjAndWidgetToPovider(SimObjectType.router, router, widget);
    }

    for (final switchMap in (data['switches'] as List)) {
      final switch_ = Switch.fromMap(switchMap as Map<String, dynamic>);
      final widget = SimObjectType.switch_.createSimObjectWidget(
        simObjectId: switch_.id,
      );

      _addSimObjAndWidgetToPovider(SimObjectType.switch_, switch_, widget);
    }

    // delay para mag load muna lahat ng devices sa taas, magiging null kasi
    // yung makukuha ng connection if walang delay so mag e-error
    await Future.delayed(const Duration(milliseconds: 100));

    for (final connectionMap in (data['connections'] as List)) {
      final connection = Connection.fromMap(
        connectionMap as Map<String, dynamic>,
      );
      final widget = SimObjectType.connection.createSimObjectWidget(
        simObjectId: connection.id,
      );

      _addSimObjAndWidgetToPovider(
        SimObjectType.connection,
        connection,
        widget,
      );
    }
  }

  Future<void> _clearAllState() async {
    _typeCounters.clear();
    _selectedDevices.clear();
    _wireModeNotifier.state = false;

    _connectionWidgetNotifier.state = {};
    _connectionNotifier.state = {};
    await Future.delayed(
      const Duration(milliseconds: 100),
    ); // para d sabay sabay mag delete

    _hostWidgetNotifier.state = {};
    _routerWidgetNotifier.state = {};
    _switchWidgetNotifier.state = {};
    await Future.delayed(
      const Duration(milliseconds: 100),
    ); // para d sabay sabay mag delete

    _hostNotifier.state = {};
    _routerNotifier.state = {};
    _switchNotifier.state = {};
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
        _connectionNotifier.addSimObject(object as Connection);
        _connectionWidgetNotifier.addSimObjectWidget(
          widget as ConnectionWidget,
        );
      case SimObjectType.host:
        _hostNotifier.addSimObject(object as Host);
        _hostWidgetNotifier.addSimObjectWidget(widget as HostWidget);
        break;
      case SimObjectType.router:
        _routerNotifier.addSimObject(object as Router);
        _routerWidgetNotifier.addSimObjectWidget(widget as RouterWidget);
        break;
      case SimObjectType.switch_:
        _switchNotifier.addSimObject(object as Switch);
        _switchWidgetNotifier.addSimObjectWidget(widget as SwitchWidget);
        break;
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
      case SimObjectType.router:
        return 'Router';
      case SimObjectType.switch_:
        return 'Switch';
    }
  }

  SimObjectWidget createSimObjectWidget({required String simObjectId}) {
    return switch (this) {
      SimObjectType.connection => ConnectionWidget(simObjectId: simObjectId),
      SimObjectType.host => HostWidget(simObjectId: simObjectId),
      SimObjectType.router => RouterWidget(simObjectId: simObjectId),
      SimObjectType.switch_ => SwitchWidget(simObjectId: simObjectId),
    };
  }

  SimObject createSimObject({
    String name = '',
    double posX = 0,
    double posY = 0,
    String conA = '',
    String conB = '',
  }) {
    final id = Ulid().toUuid();
    final macAddress = generateUniqueMacAddress();

    return switch (this) {
      SimObjectType.connection => Connection(id: id, conA: conA, conB: conB),
      SimObjectType.host => Host(id: id, posX: posX, posY: posY, name: name, macAddress: macAddress),
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
