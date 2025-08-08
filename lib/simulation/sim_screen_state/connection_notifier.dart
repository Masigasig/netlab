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

  late String messageIdHolder;

  HostNotifier get _hostNotifier => ref.read(hostProvider.notifier);
  MessageNotifier get _messageNotifier => ref.read(messageProvider.notifier);

  void receiveMessage(String connectionId, String messageId) {
    messageIdHolder = messageId;
    _messageNotifier.updateCurrentPlaceId(messageIdHolder, connectionId);

    // TODO: Then update the connection Widget
    // to trigger the sendMessage method
  }

  void sendMessage(String connectionId) {
    final src = _messageNotifier.peekLayerStack(messageIdHolder)['src'];
    final dst = _messageNotifier.peekLayerStack(messageIdHolder)['dst'];

    if (dst != MacAddressManager.broadcastMacAddress) {
      final deviceId = state[connectionId]!.macToIdMap[dst]!;

      if (deviceId.startsWith(SimObjectType.host.label)) {
        _hostNotifier.receiveMessage(deviceId, messageIdHolder);
      } else if (deviceId.startsWith(SimObjectType.router.label)) {
      } else if (deviceId.startsWith(SimObjectType.switch_.label)) {}
    } else {
      final deviceId = state[connectionId]!.macToIdMap.entries
          .firstWhere((entry) => entry.key != src)
          .value;

      if (deviceId.startsWith(SimObjectType.host.label)) {
        _hostNotifier.receiveMessage(deviceId, messageIdHolder);
      } else if (deviceId.startsWith(SimObjectType.router.label)) {
      } else if (deviceId.startsWith(SimObjectType.switch_.label)) {}
    }
  }
}

class ConnectionWidgetNotifier
    extends SimObjectWidgetNotifier<ConnectionWidget> {}
