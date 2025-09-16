// ignore_for_file: avoid_public_notifier_properties
part of 'sim_object_notifier.dart';

final connectionProvider =
    NotifierProvider.family<ConnectionNotifier, Connection, String>(
      ConnectionNotifier.new,
    );

class ConnectionNotifier extends SimObjectNotifier<Connection> {
  final String arg;
  ConnectionNotifier(this.arg);

  @override
  Connection build() {
    ref.onDispose(() {
      deviceToIdMap.clear();
    });
    return ref.read(connectionMapProvider)[arg]!;
  }

  Map<String, String> deviceToIdMap = {};

  void receiveMessage(String messageId, String fromId) {
    final message = messageNotifier(messageId);
    message.updateCurrentPlaceId(state.id);

    deviceToIdMap[messageId] = fromId == state.conAId
        ? state.conBId
        : state.conAId;

    final deviceFrom = getDeviceById(fromId);
    final deviceTo = getDeviceById(deviceToIdMap[messageId]!);

    final distance =
        (Offset(deviceTo.posX, deviceTo.posY) -
                Offset(deviceFrom.posX, deviceFrom.posY))
            .distance;

    const speed = 300.0; // pixels per second
    final duration = Duration(milliseconds: (distance / speed * 1000).round());

    // This will trigger the sendMessage()
    message.updatePosition(deviceTo.posX, deviceTo.posY, duration: duration);
  }

  void sendMessage(String messageId) {
    final deviceToId = deviceToIdMap[messageId]!;

    final deviceNotifier = getDeviceNotifierById(deviceToId);
    deviceToIdMap.remove(messageId);
    deviceNotifier.receiveMessage(messageId, state.id);
  }

  @override
  void removeSelf() {
    if (state.conAId.startsWith(SimObjectType.host.label)) {
      hostNotifier(state.conAId).updateConnectionId('');
    } else if (state.conAId.startsWith(SimObjectType.switch_.label)) {
      switchNotifier(state.conAId).removeConIdByConId(state.id);
    } else if (state.conAId.startsWith(SimObjectType.router.label)) {
      routerNotifier(state.conAId).removeConIdByConId(state.id);
    }

    if (state.conBId.startsWith(SimObjectType.host.label)) {
      hostNotifier(state.conBId).updateConnectionId('');
    } else if (state.conBId.startsWith(SimObjectType.switch_.label)) {
      switchNotifier(state.conBId).removeConIdByConId(state.id);
    } else if (state.conBId.startsWith(SimObjectType.router.label)) {
      routerNotifier(state.conBId).removeConIdByConId(state.id);
    }

    connectionMapNotifier.removeAllState(state.id);
  }
}

final connectionMapProvider =
    NotifierProvider<ConnectionMapNotifier, Map<String, Connection>>(
      ConnectionMapNotifier.new,
    );

class ConnectionMapNotifier extends SimObjectMapNotifier<Connection> {
  @override
  List<Map<String, dynamic>> exportToList() {
    return state.keys.map((id) {
      return ref.read(connectionProvider(id)).toMap();
    }).toList();
  }

  @override
  void invalidateSpecificId(String objectId) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(connectionProvider(objectId));
    });
  }

  @override
  void removeAllState(String objectId) {
    ref.read(connectionWidgetProvider.notifier).removeSimObjectWidget(objectId);
    removeSimObject(objectId);
    invalidateSpecificId(objectId);
  }
}

final connectionWidgetProvider =
    NotifierProvider<ConnectionWidgetNotifier, Map<String, ConnectionWidget>>(
      ConnectionWidgetNotifier.new,
    );

class ConnectionWidgetNotifier
    extends SimObjectWidgetNotifier<ConnectionWidget> {}
