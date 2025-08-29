part of 'sim_object_notifier.dart';

final routerProvider =
    StateNotifierProvider.family<RouterNotifier, Router, String>(
      (ref, id) => RouterNotifier(ref, id),
    );

class RouterNotifier extends DeviceNotifier<Router> {
  RouterNotifier(Ref ref, String id)
    : super(ref.read(routerMapProvider)[id]!, ref);

  Queue<Map<String, String>> routerQ = Queue();
  // static const _arpTimeout = Duration(seconds: 50);
  static const _processingInterval = Duration(milliseconds: 500);
  final Map<String, DateTime> _pendingArpRequests = {};
  Timer? _messageProcessingTimer;
  bool _isProcessingMessages = false;

  void _startMessageProcessing() {
    if (_isProcessingMessages) return;
    _isProcessingMessages = true;
    _processNextMessage();
  }

  void _stopMessageProcessing() {
    _isProcessingMessages = false;
    _messageProcessingTimer?.cancel();
  }

  void _scheduleNextProcessing() {
    _messageProcessingTimer?.cancel();
    if (!_isProcessingMessages) return;
    _messageProcessingTimer = Timer(_processingInterval, _processNextMessage);
  }

  void _processNextMessage() {
    if (!_isProcessingMessages || routerQ.isEmpty) {
      _stopMessageProcessing();
      return;
    }

    final currentMessage = routerQ.removeFirst();
    final messageId = currentMessage['messageId']!;
    final fromConId = currentMessage['fromConId']!;

    if (currentMessage.isEmpty) {
      _scheduleNextProcessing();
      return;
    }

    //TODO: algorithm;
  }

  String getEthConId(String dstIpAddress) {
    String currentIp = dstIpAddress;
    Set<String> visited = {};

    while (true) {
      String bestMatchNetwork = '';
      int bestMaskLength = -1;

      state.routingTable.forEach((network, routeInfo) {
        final subnetMask = routeInfo['subnetMask']!;
        final maskLength = IPv4AddressManager.getSubnetMaskPrefixLength(
          subnetMask,
        );
        final calculatedNetwork = IPv4AddressManager.getNetworkAddress(
          currentIp,
          subnetMask,
        );

        if (calculatedNetwork == network && maskLength > bestMaskLength) {
          bestMaskLength = maskLength;
          bestMatchNetwork = network;
        }
      });

      if (bestMatchNetwork.isEmpty) return '';

      final routeInfo = state.routingTable[bestMatchNetwork]!;
      final type = routeInfo['type']!;
      final intrfc = routeInfo['interface']!;

      if (type == 'Directed') {
        return state.ethToConId[intrfc]!;
      }

      // now if not directed it either static or dynamic that have an ip on the interface
      if (visited.contains(intrfc)) return ''; //loop detected

      visited.add(intrfc);
      currentIp = intrfc;
    }
  }

  @override
  void receiveMessage(String messageId, String fromConId) {
    messageNotifier(messageId).updateCurrentPlaceId(state.id);

    final dataLinkLayer = messageNotifier(messageId).popLayer();
    final dstMac = dataLinkLayer[MessageKey.destination.name]!;

    if (dstMac == MacAddressManager.broadcastMacAddress ||
        dstMac == state.conIdToMacMap[fromConId]) {
      final type = DataLinkLayerType.values.firstWhere(
        (e) => e.name == dataLinkLayer[MessageKey.type.name],
      );

      switch (type) {
        case DataLinkLayerType.arp:
          _receiveArpMsg(messageId, fromConId, dataLinkLayer);
        case DataLinkLayerType.ipv4:
          final senderIp = messageNotifier(
            messageId,
          ).state.layerStack.last[MessageKey.senderIp.name]!;

          _updateArpTable(senderIp, dataLinkLayer[MessageKey.source.name]!);

          routerQ.add({'messageId': messageId, 'fromConId': fromConId});

          _startMessageProcessing();
      }
    } else {
      messageNotifier(
        messageId,
      ).dropMessage(MsgDropReason.notIntendedRecipientOfFrame);
    }
  }

  void _receiveArpMsg(
    String messageId,
    String fromConId,
    Map<String, String> dataLinkLayer,
  ) {
    final arpLayer = messageNotifier(messageId).popLayer();
    final targetIp = arpLayer[MessageKey.targetIp.name]!;
    final senderIp = arpLayer[MessageKey.senderIp.name]!;

    _updateArpTable(senderIp, dataLinkLayer[MessageKey.source.name]!);

    final operation = OperationType.values.firstWhere(
      (e) => e.name == arpLayer[MessageKey.operation.name],
    );

    switch (operation) {
      case OperationType.request:
        if (targetIp == state.conIdToIpAddMap[fromConId]) {
          messageNotifier(messageId).dropMessage(MsgDropReason.arpReqSuccess);
          _sendArpReply(
            dataLinkLayer[MessageKey.source.name]!,
            senderIp,
            fromConId,
          );
        } else {
          messageNotifier(messageId).dropMessage(MsgDropReason.arpReqNotMeant);
        }
      case OperationType.reply:
        _pendingArpRequests.remove(senderIp);
        messageNotifier(messageId).dropMessage(MsgDropReason.arpReplySuccess);
    }
  }

