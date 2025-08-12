part of 'sim_object_notifier.dart';

final hostProvider = StateNotifierProvider.family
    .autoDispose<HostNotifier, Host, String>(
      (ref, id) => HostNotifier(ref, id),
    );

class HostNotifier extends DeviceNotifier<Host> {
  HostNotifier(Ref ref, String id) : super(ref.read(hostMapProvider)[id]!, ref);

  static const _arpTimeout = Duration(seconds: 10);
  static const _processingInterval = Duration(milliseconds: 100);
  final Map<String, DateTime> _pendingArpRequests = {};
  Timer? _messageProcessingTimer;
  bool _isProcessingMessages = false;

  @override
  void dispose() {
    _messageProcessingTimer?.cancel();
    super.dispose();
  }

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
        _receiveIpv4Msg(messageId, dataLinkLayer);
    }
  }

  void startMessageProcessing() {
    if (_isProcessingMessages) return;
    _isProcessingMessages = true;
    _processNextMessage();
  }

  void stopMessageProcessing() {
    _isProcessingMessages = false;
    _messageProcessingTimer?.cancel();
  }

  void updateIpAddress(String ipAddress) =>
      state = state.copyWith(ipAddress: ipAddress);

  void updateSubnetMask(String subnetMask) =>
      state = state.copyWith(subnetMask: subnetMask);

  void updateDefaultGateway(String defaultGateway) =>
      state = state.copyWith(defaultGateway: defaultGateway);

  void updateConnectionId(String connectionId) =>
      state = state.copyWith(connectionId: connectionId);

  void _processNextMessage() {
    if (!_isProcessingMessages || state.messageIds.isEmpty) {
      stopMessageProcessing();
      return;
    }

    final messageId = _dequeueMessage();
    if (messageId.isEmpty) {
      _scheduleNextProcessing();
      return;
    }

    _makeNetworkLayer(messageId);
    final targetIp = messageNotifier(
      messageId,
    ).state.layerStack.last[MessageKey.targetIp.name]!;

    if (_pendingArpRequests.containsKey(targetIp)) {
      if (_isArpTimedOut(targetIp)) {
        _pendingArpRequests.remove(targetIp);
        messageNotifier(messageId).dropMessage(); //* Arp Timout
      } else {
        _enqueueMessage(messageId);
      }
      _scheduleNextProcessing();
      return;
    }

    final isTargetInDifferentNetwork = !IPv4AddressManager.isInSameNetwork(
      state.ipAddress,
      state.subnetMask,
      targetIp,
    );

    final lookupIp = isTargetInDifferentNetwork
        ? state.defaultGateway
        : targetIp;

    final targetMac = _getMacFromArpTable(lookupIp);

    if (targetMac.isEmpty) {
      _pendingArpRequests[targetIp] = DateTime.now();
      _sendArpRqst(lookupIp);
      _enqueueMessage(messageId);
    } else {
      _makeIpv4DataLinkLayer(messageId, targetMac);
      sendMessageToConnection(state.connectionId, messageId);
    }

    _scheduleNextProcessing();
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
          _sendArpReply(dataLinkLayer[MessageKey.source.name]!);
        } else {
          messageNotifier(
            messageId,
          ).dropMessage(); //* ARP Request is not meant for this Host
        }
      case OperationType.reply:
        messageNotifier(messageId).dropMessage(); //* ARP Reply Recieve
    }
  }

  void _receiveIpv4Msg(String messageId, Map<String, String> dataLinkLayer) {
    final networkLayer = messageNotifier(messageId).popLayer();

    _updateArpTable(
      networkLayer[MessageKey.senderIp.name]!,
      dataLinkLayer[MessageKey.source.name]!,
    );

    final targetIp = networkLayer[MessageKey.targetIp.name];

    if (targetIp == state.ipAddress) {
      messageNotifier(
        messageId,
      ).dropMessage(); //* IPv4 Message Arrive successfully
    } else {
      messageNotifier(
        messageId,
      ).dropMessage(); //* IPv4 Message is not meant for this Host
    }
  }

  void _scheduleNextProcessing() {
    _messageProcessingTimer?.cancel();
    if (!_isProcessingMessages) return;
    _messageProcessingTimer = Timer(_processingInterval, _processNextMessage);
  }

  bool _isArpTimedOut(String targetIp) {
    final requestTime = _pendingArpRequests[targetIp];
    if (requestTime == null) return false;
    return DateTime.now().difference(requestTime) > _arpTimeout;
  }

  void _makeNetworkLayer(String messageId) {
    final networkLayer = {
      MessageKey.senderIp.name: state.ipAddress,
      MessageKey.targetIp.name: messageNotifier(messageId).getTargetIp(),
    };

    messageNotifier(messageId).pushLayer(networkLayer);
  }

  void _makeIpv4DataLinkLayer(String messageId, String targetMac) {
    final dataLinkLayer = {
      MessageKey.source.name: state.macAddress,
      MessageKey.destination.name: targetMac,
      MessageKey.type.name: DataLinkLayerType.ipv4.name,
    };

    messageNotifier(messageId).pushLayer(dataLinkLayer);
  }

  void _enqueueMessage(String messageId) {
    final newMessageIds = List<String>.from(state.messageIds)..add(messageId);
    state = state.copyWith(messageIds: newMessageIds);
  }

  String _dequeueMessage() {
    if (state.messageIds.isEmpty) return '';
    final messageIds = List<String>.from(state.messageIds);
    final messageId = messageIds.removeAt(0);
    state = state.copyWith(messageIds: messageIds);
    return messageId;
  }

  void _sendArpReply(String targetMac) {
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
