import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/simulation/sim_object/sim_object.dart';
import 'package:netlab/simulation/sim_object_widget/sim_object_widget.dart';

export 'package:netlab/simulation/sim_object/sim_object.dart'
    show SimObjectType;

part 'connection_notifier.dart';
part 'device_notifier.dart';
part 'host_notifier.dart';
part 'router_notifier.dart';
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

    final (device, widget) = type.createSimObjAndWidget(
      name: name,
      posX: posX,
      posY: posY,
    );

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

        final (connection, widget) = SimObjectType.connection
            .createSimObjAndWidget(conA: conA, conB: conB);
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
      case SimObjectType.connection:
        _connectionNotifier.addSimObject(object as Connection);
        _connectionWidgetNotifier.addSimObjectWidget(
          widget as ConnectionWidget,
        );
    }
  }
}

abstract class SimObjectNotifier<T extends SimObject>
    extends StateNotifier<Map<String, T>> {
  SimObjectNotifier() : super({});

  void addSimObject(T simObject) {
    state = {...state, simObject.id: simObject};
  }
}

abstract class SimObjectWidgetNotifier<T extends SimObjectWidget>
    extends StateNotifier<Map<String, T>> {
  SimObjectWidgetNotifier() : super({});

  void addSimObjectWidget(T simObjectWidget) {
    state = {...state, simObjectWidget.simObjectId: simObjectWidget};
  }
}

extension SimObjectTypeX on SimObjectType {
  String get label {
    switch (this) {
      case SimObjectType.router:
        return 'Router';
      case SimObjectType.switch_:
        return 'Switch';
      case SimObjectType.host:
        return 'Host';
      case SimObjectType.connection:
        return 'Connection';
    }
  }

  (SimObject, SimObjectWidget) createSimObjAndWidget({
    String name = '',
    double posX = 0,
    double posY = 0,
    String conA = '',
    String conB = '',
  }) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    return (
      switch (this) {
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
        SimObjectType.host => Host(id: id, posX: posX, posY: posY, name: name),
        SimObjectType.connection => Connection(id: id, conA: conA, conB: conB),
      },

      switch (this) {
        SimObjectType.router => RouterWidget(simObjectId: id),
        SimObjectType.switch_ => SwitchWidget(simObjectId: id),
        SimObjectType.host => HostWidget(simObjectId: id),
        SimObjectType.connection => ConnectionWidget(simObjectId: id),
      },
    );
  }
}
