part of 'sim_screen_state.dart';

final hostProvider = StateNotifierProvider<HostNotifier, Map<String, Host>>(
  (ref) => HostNotifier(ref),
);
final hostWidgetProvider =
    StateNotifierProvider<HostWidgetNotifier, Map<String, HostWidget>>(
      (ref) => HostWidgetNotifier(),
    );

class HostNotifier extends DeviceNotifier<Host> {
  HostNotifier(super.ref);

  void receiveMessage(String hostId, String messageId) {
    messageNotifier.updateCurrentPlaceId(messageId, hostId);

    final type = messageNotifier.peekLayerStack(messageId)['type'];

    if (type == DataLinkLayerType.arp) {
      processArpMsg(hostId, messageId);
    } else {
      messageNotifier.dropMessage(messageId);
    }
  }

  void processArpMsg(String hostId, String messageId) {
    messageNotifier.popLayer(messageId);

    final arpLayer = messageNotifier.peekLayerStack(messageId);

    updateArpTable(hostId, arpLayer['senderIp'], arpLayer['senderMac']);

    if (arpLayer['operation'] == OperationType.request) {
      if (arpLayer['targetIp'] == state[hostId]!.ipAddress) {
        // TODO: arp reply
      } else {
        messageNotifier.dropMessage(messageId);
      }
    }
  }

  void sendArpRqst(String hostId, String targetIp) {
    final message = SimObjectType.message.createSimObject(
      srcId: hostId,
      dstId: '${DataLinkLayerType.arp.name}  ${OperationType.request.name}',
    );
    messageNotifier.updateCurrentPlaceId(message.id, hostId);

    final arpLayer = {
      'operation': OperationType.request,
      'senderMac': state[hostId]!.macAddress,
      'senderIp': state[hostId]!.ipAddress,
      'targetIp': targetIp,
    };

    final dataLinkLayer = {
      'source': state[hostId]!.macAddress,
      'destination': MacAddressManager.broadcastMacAddress,
      'type': DataLinkLayerType.arp,
    };

    messageNotifier.pushLayer(message.id, arpLayer);
    messageNotifier.pushLayer(message.id, dataLinkLayer);
    sendToConnection(state[hostId]!.connectionId, message.id);
  }

  void updateArpTable(String hostId, String ipAddress, String macAddress) {
    final host = state[hostId]!;

    final newArpTable = Map<String, String>.from(host.arpTable);

    newArpTable[ipAddress] = macAddress;

    state = {...state, hostId: host.copyWith(arpTable: newArpTable)};
  }
}

class HostWidgetNotifier extends DeviceWidgetNotifier<HostWidget> {}