  void _sendArpReply(String targetMac, String targetIp, String fromConId) {
    final message =
        SimObjectType.message.createSimObject(
              name: 'ARP Reply',
              srcId: state.id,
              dstId: 'ARP Reply',
            )
            as Message;

    messageMapNotifier.addSimObject(message);

    ref
        .read(messageWidgetProvider.notifier)
        .addSimObjectWidget(MessageWidget(simObjectId: message.id));
    messageNotifier(message.id).updatePosition(state.posX, state.posY);
    messageNotifier(message.id).updateCurrentPlaceId(state.id);

    final newArpLayer = {
      MessageKey.operation.name: OperationType.reply.name,
      MessageKey.senderIp.name: state.conIdToIpAddMap[fromConId]!,
      MessageKey.targetIp.name: targetIp,
    };

    messageNotifier(message.id).pushLayer(newArpLayer);

    final newDataLinkLayer = {
      MessageKey.source.name: state.conIdToMacMap[fromConId]!,
      MessageKey.destination.name: targetMac,
      MessageKey.type.name: DataLinkLayerType.arp.name,
    };

    messageNotifier(message.id).pushLayer(newDataLinkLayer);
    sendMessageToConnection(fromConId, message.id, state.id);
  }

  void _sendArpRqst(String targetIp, String fromConId) {
    final message =
        SimObjectType.message.createSimObject(
              name: 'ARP Request',
              srcId: state.id,
              dstId: 'ARP Request',
            )
            as Message;

    messageMapNotifier.addSimObject(message);
    ref
        .read(messageWidgetProvider.notifier)
        .addSimObjectWidget(MessageWidget(simObjectId: message.id));

    messageNotifier(message.id).updatePosition(state.posX, state.posY);
    messageNotifier(message.id).updateCurrentPlaceId(state.id);

    final arpLayer = {
      MessageKey.operation.name: OperationType.request.name,
      MessageKey.senderIp.name: state.conIdToIpAddMap[fromConId]!,
      MessageKey.targetIp.name: targetIp,
    };

    messageNotifier(message.id).pushLayer(arpLayer);

    final dataLinkLayer = {
      MessageKey.source.name: state.conIdToMacMap[fromConId]!,
      MessageKey.destination.name: MacAddressManager.broadcastMacAddress,
      MessageKey.type.name: DataLinkLayerType.arp.name,
    };

    messageNotifier(message.id).pushLayer(dataLinkLayer);
    sendMessageToConnection(fromConId, message.id, state.id);
  }

  void _updateArpTable(String ipAddress, String macAddress) {
    final newArpTable = Map<String, String>.from(state.arpTable);
    newArpTable[ipAddress] = macAddress;
    state = state.copyWith(arpTable: newArpTable);
  }

  @override
  List<Map<String, String>> getAllConnectionInfo() {
    return [
      {
        ConnectionInfoKey.name.name: Eth.eth0.name,
        ConnectionInfoKey.conId.name: state.eth0conId,
      },
      {
        ConnectionInfoKey.name.name: Eth.eth1.name,
        ConnectionInfoKey.conId.name: state.eth1conId,
      },
      {
        ConnectionInfoKey.name.name: Eth.eth2.name,
        ConnectionInfoKey.conId.name: state.eth2conId,
      },
      {
        ConnectionInfoKey.name.name: Eth.eth3.name,
        ConnectionInfoKey.conId.name: state.eth3conId,
      },
    ];
  }

  @override
  void removeSelf() {
    if (state.eth0conId.isNotEmpty) {
      connectionNotifier(state.eth0conId).removeSelf();
    }

    if (state.eth1conId.isNotEmpty) {
      connectionNotifier(state.eth1conId).removeSelf();
    }

    if (state.eth2conId.isNotEmpty) {
      connectionNotifier(state.eth2conId).removeSelf();
    }

    if (state.eth3conId.isNotEmpty) {
      connectionNotifier(state.eth3conId).removeSelf();
    }

    routerMapNotifier.removeAllState(state.id);
  }

  void updateConIdByEthName(String ethName, String newConId) {
    final eth = Eth.values.firstWhere((e) => e.name == ethName);
    switch (eth) {
      case Eth.eth0:
        state = state.copyWith(eth0conId: newConId);
        break;
      case Eth.eth1:
        state = state.copyWith(eth1conId: newConId);
        break;
      case Eth.eth2:
        state = state.copyWith(eth2conId: newConId);
        break;
      case Eth.eth3:
        state = state.copyWith(eth3conId: newConId);
        break;
    }
  }

  void removeConIdByConId(String conId) {
    if (state.eth0conId == conId) {
      state = state.copyWith(eth0conId: '');
    } else if (state.eth1conId == conId) {
      state = state.copyWith(eth1conId: '');
    } else if (state.eth2conId == conId) {
      state = state.copyWith(eth2conId: '');
    } else if (state.eth3conId == conId) {
      state = state.copyWith(eth3conId: '');
    }
  }
}

final routerMapProvider =
    StateNotifierProvider<RouterMapNotifier, Map<String, Router>>(
      (ref) => RouterMapNotifier(ref),
    );

class RouterMapNotifier extends DeviceMapNotifier<Router> {
  RouterMapNotifier(super.ref);

  @override
  List<Map<String, dynamic>> exportToList() {
    return state.keys.map((id) {
      return ref.read(routerProvider(id)).toMap();
    }).toList();
  }

  @override
  void invalidateSpecificId(String objectId) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(routerProvider(objectId));
    });
  }

  @override
  void removeAllState(String objectId) {
    ref.read(routerWidgetProvider.notifier).removeSimObjectWidget(objectId);
    removeSimObject(objectId);
    invalidateSpecificId(objectId);
  }
}

final routerWidgetProvider =
    StateNotifierProvider<RouterWidgetNotifier, Map<String, RouterWidget>>(
      (ref) => RouterWidgetNotifier(),
    );

class RouterWidgetNotifier extends DeviceWidgetNotifier<RouterWidget> {}
