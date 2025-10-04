part of 'sim_object_notifier.dart';

final hostProvider = NotifierProvider.family<HostNotifier, Host, String>(
  HostNotifier.new,
);

final hostPendingArpReqProvider =
    NotifierProvider.family<
      HostPendingArpReqNotifier,
      Map<String, Duration>,
      String
    >(HostPendingArpReqNotifier.new);

final hostMapProvider = NotifierProvider<HostMapNotifier, Map<String, Host>>(
  HostMapNotifier.new,
);

final hostWidgetsProvider =
    NotifierProvider<HostWidgetsNotifier, Map<String, HostWidget>>(
      HostWidgetsNotifier.new,
    );

class HostNotifier extends DeviceNotifier<Host> {
  //* TODO: logs of what happenings
  //* TODO: method organization

  final String arg;
  static const Duration _processingInterval = Duration(milliseconds: 500);
  Timer? _messageProcessingTimer;
  bool _isProcessingMessages = false;

  Duration get _arpTimeout =>
      Duration(seconds: ref.read(simScreenProvider).arpReqTimeout.toInt());

  HostNotifier(this.arg);

  @override
  Host build() {
    ref.onDispose(() {
      _isProcessingMessages = false;
      _messageProcessingTimer?.cancel();
      _messageProcessingTimer = null;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.invalidate(hostPendingArpReqProvider(arg));
      });
    });
    return ref.read(hostMapProvider)[arg]!;
  }

  @override
  void removeSelf() {
    removeIpFromManager(state.ipAddress);
    removeMacFromManager(state.macAddress);
    removeConnectionById(state.connectionId);

    if (state.messageIds.isNotEmpty) {
      final messageIds = state.messageIds;
      for (final messageId in messageIds) {
        messageNotifier(messageId).removeSelf();
      }
    }

    ref.read(hostMapProvider.notifier).removeAllState(state.id);
  }

  @override
  List<Map<String, String>> getAllConnectionInfo() {
    return [
      {
        ConnInfoKey.name.name: Eth.eth0.name,
        ConnInfoKey.conId.name: state.connectionId,
      },
    ];
  }

  @override
  void receiveMessage(String messageId, String fromConId) {
    messageNotifier(messageId).updateCurrentPlaceId(state.id);

    final dataLinkLayer = messageNotifier(messageId).popLayer();
    final dstMac = dataLinkLayer[MessageKey.destination.name]!;

    if (dstMac == MacAddressManager.broadcastMacAddress ||
        dstMac == state.macAddress) {
      final type = DataLinkLayerType.values.firstWhere(
        (e) => e.name == dataLinkLayer[MessageKey.type.name],
      );

      switch (type) {
        case DataLinkLayerType.arp:
          _receiveArpMsg(messageId, dataLinkLayer);
        case DataLinkLayerType.ipv4:
          _receiveIpv4Msg(messageId, dataLinkLayer);
      }
    } else {
      messageNotifier(
        messageId,
      ).dropMessage(MsgDropReason.notIntendedRecipientOfFrame);
    }
  }

  void updateIpAddress(String ipAddress) =>
      state = state.copyWith(ipAddress: ipAddress);

  void updateSubnetMask(String subnetMask) =>
      state = state.copyWith(subnetMask: subnetMask);

  void updateDefaultGateway(String defaultGateway) =>
      state = state.copyWith(defaultGateway: defaultGateway);

  void updateConnectionId(String connectionId) =>
      state = state.copyWith(connectionId: connectionId);

  void enqueueMessage(String messageId) {
    final newMessageIds = List<String>.from(state.messageIds)..add(messageId);
    state = state.copyWith(messageIds: newMessageIds);
  }

  void removeMessage(String messageId) {
    final newMessageIds = List<String>.from(state.messageIds)
      ..remove(messageId);
    state = state.copyWith(messageIds: newMessageIds);
  }

  void startMessageProcessing() {
    if (_isProcessingMessages) return;
    _isProcessingMessages = true;
    _processNextMessage();
  }

  String _dequeueMessage() {
    if (state.messageIds.isEmpty) return '';
    final messageIds = List<String>.from(state.messageIds);
    final messageId = messageIds.removeAt(0);
    state = state.copyWith(messageIds: messageIds);
    return messageId;
  }

  String _getMacFromArpTable(String ipAddress) =>
      state.arpTable[ipAddress] ?? '';

  void _updateArpTable(String ipAddress, String macAddress) {
    final newArpTable = Map<String, String>.from(state.arpTable);
    newArpTable[ipAddress] = macAddress;
    state = state.copyWith(arpTable: newArpTable);
  }

  void _stopMessgageProcessing() {
    _isProcessingMessages = false;
    _messageProcessingTimer?.cancel();
    _messageProcessingTimer = null;
  }

  void _processNextMessage() {
    if (!_isProcessingMessages || state.messageIds.isEmpty) {
      _stopMessgageProcessing();
      return;
    }

    final messageId = _dequeueMessage();
    if (messageId.isEmpty) {
      _scheduleNextProcessing();
      return;
    }

    _makeNetworkLayer(messageId);
    final targetIp = messageNotifier(messageId).getTargetIp();

    final isTargetInDifferentNetwork = !Ipv4AddressManager.isInSameNetwork(
      state.ipAddress,
      state.subnetMask,
      targetIp,
    );

    final lookupIp = isTargetInDifferentNetwork
        ? state.defaultGateway
        : targetIp;

    if (ref.read(hostPendingArpReqProvider(state.id)).containsKey(lookupIp)) {
      if (_isArpTimedOut(lookupIp)) {
        ref
            .read(hostPendingArpReqProvider(state.id).notifier)
            .removePendingRequest(lookupIp);
        messageNotifier(messageId).dropMessage(MsgDropReason.arpReqTimeout);
      } else {
        enqueueMessage(messageId);
      }
      _scheduleNextProcessing();
      return;
    }

    final targetMac = _getMacFromArpTable(lookupIp);

    if (targetMac.isEmpty) {
      ref
          .read(hostPendingArpReqProvider(state.id).notifier)
          .addPendingRequest(lookupIp, ref.read(simClockProvider));
      _sendArpRqst(lookupIp);
      enqueueMessage(messageId);
    } else {
      _makeIpv4DataLinkLayer(messageId, targetMac);
      sendMessageToConnection(state.connectionId, messageId, state.id);
    }

    _scheduleNextProcessing();
  }

  void _scheduleNextProcessing() {
    _messageProcessingTimer?.cancel();
    if (!_isProcessingMessages) return;
    _messageProcessingTimer = Timer(_processingInterval, _processNextMessage);
  }

  void _makeNetworkLayer(String messageId) {
    final networkLayer = {
      MessageKey.senderIp.name: state.ipAddress,
      MessageKey.targetIp.name: messageNotifier(messageId).getTargetIp(),
    };

    messageNotifier(messageId).pushLayer(networkLayer);
  }

  bool _isArpTimedOut(String targetIp) {
    final requestTime = ref.read(hostPendingArpReqProvider(state.id))[targetIp];
    if (requestTime == null) return false;
    final currentTime = ref.read(simClockProvider);
    return currentTime - requestTime > _arpTimeout;
  }

  void _sendArpRqst(String targetIp) {
    final message =
        SimObjectType.message.createSimObject(
              name: 'ARP Request',
              srcId: state.id,
              dstId: 'ARP Request',
            )
            as Message;

    ref.read(messageMapProvider.notifier).addSimObject(message);
    ref
        .read(messageWidgetsProvider.notifier)
        .addSimObjectWidget(MessageWidget(simObjectId: message.id));

    messageNotifier(message.id).updatePosition(state.posX, state.posY);
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
    sendMessageToConnection(state.connectionId, message.id, state.id);
  }

  void _makeIpv4DataLinkLayer(String messageId, String targetMac) {
    final dataLinkLayer = {
      MessageKey.source.name: state.macAddress,
      MessageKey.destination.name: targetMac,
      MessageKey.type.name: DataLinkLayerType.ipv4.name,
    };

    messageNotifier(messageId).pushLayer(dataLinkLayer);
  }

  void _receiveArpMsg(String messageId, Map<String, String> dataLinkLayer) {
    final arpLayer = messageNotifier(messageId).popLayer();
    final targetIp = arpLayer[MessageKey.targetIp.name]!;
    final senderIp = arpLayer[MessageKey.senderIp.name]!;

    _updateArpTable(senderIp, dataLinkLayer[MessageKey.source.name]!);

    final operation = OperationType.values.firstWhere(
      (e) => e.name == arpLayer[MessageKey.operation.name],
    );

    switch (operation) {
      case OperationType.request:
        if (targetIp == state.ipAddress) {
          messageNotifier(messageId).dropMessage(MsgDropReason.arpReqSuccess);
          _sendArpReply(dataLinkLayer[MessageKey.source.name]!, senderIp);
        } else {
          messageNotifier(messageId).dropMessage(MsgDropReason.arpReqNotMeant);
        }
      case OperationType.reply:
        ref
            .read(hostPendingArpReqProvider(state.id).notifier)
            .removePendingRequest(senderIp);
        messageNotifier(messageId).dropMessage(MsgDropReason.arpReplySuccess);
    }
  }

  void _sendArpReply(String targetMac, String targetIp) {
    final message =
        SimObjectType.message.createSimObject(
              name: 'ARP Reply',
              srcId: state.id,
              dstId: 'ARP Reply',
            )
            as Message;

    ref.read(messageMapProvider.notifier).addSimObject(message);
    ref
        .read(messageWidgetsProvider.notifier)
        .addSimObjectWidget(MessageWidget(simObjectId: message.id));
    messageNotifier(message.id).updatePosition(state.posX, state.posY);
    messageNotifier(message.id).updateCurrentPlaceId(state.id);

    final newArpLayer = {
      MessageKey.operation.name: OperationType.reply.name,
      MessageKey.senderIp.name: state.ipAddress,
      MessageKey.targetIp.name: targetIp,
    };

    messageNotifier(message.id).pushLayer(newArpLayer);

    final newDataLinkLayer = {
      MessageKey.source.name: state.macAddress,
      MessageKey.destination.name: targetMac,
      MessageKey.type.name: DataLinkLayerType.arp.name,
    };

    messageNotifier(message.id).pushLayer(newDataLinkLayer);
    sendMessageToConnection(state.connectionId, message.id, state.id);
  }

  void _receiveIpv4Msg(String messageId, Map<String, String> dataLinkLayer) {
    final networkLayer = messageNotifier(messageId).popLayer();

    _updateArpTable(
      networkLayer[MessageKey.senderIp.name]!,
      dataLinkLayer[MessageKey.source.name]!,
    );

    final targetIp = networkLayer[MessageKey.targetIp.name];

    if (targetIp == state.ipAddress) {
      messageNotifier(messageId).dropMessage(MsgDropReason.ipv4Success);
    } else {
      messageNotifier(messageId).dropMessage(MsgDropReason.ipv4Fail);
    }
  }
}

class HostPendingArpReqNotifier extends Notifier<Map<String, Duration>> {
  final String arg;
  HostPendingArpReqNotifier(this.arg);

  @override
  Map<String, Duration> build() {
    return {};
  }

  void addPendingRequest(String ipAddress, Duration timeout) {
    state = {...state, ipAddress: timeout};
  }

  void removePendingRequest(String ipAddress) {
    state = {...state}..remove(ipAddress);
  }
}

class HostMapNotifier extends DeviceMapNotifier<Host> {
  HostMapNotifier()
    : super(
        mapProvider: hostMapProvider,
        objectProvider: hostProvider,
        widgetsProvider: hostWidgetsProvider,
      );
}

class HostWidgetsNotifier extends DeviceWidgetsNotifier<HostWidget> {}
