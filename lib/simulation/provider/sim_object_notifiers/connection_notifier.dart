part of 'sim_object_notifier.dart';

final connectionProvider =
    NotifierProvider.family<ConnectionNotifier, Connection, String>(
      ConnectionNotifier.new,
    );

final conDeviceToIdMapProvider =
    NotifierProvider.family<
      ConDeviceToIdMapNotifier,
      Map<String, String>,
      String
    >(ConDeviceToIdMapNotifier.new);

final connectionMapProvider =
    NotifierProvider<ConnectionMapNotifier, Map<String, Connection>>(
      ConnectionMapNotifier.new,
    );

final connectionWidgetsProvider =
    NotifierProvider<ConnectionWidgetsNotifier, Map<String, ConnectionWidget>>(
      ConnectionWidgetsNotifier.new,
    );

class ConnectionNotifier extends SimObjectNotifier<Connection> {
  //* TODO: logs of what happenings
  //* TODO: method organization

  final String arg;
  ConnectionNotifier(this.arg);

  @override
  Connection build() {
    ref.onDispose(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.invalidate(conDeviceToIdMapProvider(arg));
      });
    });
    return ref.read(connectionMapProvider)[arg]!;
  }

  @override
  void removeSelf() {
    if (state.conAId.startsWith(SimObjectType.host.label)) {
      hostNotifier(state.conAId).updateConnectionId('');
    } else if (state.conAId.startsWith(SimObjectType.router.label)) {
      routerNotifier(state.conAId).removeConIdByConId(state.id);
    } else if (state.conAId.startsWith(SimObjectType.switch_.label)) {
      switchNotifier(state.conAId).removeConIdByConId(state.id);
    }

    if (state.conBId.startsWith(SimObjectType.host.label)) {
      hostNotifier(state.conBId).updateConnectionId('');
    } else if (state.conBId.startsWith(SimObjectType.router.label)) {
      routerNotifier(state.conBId).removeConIdByConId(state.id);
    } else if (state.conBId.startsWith(SimObjectType.switch_.label)) {
      switchNotifier(state.conBId).removeConIdByConId(state.id);
    }

    ref.read(connectionMapProvider.notifier).removeAllState(state.id);
  }

  void receiveMessage(String messageId, String fromId) {
    messageNotifier(messageId).updateCurrentPlaceId(state.id);

    systemLogNotifier().addLog(
      LogEntry(
        message:
            'Connection ${state.name} receive message ${ref.read(messageProvider(messageId)).name}',
        time: elapsedTime(),
        type: LogType.info,
      ),
    );

    systemLogNotifier().addLog(
      LogEntry(
        message:
            'Message ${ref.read(messageProvider(messageId)).name} is at connection ${state.name}',
        time: elapsedTime(),
        type: LogType.info,
      ),
    );

    simObjectLogNotifier(state.id).addLog(
      LogEntry(
        message:
            'Receive message ${ref.read(messageProvider(messageId)).name} from ${_getDeviceById(fromId).name}',
        time: elapsedTime(),
        type: LogType.info,
      ),
    );

    simObjectLogNotifier(messageId).addLog(
      LogEntry(
        message:
            'Is at connection ${state.name}, coming from ${_getDeviceById(fromId).name}',
        time: elapsedTime(),
        type: LogType.info,
      ),
    );

    final targetId = fromId == state.conAId ? state.conBId : state.conAId;
    ref
        .read(conDeviceToIdMapProvider(state.id).notifier)
        .addDeviceToId(messageId, targetId);

    final deviceFrom = _getDeviceById(fromId);
    final deviceTo = _getDeviceById(targetId);

    final distance =
        (Offset(deviceTo.posX, deviceTo.posY) -
                Offset(deviceFrom.posX, deviceFrom.posY))
            .distance;

    final speed = ref.read(simScreenProvider).messageSpeed;
    final duration = Duration(milliseconds: (distance / speed * 1000).round());

    messageNotifier(
      messageId,
    ).updatePosition(deviceTo.posX, deviceTo.posY, duration: duration);
  }

  void sendMessage(String messageId) {
    final deviceToId = ref.read(conDeviceToIdMapProvider(state.id))[messageId]!;

    final deviceNotifier = _getDeviceNotifierById(deviceToId);
    ref
        .read(conDeviceToIdMapProvider(state.id).notifier)
        .removeDeviceToId(messageId);

    deviceNotifier.receiveMessage(messageId, state.id);
  }

  Device _getDeviceById(String simObjectId) {
    if (simObjectId.startsWith(SimObjectType.host.label)) {
      return ref.read(hostProvider(simObjectId));
    } else if (simObjectId.startsWith(SimObjectType.router.label)) {
      return ref.read(routerProvider(simObjectId));
    } else {
      return ref.read(switchProvider(simObjectId));
    }
  }

  DeviceNotifier _getDeviceNotifierById(String simObjectId) {
    if (simObjectId.startsWith(SimObjectType.host.label)) {
      return hostNotifier(simObjectId);
    } else if (simObjectId.startsWith(SimObjectType.router.label)) {
      return routerNotifier(simObjectId);
    } else {
      return switchNotifier(simObjectId);
    }
  }
}

class ConDeviceToIdMapNotifier extends Notifier<Map<String, String>> {
  final String arg;
  ConDeviceToIdMapNotifier(this.arg);

  @override
  Map<String, String> build() {
    return {};
  }

  void addDeviceToId(String messageId, String deviceId) {
    state = {...state, messageId: deviceId};
  }

  void removeDeviceToId(String messageId) {
    state = {...state}..remove(messageId);
  }
}

class ConnectionMapNotifier extends SimObjectMapNotifier<Connection> {
  ConnectionMapNotifier()
    : super(
        mapProvider: connectionMapProvider,
        objectProvider: connectionProvider,
        widgetsProvider: connectionWidgetsProvider,
      );
}

class ConnectionWidgetsNotifier
    extends SimObjectWidgetsNotifier<ConnectionWidget> {}
