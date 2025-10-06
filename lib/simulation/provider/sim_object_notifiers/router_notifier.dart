part of 'sim_object_notifier.dart';

final routerProvider = NotifierProvider.family<RouterNotifier, Router, String>(
  RouterNotifier.new,
);

final routerPendingArpReqProvider =
    NotifierProvider.family<
      RouterPendingArpReqNotifier,
      Map<String, Duration>,
      String
    >(RouterPendingArpReqNotifier.new);

final routerMapProvider =
    NotifierProvider<RouterMapNotifier, Map<String, Router>>(
      RouterMapNotifier.new,
    );

final routerWidgetsProvider =
    NotifierProvider<RouterWidgetsNotifier, Map<String, RouterWidget>>(
      RouterWidgetsNotifier.new,
    );

class RouterNotifier extends DeviceNotifier<Router> {
  final String arg;
  final Queue<Map<String, String>> _routerQ = Queue();

  Duration get _arpTimeout =>
      Duration(seconds: ref.read(simScreenProvider).arpReqTimeout.toInt());

  RouterNotifier(this.arg);

  @override
  Router build() {
    ref.onDispose(() {
      _isProcessingMessages = false;
      _messageProcessingTimer?.cancel();
      _messageProcessingTimer = null;
      _routerQ.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.invalidate(routerPendingArpReqProvider(arg));
      });
    });

    return ref.read(routerMapProvider)[arg]!;
  }

  @override
  void removeSelf() {
    final connectionIds = [
      state.eth0conId,
      state.eth1conId,
      state.eth2conId,
      state.eth3conId,
    ];

    final ipAddresses = [
      state.eth0IpAddress,
      state.eth1IpAddress,
      state.eth2IpAddress,
      state.eth3IpAddress,
    ];

    final macAddresses = [
      state.eth0MacAddress,
      state.eth1MacAddress,
      state.eth2MacAddress,
      state.eth3MacAddress,
    ];

    removeMultipleIps(ipAddresses);
    removeMulitpleMacs(macAddresses);
    removeMultipleConnections(connectionIds);
    ref.read(routerMapProvider.notifier).removeAllState(state.id);
  }

  @override
  List<Map<String, String>> getAllConnectionInfo() {
    return [
      {
        ConnInfoKey.name.name: Eth.eth0.name,
        ConnInfoKey.conId.name: state.eth0conId,
      },
      {
        ConnInfoKey.name.name: Eth.eth1.name,
        ConnInfoKey.conId.name: state.eth1conId,
      },
      {
        ConnInfoKey.name.name: Eth.eth2.name,
        ConnInfoKey.conId.name: state.eth2conId,
      },
      {
        ConnInfoKey.name.name: Eth.eth3.name,
        ConnInfoKey.conId.name: state.eth3conId,
      },
    ];
  }

  @override
  void receiveMessage(String messageId, String fromConId) {
    messageNotifier(messageId).updateCurrentPlaceId(state.id);

    addSystemInfoLog(
      'Router "${state.name}" receive message "${messageNotifier(messageId).state.name}"',
    );

    addSystemInfoLog(
      'Message "${messageNotifier(messageId).state.name}" is at router "${state.name}"',
    );

    addInfoLog(messageId, 'Is at router "${state.name}"');

    final dataLinkLayer = messageNotifier(messageId).popLayer();

    addInfoLog(messageId, 'Data Link Layer removed');

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

          _routerQ.add({'messageId': messageId, 'fromConId': fromConId});

          _startMessageProcessing();
      }
    } else {
      addSystemErrorLog(
        'Message "${messageNotifier(messageId).state.name}" dropped, reason: router "${state.name}" is not Recipient of the Frame',
      );

      addErrorLog(
        messageId,
        'Dropped, reason: router "${state.name}" is not Recipient of the Frame',
      );

      messageNotifier(
        messageId,
      ).dropMessage(MsgDropReason.notIntendedRecipientOfFrame);
    }
  }

  void updateIpByEthName(String ethName, String newIp) {
    final eth = Eth.values.firstWhere((e) => e.name == ethName);

    state = switch (eth) {
      Eth.eth0 => state.copyWith(eth0IpAddress: newIp),
      Eth.eth1 => state.copyWith(eth1IpAddress: newIp),
      Eth.eth2 => state.copyWith(eth2IpAddress: newIp),
      Eth.eth3 => state.copyWith(eth3IpAddress: newIp),
    };
  }

  void updateSubnetMaskByEthName(String ethName, String newSubnetMask) {
    final eth = Eth.values.firstWhere((e) => e.name == ethName);

    state = switch (eth) {
      Eth.eth0 => state.copyWith(eth0SubnetMask: newSubnetMask),
      Eth.eth1 => state.copyWith(eth1SubnetMask: newSubnetMask),
      Eth.eth2 => state.copyWith(eth2SubnetMask: newSubnetMask),
      Eth.eth3 => state.copyWith(eth3SubnetMask: newSubnetMask),
    };
  }

  void updateConIdByEthName(String ethName, String newConId) {
    final eth = Eth.values.firstWhere((e) => e.name == ethName);

    state = switch (eth) {
      Eth.eth0 => state.copyWith(eth0conId: newConId),
      Eth.eth1 => state.copyWith(eth1conId: newConId),
      Eth.eth2 => state.copyWith(eth2conId: newConId),
      Eth.eth3 => state.copyWith(eth3conId: newConId),
    };
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

  void addStaticRoute({required String networkId, required String interface_}) {
    final newRoutingTable = Map<String, Map<String, String>>.from(
      state.routingTable,
    );

    newRoutingTable[networkId] = {
      'type': RouteType.static_.label,
      'interface': interface_,
    };

    state = state.copyWith(routingTable: newRoutingTable);
  }

  void updateOrAddRoutingEntry({
    required String type,
    required String subnetMask,
    required String ipAddress,
    required String targetInterface,
  }) {
    final newRoutingTable = Map<String, Map<String, String>>.from(
      state.routingTable,
    );

    String? keyToUpdate;
    for (final entry in newRoutingTable.entries) {
      if (entry.value['interface'] == targetInterface) {
        keyToUpdate = entry.key;
        break;
      }
    }

    if (ipAddress.trim().isEmpty) {
      if (keyToUpdate != null) {
        newRoutingTable.remove(keyToUpdate);
      }
    } else {
      final subnetInCidr = Ipv4AddressManager.subnetToCidr(subnetMask);
      final networkAddress = Ipv4AddressManager.getNetworkAddress(
        ipAddress,
        subnetMask,
      );
      final newKey = networkAddress + subnetInCidr;

      if (keyToUpdate != null && keyToUpdate != newKey) {
        newRoutingTable.remove(keyToUpdate);
      }

      newRoutingTable[newKey] = {'type': type, 'interface': targetInterface};
    }

    state = state.copyWith(routingTable: newRoutingTable);
  }

  void removeRoute(String networkId) {
    final newRoutingTable = Map<String, Map<String, String>>.from(
      state.routingTable,
    );

    newRoutingTable.remove(networkId);

    state = state.copyWith(routingTable: newRoutingTable);
  }

  void _updateArpTable(String ipAddress, String macAddress) {
    final newArpTable = Map<String, String>.from(state.arpTable);
    newArpTable[ipAddress] = macAddress;
    state = state.copyWith(arpTable: newArpTable);

    addInfoLog(state.id, 'Update ARP table $ipAddress => $macAddress');
  }

  String _getMacFromArpTable(String ipAddress) =>
      state.arpTable[ipAddress] ?? '';

  void _startMessageProcessing() {
    if (_isProcessingMessages) return;
    _isProcessingMessages = true;
    addSystemInfoLog('Router "${state.name}" started processing message');
    addInfoLog(state.id, 'Started processing message');
    _processNextMessage();
  }

  void _stopMessageProcessing() {
    _isProcessingMessages = false;
    _messageProcessingTimer?.cancel();
    _messageProcessingTimer = null;
    addSystemInfoLog('Router "${state.name} stopped processing message');
    addInfoLog(state.id, 'Stopped processing message');
  }

  void _scheduleNextProcessing() {
    _messageProcessingTimer?.cancel();
    if (!_isProcessingMessages) return;
    _messageProcessingTimer = Timer(
      DeviceNotifier.processingInterval,
      _processNextMessage,
    );
    addInfoLog(state.id, 'Processing next message');
  }

  bool _isArpTimedOut(String targetIp) {
    final requestTime = ref.read(
      routerPendingArpReqProvider(state.id),
    )[targetIp];
    if (requestTime == null) return false;
    final currentTime = ref.read(simClockProvider);
    return currentTime - requestTime > _arpTimeout;
  }

  void _processNextMessage() {
    if (!_isProcessingMessages || _routerQ.isEmpty) {
      _stopMessageProcessing();
      return;
    }

    final currentMessage = _routerQ.removeFirst();
    if (currentMessage.isEmpty) {
      _scheduleNextProcessing();
      return;
    }

    final messageId = currentMessage['messageId']!;
    final fromConId = currentMessage['fromConId']!;

    final targetIp = messageNotifier(
      messageId,
    ).state.layerStack.last[MessageKey.targetIp.name]!;

    final connectionId = _getEthConId(targetIp);

    if (connectionId.isEmpty) {
      addSystemErrorLog(
        'Router "${state.name}" drop "${messageNotifier(messageId).state.name}", reason: No route or connection for the message',
      );

      addErrorLog(
        messageId,
        'Dropped, reason: Router "${state.name}" has no route or connection',
      );

      addErrorLog(
        state.id,
        'Drop message "${messageNotifier(messageId).state.name}" reason: No route or connection for the message',
      );

      messageNotifier(messageId).dropMessage(MsgDropReason.noRouteForPacket);
      return;
    }

    final interfaceIp = state.conIdToIpAddrMap[connectionId]!;
    final interfaceMask = state.conIdToSubNetMap[connectionId]!;
    final isLocal = Ipv4AddressManager.isInSameNetwork(
      interfaceIp,
      interfaceMask,
      targetIp,
    );

    final arpTargetIp = isLocal
        ? targetIp
        : _getNextHopIpForStaticRoute(targetIp);

    if (ref
        .read(routerPendingArpReqProvider(state.id))
        .containsKey(arpTargetIp)) {
      if (_isArpTimedOut(arpTargetIp)) {
        ref
            .read(routerPendingArpReqProvider(state.id).notifier)
            .removePendingRequest(arpTargetIp);

        addSystemErrorLog(
          'Message "${messageNotifier(messageId).state.name}" dropped at router "${state.name}", reason: ARP Req TimeOut',
        );

        addErrorLog(messageId, 'Dropped, reason: ARP Req TimeOut');

        addErrorLog(
          state.id,
          'Dropped message "${messageNotifier(messageId)}, reason: ARP Req TimeOut',
        );

        messageNotifier(messageId).dropMessage(MsgDropReason.arpReqTimeout);
      } else {
        _routerQ.add({'messageId': messageId, 'fromConId': fromConId});
      }
      _scheduleNextProcessing();
      return;
    }

    final targetMac = _getMacFromArpTable(arpTargetIp);

    if (targetMac.isEmpty) {
      ref
          .read(routerPendingArpReqProvider(state.id).notifier)
          .addPendingRequest(arpTargetIp, ref.read(simClockProvider));

      _sendArpRqst(arpTargetIp, connectionId);
      _routerQ.add({'messageId': messageId, 'fromConId': fromConId});
    } else {
      _makeIpv4DataLinkLayer(messageId, targetMac, connectionId);

      addSystemInfoLog(
        'Router "${state.name}" send message "${messageNotifier(messageId).state.name}"',
      );

      addInfoLog(
        state.id,
        'Message "${messageNotifier(messageId).state.name}" sent to ${connectionNotifier(connectionId).state.name}',
      );

      sendMessageToConnection(connectionId, messageId, state.id);
    }

    _scheduleNextProcessing();
  }

  String _getEthConId(String dstIpAddress) {
    String currentIp = dstIpAddress;
    Set<String> visited = {};

    while (true) {
      String bestMatchNetwork = '';
      int bestMaskLength = -1;

      state.routingTable.forEach((networkWithMask, routeInfo) {
        final parts = networkWithMask.split('/');
        final networkAddr = parts[0];
        final maskLength = int.parse(parts[1]);

        final calculatedNetwork = Ipv4AddressManager.getNetworkAddress(
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

      if (type == RouteType.directed.label) {
        return state.ethToConId[intrfc]!;
      }

      //* now if not directed it either static or dynamic that have an ip on the interface
      if (visited.contains(intrfc)) return ''; //* loop detected

      visited.add(intrfc);
      currentIp = intrfc;
    }
  }

  String _getNextHopIpForStaticRoute(String targetIp) {
    String bestMatchNetwork = '';
    int bestMaskLength = -1;

    state.routingTable.forEach((networkWithMask, routeInfo) {
      final parts = networkWithMask.split('/');
      final maskLength = int.parse(parts[1]);
      final calculatedNetwork = Ipv4AddressManager.getNetworkAddress(
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

    addInfoLog(messageId, 'Data Link Layer Add to the Stack');
  }

  void _sendArpRqst(String targetIp, String fromConId) {
    final message =
        SimObjectType.message.createSimObject(
              name: 'ARP Requestf for $targetIp',
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

    addInfoLog(message.id, 'Is at router "${state.name}"');

    final arpLayer = {
      MessageKey.operation.name: OperationType.request.name,
      MessageKey.senderIp.name: state.conIdToIpAddrMap[fromConId]!,
      MessageKey.targetIp.name: targetIp,
    };

    messageNotifier(message.id).pushLayer(arpLayer);

    addInfoLog(message.id, 'ARP Layer add to the stack');

    final dataLinkLayer = {
      MessageKey.source.name: state.conIdToMacMap[fromConId]!,
      MessageKey.destination.name: MacAddressManager.broadcastMacAddress,
      MessageKey.type.name: DataLinkLayerType.arp.name,
    };

    messageNotifier(message.id).pushLayer(dataLinkLayer);

    addInfoLog(message.id, 'Data Link Layer add to the stack');

    addSystemInfoLog('Router "${state.name}" send "ARP Request for $targetIp"');

    addInfoLog(
      state.id,
      '"ARP Request for $targetIp" sent to ${connectionNotifier(fromConId).state.name}',
    );

    sendMessageToConnection(fromConId, message.id, state.id);
  }

  void _sendArpReply(String targetMac, String targetIp, String fromConId) {
    final message =
        SimObjectType.message.createSimObject(
              name: 'ARP Reply to $targetIp',
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

    addInfoLog(message.id, 'Is at Router "${state.name}"');

    final newArpLayer = {
      MessageKey.operation.name: OperationType.reply.name,
      MessageKey.senderIp.name: state.conIdToIpAddrMap[fromConId]!,
      MessageKey.targetIp.name: targetIp,
    };

    messageNotifier(message.id).pushLayer(newArpLayer);

    addInfoLog(message.id, 'ARP Layer add to the stack');

    final newDataLinkLayer = {
      MessageKey.source.name: state.conIdToMacMap[fromConId]!,
      MessageKey.destination.name: targetMac,
      MessageKey.type.name: DataLinkLayerType.arp.name,
    };

    messageNotifier(message.id).pushLayer(newDataLinkLayer);

    addInfoLog(message.id, 'Data Link Layer add to the stack');

    addSystemInfoLog('Router "${state.name}" send "ARP Reply to $targetIp"');

    addInfoLog(
      state.id,
      '"ARP Reply to $targetIp" sent to ${connectionNotifier(fromConId).state.name}',
    );

    sendMessageToConnection(fromConId, message.id, state.id);
  }

  void _receiveArpMsg(
    String messageId,
    String fromConId,
    Map<String, String> dataLinkLayer,
  ) {
    final arpLayer = messageNotifier(messageId).popLayer();

    addInfoLog(messageId, 'ARP Layer removed');

    final targetIp = arpLayer[MessageKey.targetIp.name]!;
    final senderIp = arpLayer[MessageKey.senderIp.name]!;

    _updateArpTable(senderIp, dataLinkLayer[MessageKey.source.name]!);

    final operation = OperationType.values.firstWhere(
      (e) => e.name == arpLayer[MessageKey.operation.name],
    );

    switch (operation) {
      case OperationType.request:
        if (targetIp == state.conIdToIpAddrMap[fromConId]) {
          addSystemSuccessLog(
            '"${messageNotifier(messageId).state.name}" successfully arrive at Router "${state.name}"',
          );

          addSuccessLog(
            messageId,
            'Successfully arrive at router "${state.name}"',
          );

          addSuccessLog(
            state.id,
            'Receive "${messageNotifier(messageId).state.name}"',
          );

          messageNotifier(messageId).dropMessage(MsgDropReason.arpReqSuccess);

          _sendArpReply(
            dataLinkLayer[MessageKey.source.name]!,
            senderIp,
            fromConId,
          );
        } else {
          addInfoLog(
            messageId,
            'Dropped, reason: ARP Request is not for Router "${state.name}"',
          );

          messageNotifier(messageId).dropMessage(MsgDropReason.arpReqNotMeant);
        }
      case OperationType.reply:
        ref
            .read(routerPendingArpReqProvider(state.id).notifier)
            .removePendingRequest(senderIp);

        addSystemSuccessLog(
          '"${messageNotifier(messageId).state.name}" successfully arrive at router "${state.name}"',
        );

        addSuccessLog(
          messageId,
          'Successfully arrive at router "${state.name}"',
        );

        addSuccessLog(
          state.id,
          'Receive "${messageNotifier(messageId).state.name}"',
        );

        messageNotifier(messageId).dropMessage(MsgDropReason.arpReplySuccess);
    }
  }
}

class RouterPendingArpReqNotifier extends Notifier<Map<String, Duration>> {
  final String arg;
  RouterPendingArpReqNotifier(this.arg);

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

class RouterMapNotifier extends DeviceMapNotifier<Router> {
  RouterMapNotifier()
    : super(
        mapProvider: routerMapProvider,
        objectProvider: routerProvider,
        widgetsProvider: routerWidgetsProvider,
      );
}

class RouterWidgetsNotifier extends DeviceWidgetsNotifier<RouterWidget> {}
