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

  void receiveMessage(String connectionId, String messageId) {
    _messageNotifier.updateCurrentPlaceId(messageId, connectionId);

    _messageNotifier.toggleShouldAnimate(messageId);
  }

  void sendMessage(String connectionId, String messageId) {
    _messageNotifier.toggleShouldAnimate(messageId);

    final src = _messageNotifier.state[messageId]!.layerStack.last['src'];
    final dst = _messageNotifier.state[messageId]!.layerStack.last['dst'];

    if (dst != MacAddressManager.broadcastMacAddress) {
      final deviceId = state[connectionId]!.macToIdMap[dst]!;

      if (deviceId.startsWith(SimObjectType.host.label)) {
        _hostNotifier.receiveMessage(deviceId, messageId);
      } else if (deviceId.startsWith(SimObjectType.router.label)) {
      } else if (deviceId.startsWith(SimObjectType.switch_.label)) {}
    } else {
      final deviceId = state[connectionId]!.macToIdMap.entries
          .firstWhere((entry) => entry.key != src)
          .value;

      if (deviceId.startsWith(SimObjectType.host.label)) {
        _hostNotifier.receiveMessage(deviceId, messageId);
      } else if (deviceId.startsWith(SimObjectType.router.label)) {
      } else if (deviceId.startsWith(SimObjectType.switch_.label)) {}
    }
  }
}

class ConnectionWidgetNotifier
    extends SimObjectWidgetNotifier<ConnectionWidget> {}
