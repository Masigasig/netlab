part of 'sim_object_notifier.dart';

final connectionProvider = StateNotifierProvider.family
    .autoDispose<ConnectionNotifier, Connection, String>(
      (ref, id) => ConnectionNotifier(ref, id),
    );

class ConnectionNotifier extends SimObjectNotifier<Connection> {
  ConnectionNotifier(Ref ref, String id)
    : super(ref.read(connectionMapProvider)[id]!, ref);

  MessageNotifier messageNotifier(String messageId) =>
      ref.read(messageProvider(messageId).notifier);

  void receiveMessage(String messageId) {
    messageNotifier(messageId).updateCurrentPlaceId(state.id);
    messageNotifier(messageId).toggleShouldAnimate();
  }

  void sendMessage(String messageId) {
    messageNotifier(messageId).toggleShouldAnimate();

    final src = messageNotifier(
      messageId,
    ).state.layerStack.last[MessageKey.source.name];
    final dst = messageNotifier(
      messageId,
    ).state.layerStack.last[MessageKey.destination.name];

    if (dst != MacAddressManager.broadcastMacAddress) {
      final deviceId = state.macToIdMap[dst]!;

      if (deviceId.startsWith(SimObjectType.host.label)) {
        ref.read(hostProvider(deviceId).notifier).receiveMessage(messageId);
      } else if (deviceId.startsWith(SimObjectType.router.label)) {
      } else if (deviceId.startsWith(SimObjectType.switch_.label)) {}
    } else {
      final deviceId = state.macToIdMap.entries
          .firstWhere((entry) => entry.key != src)
          .value;

      if (deviceId.startsWith(SimObjectType.host.label)) {
        ref.read(hostProvider(deviceId).notifier).receiveMessage(messageId);
      } else if (deviceId.startsWith(SimObjectType.router.label)) {
      } else if (deviceId.startsWith(SimObjectType.switch_.label)) {}
    }
  }
}

final connectionMapProvider =
    StateNotifierProvider<ConnectionMapNotifier, Map<String, Connection>>(
      (ref) => ConnectionMapNotifier(),
    );

class ConnectionMapNotifier extends SimObjectMapNotifier<Connection> {}

final connectionWidgetProvider =
    StateNotifierProvider<
      ConnectionWidgetNotifier,
      Map<String, ConnectionWidget>
    >((ref) => ConnectionWidgetNotifier());

class ConnectionWidgetNotifier
    extends SimObjectWidgetNotifier<ConnectionWidget> {}
