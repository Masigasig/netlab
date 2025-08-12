part of 'sim_object_notifier.dart';

final connectionProvider = StateNotifierProvider.family
    .autoDispose<ConnectionNotifier, Connection, String>(
      (ref, id) => ConnectionNotifier(ref, id),
    );

class ConnectionNotifier extends SimObjectNotifier<Connection> {
  ConnectionNotifier(Ref ref, String id)
    : super(ref.read(connectionMapProvider)[id]!, ref);

  void receiveMessage(String messageId) {
    messageNotifier(messageId).updateCurrentPlaceId(state.id);

    sendMessage(
      messageId,
    ); //!! Temporaray should be removed this should trigger the animation
  }

  void sendMessage(String messageId) {
    final src = messageNotifier(
      messageId,
    ).state.layerStack.last[MessageKey.source.name];
    final dst = messageNotifier(
      messageId,
    ).state.layerStack.last[MessageKey.destination.name];

    if (dst != MacAddressManager.broadcastMacAddress) {
      final deviceId = state.macToIdMap[dst]!;

      final notifier = getNotifierById(deviceId) as DeviceNotifier;

      notifier.receiveMessage(messageId);
    } else {
      final deviceId = state.macToIdMap.entries
          .firstWhere((entry) => entry.key != src)
          .value;

      final notifier = getNotifierById(deviceId) as DeviceNotifier;

      notifier.receiveMessage(messageId);
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
