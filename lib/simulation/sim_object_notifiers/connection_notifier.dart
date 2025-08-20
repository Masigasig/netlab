part of 'sim_object_notifier.dart';

final connectionProvider =
    StateNotifierProvider.family<ConnectionNotifier, Connection, String>(
      (ref, id) => ConnectionNotifier(ref, id),
    );

class ConnectionNotifier extends SimObjectNotifier<Connection> {
  ConnectionNotifier(Ref ref, String id)
    : super(ref.read(connectionMapProvider)[id]!, ref);

  void receiveMessage(String messageId) {
    final message = messageNotifier(messageId);
    message.updateCurrentPlaceId(state.id);

    final layer = message.state.layerStack.last;
    final srcMac = layer[MessageKey.source.name];
    final dstMac = layer[MessageKey.destination.name];

    final deviceFrom = getDeviceById(state.macToIdMap[srcMac]!);
    final deviceTo = dstMac == MacAddressManager.broadcastMacAddress
        ? getDeviceById(
            state.macToIdMap.entries.firstWhere((e) => e.key != srcMac).value,
          )
        : getDeviceById(state.macToIdMap[dstMac]!);

    final distance =
        (Offset(deviceTo.posX, deviceTo.posY) -
                Offset(deviceFrom.posX, deviceFrom.posY))
            .distance;

    const speed = 300.0; // pixels per second
    final duration = Duration(milliseconds: (distance / speed * 1000).round());
    message.updatePosition(deviceTo.posX, deviceTo.posY, duration: duration);
  }

  void sendMessage(String messageId) {
    final layer = messageNotifier(messageId).state.layerStack.last;
    final srcMac = layer[MessageKey.source.name];
    final dstMac = layer[MessageKey.destination.name];

    final targetDeviceId = dstMac == MacAddressManager.broadcastMacAddress
        ? state.macToIdMap.entries.firstWhere((e) => e.key != srcMac).value
        : state.macToIdMap[dstMac]!;

    final deviceNotifier = getDeviceNotifierById(targetDeviceId);
    deviceNotifier.receiveMessage(messageId);
  }

  void removeSelf() {
    if (state.conAId.startsWith(SimObjectType.host.label)) {
      ref.read(hostProvider(state.conAId).notifier).updateConnectionId('');
    }

    if (state.conBId.startsWith(SimObjectType.host.label)) {
      ref.read(hostProvider(state.conBId).notifier).updateConnectionId('');
    }

    ref.read(connectionWidgetProvider.notifier).removeSimObjectWidget(state.id);
    ref.read(connectionMapProvider.notifier).removeSimObject(state.id);
    ref.invalidate(connectionProvider(state.id));
  }
}

final connectionMapProvider =
    StateNotifierProvider<ConnectionMapNotifier, Map<String, Connection>>(
      (ref) => ConnectionMapNotifier(ref),
    );

class ConnectionMapNotifier extends SimObjectMapNotifier<Connection> {
  ConnectionMapNotifier(super.ref);

  @override
  List<Map<String, dynamic>> exportToList() {
    return state.keys.map((id) {
      return ref.read(connectionProvider(id)).toMap();
    }).toList();
  }

  @override
  void invalidateSpecificId(String objectId) {
    ref.invalidate(connectionProvider(objectId));
  }
}

final connectionWidgetProvider =
    StateNotifierProvider<
      ConnectionWidgetNotifier,
      Map<String, ConnectionWidget>
    >((ref) => ConnectionWidgetNotifier());

class ConnectionWidgetNotifier
    extends SimObjectWidgetNotifier<ConnectionWidget> {}
