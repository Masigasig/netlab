// ignore_for_file: avoid_public_notifier_properties
part of 'sim_object_notifier.dart';

final routerProvider = NotifierProvider.family<RouterNotifier, Router, String>(
  RouterNotifier.new,
);

class RouterNotifier extends DeviceNotifier<Router> {
  final String arg;
  RouterNotifier(this.arg);

  @override
  Router build() {
    routerQ.clear();
    _pendingArpRequests.clear();
    _messageProcessingTimer?.cancel();
    _messageProcessingTimer = null;
    _isProcessingMessages = false;
    ref.onDispose(() {
      _messageProcessingTimer?.cancel();
    });
    return ref.read(routerMapProvider)[arg]!;
  }

  Queue<Map<String, String>> routerQ = Queue();
  static const _arpTimeout = Duration(seconds: 50);
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
    if (currentMessage.isEmpty) {
      _scheduleNextProcessing();
      return;
    }

    final messageId = currentMessage['messageId']!;
    final fromConId = currentMessage['fromConId']!;

    final targetIp = messageNotifier(
      messageId,
    ).state.layerStack.last[MessageKey.targetIp.name]!;

    final connectionId = getEthConId(targetIp);

    if (connectionId.isEmpty) {
      messageNotifier(messageId).dropMessage(MsgDropReason.noRouteForPacket);
      return;
    }

    final interfaceIp = state.conIdToIpAddMap[connectionId]!;
    final interfaceMask = state.conIdToSubNetMap[connectionId]!;
    final isLocal = IPv4AddressManager.isInSameNetwork(
      interfaceIp,
      interfaceMask,
      targetIp,
    );

    final arpTargetIp = isLocal
        ? targetIp
        : _getNextHopIpForStaticRoute(targetIp);

    if (_pendingArpRequests.containsKey(arpTargetIp)) {
      if (_isArpTimedOut(arpTargetIp)) {
        _pendingArpRequests.remove(arpTargetIp);
        messageNotifier(messageId).dropMessage(MsgDropReason.arpReqTimeout);
      } else {
        routerQ.add({'messageId': messageId, 'fromConId': fromConId});
      }
      _scheduleNextProcessing();
      return;
    }

    final targetMac = _getMacFromArpTable(arpTargetIp);

    if (targetMac.isEmpty) {
      _pendingArpRequests[arpTargetIp] = DateTime.now();
      _sendArpRqst(arpTargetIp, connectionId);
      routerQ.add({'messageId': messageId, 'fromConId': fromConId});
    } else {
      _makeIpv4DataLinkLayer(messageId, targetMac, connectionId);
      sendMessageToConnection(connectionId, messageId, state.id);
    }

    _scheduleNextProcessing();
  }

  String _getNextHopIpForStaticRoute(String targetIp) {
    String bestMatchNetwork = '';
    int bestMaskLength = -1;

    state.routingTable.forEach((networkWithMask, routeInfo) {
      final parts = networkWithMask.split('/');
      final maskLength = int.parse(parts[1]);
      final calculatedNetwork = IPv4AddressManager.getNetworkAddress(
        targetIp,
        '/$maskLength',
      );

      if (calculatedNetwork == parts[0] && maskLength > bestMaskLength) {
        bestMaskLength = maskLength;
        bestMatchNetwork = networkWithMask;
      }
    });

    return bestMatchNetwork.isNotEmpty
        ? state.routingTable[bestMatchNetwork]!['interface']!
        : '';
  }

  void _makeIpv4DataLinkLayer(
    String messageId,
    String targetMac,
    String fromConId,
  ) {
    final dataLinkLayer = {
      MessageKey.source.name: state.conIdToMacMap[fromConId]!,
      MessageKey.destination.name: targetMac,
      MessageKey.type.name: DataLinkLayerType.ipv4.name,
    };

    messageNotifier(messageId).pushLayer(dataLinkLayer);
  }

  bool _isArpTimedOut(String targetIp) {
    final requestTime = _pendingArpRequests[targetIp];
    if (requestTime == null) return false;
    return DateTime.now().difference(requestTime) > _arpTimeout;
  }

  String _getMacFromArpTable(String ipAddress) =>
      state.arpTable[ipAddress] ?? '';

  String getEthConId(String dstIpAddress) {
    String currentIp = dstIpAddress;
    Set<String> visited = {};

    while (true) {
      String bestMatchNetwork = '';
      int bestMaskLength = -1;

      state.routingTable.forEach((networkWithMask, routeInfo) {
        final parts = networkWithMask.split('/');
        final networkAddr = parts[0];
        final maskLength = int.parse(parts[1]);

        final calculatedNetwork = IPv4AddressManager.getNetworkAddress(
          currentIp,
          '/$maskLength',
        );

        if (calculatedNetwork == networkAddr && maskLength > bestMaskLength) {
          bestMaskLength = maskLength;
          bestMatchNetwork = networkWithMask;
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

  void addRoutingEntry(
    String network,
    String type,
    String subnetMask,
    String intfc,
  ) {
    final newRoutingTable = Map<String, Map<String, String>>.from(
      state.routingTable,
    );
    final subnetInCidr = IPv4AddressManager.subnetToCidr(subnetMask);

    newRoutingTable[network + subnetInCidr] = {
      'type': type,
      'interface': intfc,
    };
    state = state.copyWith(routingTable: newRoutingTable);
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

  void updateIpByEthName(String ethName, String newIp) {
    final eth = Eth.values.firstWhere((e) => e.name == ethName);
    switch (eth) {
      case Eth.eth0:
        state = state.copyWith(eth0IpAddress: newIp);
        break;
      case Eth.eth1:
        state = state.copyWith(eth1IpAddress: newIp);
        break;
      case Eth.eth2:
        state = state.copyWith(eth2IpAddress: newIp);
        break;
      case Eth.eth3:
        state = state.copyWith(eth3IpAddress: newIp);
        break;
    }
  }

  void updateSubnetMaskByEthName(String ethName, String newSubnetMask) {
    final eth = Eth.values.firstWhere((e) => e.name == ethName);
    switch (eth) {
      case Eth.eth0:
        state = state.copyWith(eth0SubnetMask: newSubnetMask);
        break;
      case Eth.eth1:
        state = state.copyWith(eth1SubnetMask: newSubnetMask);
        break;
      case Eth.eth2:
        state = state.copyWith(eth2SubnetMask: newSubnetMask);
        break;
      case Eth.eth3:
        state = state.copyWith(eth3SubnetMask: newSubnetMask);
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
    NotifierProvider<RouterMapNotifier, Map<String, Router>>(
      RouterMapNotifier.new,
    );

class RouterMapNotifier extends DeviceMapNotifier<Router> {
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
    NotifierProvider<RouterWidgetNotifier, Map<String, RouterWidget>>(
      RouterWidgetNotifier.new,
    );

class RouterWidgetNotifier extends DeviceWidgetNotifier<RouterWidget> {}
