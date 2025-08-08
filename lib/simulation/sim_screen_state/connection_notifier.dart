part of 'sim_screen_state.dart';

final connectionProvider =
    StateNotifierProvider<ConnectionNotifier, Map<String, Connection>>(
      (ref) => ConnectionNotifier(ref),
    );
final connectionWidgetProvider =
    StateNotifierProvider<
      ConnectionWidgetNotifier,
      Map<String, ConnectionWidget>
    >((ref) => ConnectionWidgetNotifier());

class ConnectionNotifier extends SimObjectNotifier<Connection> {
  ConnectionNotifier(super.ref);

  HostNotifier get _hostNotifier => ref.read(hostProvider.notifier);
  MessageNotifier get _messageNotifier => ref.read(messageProvider.notifier);

  void receiveMessage(String connectionId, Message message) {
    _messageNotifier.updateCurrentPlaceId(message.id, connectionId);
    final updatedMessage = _messageNotifier.state[message.id]!;
    sendMessage(connectionId, updatedMessage);
  }

  void sendMessage(String connectionId, Message message) {
    final src = message.layerStack.last['src']!;
    final dst = message.layerStack.last['dst']!;

    if (dst != MacAddressManager.broadcastMacAddress) {
      final deviceId = state[connectionId]!.macToIdMap[dst]!;

      if (deviceId.startsWith(SimObjectType.host.label)) {
        _hostNotifier.receiveMessage(deviceId, message);
      } else if (deviceId.startsWith(SimObjectType.router.label)) {
      } else if (deviceId.startsWith(SimObjectType.switch_.label)) {}
    } else {
      final deviceId = state[connectionId]!.macToIdMap.entries
          .firstWhere((entry) => entry.key != src)
          .value;

      if (deviceId.startsWith(SimObjectType.host.label)) {
        _hostNotifier.receiveMessage(deviceId, message);
      } else if (deviceId.startsWith(SimObjectType.router.label)) {
      } else if (deviceId.startsWith(SimObjectType.switch_.label)) {}
    }
  }
}

class ConnectionWidgetNotifier
    extends SimObjectWidgetNotifier<ConnectionWidget> {}
