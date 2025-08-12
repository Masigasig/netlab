part of 'sim_object_notifier.dart';

final hostProvider = StateNotifierProvider.family
    .autoDispose<HostNotifier, Host, String>(
      (ref, id) => HostNotifier(ref, id),
    );

class HostNotifier extends DeviceNotifier<Host> {
  HostNotifier(Ref ref, String id) : super(ref.read(hostMapProvider)[id]!, ref);

  void doNothing() {
    _sendArpRqst('asfd');
    _getMacFromArpTable('fads');
    _makeIpv4Message('adsf');
  }

  void updateConnectionId(String connectionId) =>
      state = state.copyWith(connectionId: connectionId);

  void updateIpAddress(String ipAddress) =>
      state = state.copyWith(ipAddress: ipAddress);

  @override
  void receiveMessage(String messageId) {
    messageNotifier(messageId).updateCurrentPlaceId(state.id);
    final dataLinkLayer = messageNotifier(messageId).popLayer();

    final type = DataLinkLayerType.values.firstWhere(
      (e) => e.name == dataLinkLayer[MessageKey.type.name],
    );

    switch (type) {
      case DataLinkLayerType.arp:
        _receiveArpMsg(messageId, dataLinkLayer);
      case DataLinkLayerType.ipv4:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  String _makeIpv4Message(String messageId) {
    messageNotifier(messageId).updateCurrentPlaceId(state.id);

    // final networkLayer = {
    //   MessageKey.senderIp.name: state.ipAddress,
    //   MessageKey.targetIp.name: messageNotifier(messageId).state.dstId,
    // };
    return messageId;
  }

  void _receiveArpMsg(String messageId, Map<String, String> dataLinkLayer) {
    final arpLayer = messageNotifier(messageId).popLayer();

    _updateArpTable(
      arpLayer[MessageKey.senderIp.name]!,
      dataLinkLayer[MessageKey.source.name]!,
    );

    final operation = OperationType.values.firstWhere(
      (e) => e.name == arpLayer[MessageKey.operation.name],
    );
    final targetIp = arpLayer[MessageKey.targetIp.name];

    switch (operation) {
      case OperationType.request:
        if (targetIp == state.ipAddress) {
          messageNotifier(
            messageId,
          ).dropMessage(); //* ARP Request Arrive successfully
          _sendArpRepyl(dataLinkLayer[MessageKey.source.name]!);
        } else {
          messageNotifier(
            messageId,
          ).dropMessage(); //* ARP Request is not meant for this Host
        }
      case OperationType.reply:
        messageNotifier(messageId).dropMessage(); //* ARP Reply Recieve
    }
  }

  void _sendArpRepyl(String targetMac) {
    final message =
        SimObjectType.message.createSimObject(
              srcId: state.id,
              dstId:
                  '${DataLinkLayerType.arp.name} ${OperationType.reply.name}',
            )
            as Message;

    messageMapNotifier.addSimObject(message);
    messageNotifier(message.id).updateCurrentPlaceId(state.id);

    final newArpLayer = {
      MessageKey.operation.name: OperationType.reply.name,
      MessageKey.senderIp.name: state.ipAddress,
    };

    messageNotifier(message.id).pushLayer(newArpLayer);

    final newDataLinkLayer = {
      MessageKey.source.name: state.macAddress,
      MessageKey.destination.name: targetMac,
      MessageKey.type.name: DataLinkLayerType.arp.name,
    };

    messageNotifier(message.id).pushLayer(newDataLinkLayer);
    sendMessageToConnection(state.connectionId, message.id); //* Send Arp Reply
  }

  void _sendArpRqst(String targetIp) {
    final message =
        SimObjectType.message.createSimObject(
              srcId: state.id,
              dstId:
                  '${DataLinkLayerType.arp.name} ${OperationType.request.name}',
            )
            as Message;

    messageMapNotifier.addSimObject(message);
    messageNotifier(message.id).updateCurrentPlaceId(state.id);

    final arpLayer = {
      MessageKey.operation.name: OperationType.request.name,
      MessageKey.senderIp.name: state.ipAddress,
      MessageKey.targetIp.name: targetIp,
    };

    messageNotifier(message.id).pushLayer(arpLayer);

    final dataLinkLayer = {
      MessageKey.source.name: state.macAddress,
      MessageKey.destination.name: MacAddressManager.broadcastMacAddress,
      MessageKey.type.name: DataLinkLayerType.arp.name,
    };

    messageNotifier(message.id).pushLayer(dataLinkLayer);
    sendMessageToConnection(state.connectionId, message.id);
  }

  String _getMacFromArpTable(String ipAddress) =>
      state.arpTable[ipAddress] ?? '';

  void _updateArpTable(String ipAddress, String macAddress) {
    final newArpTable = Map<String, String>.from(state.arpTable);
    newArpTable[ipAddress] = macAddress;
    state = state.copyWith(arpTable: newArpTable);
  }
}

final hostMapProvider =
    StateNotifierProvider<HostMapNotifier, Map<String, Host>>(
      (ref) => HostMapNotifier(),
    );

class HostMapNotifier extends DeviceMapNotifier<Host> {}

final hostWidgetProvider =
    StateNotifierProvider<HostWidgetNotifier, Map<String, HostWidget>>(
      (ref) => HostWidgetNotifier(),
    );

class HostWidgetNotifier extends DeviceWidgetNotifier<HostWidget> {}
