part of 'sim_object_notifier.dart';

final wirelessHostProvider =
    NotifierProvider.family<WirelessHostNotifier, WirelessHost, String>(
      WirelessHostNotifier.new,
    );

final wirelessHostPendingArpReqProvider =
    NotifierProvider.family<
      WirelessHostPendingArpReqNotifier,
      Map<String, Duration>,
      String
    >(WirelessHostPendingArpReqNotifier.new);

final wirelessHostMapProvider =
    NotifierProvider<WirelessHostMapNotifier, Map<String, WirelessHost>>(
      WirelessHostMapNotifier.new,
    );

final wirelessHostWidgetsProvider =
    NotifierProvider<
      WirelessHostWidgetsNotifier,
      Map<String, WirelessHostWidget>
    >(WirelessHostWidgetsNotifier.new);

class WirelessHostNotifier extends DeviceNotifier<WirelessHost> {
  final String arg;

  Duration get _arpTimeout =>
      Duration(seconds: ref.read(simScreenProvider).arpReqTimeout.toInt());

  WirelessHostNotifier(this.arg);

  @override
  WirelessHost build() {
    ref.onDispose(() {
      _isProcessingMessages = false;
      _messageProcessingTimer?.cancel();
      _messageProcessingTimer = null;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.invalidate(wirelessHostPendingArpReqProvider(arg));
      });
    });
    return ref.read(wirelessHostMapProvider)[arg]!;
  }

  @override
  void removeSelf() {
    removeIpFromManager(state.ipAddress);
    removeMacFromManager(state.macAddress);
    removeWirelessConById(state.wirelessConId);

    if (state.messageIds.isNotEmpty) {
      final messageIds = state.messageIds;
      for (final messageId in messageIds) {
        messageNotifier(messageId).removeSelf();
      }
    }

    ref.read(wirelessHostMapProvider.notifier).removeAllState(state.id);
  }

  @override
  List<Map<String, String>> getAllConnectionInfo() {
    //* This method wont be called
    return [];
  }

  @override
  void receiveMessage(String messageId, String fromWirelessConId) {
    messageNotifier(messageId).updateCurrentPlaceId(state.id);

    addSystemInfoLog(
      'Wireless Host "${state.name}" receive message "${messageNotifier(messageId).state.name}"',
    );

    addSystemInfoLog(
      'Message "${messageNotifier(messageId).state.name}" is at wireless host "${state.name}"',
    );

    addInfoLog(messageId, 'Is at wireless host "${state.name}"');

    final dataLinkLayer = messageNotifier(messageId).popLayer();

    addInfoLog(messageId, 'Data Link Layer removed');

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
      addSystemErrorLog(
        'Message "${messageNotifier(messageId).state.name}" dropped, reason: Wireless host "${state.name}" is not recipient of the Frame',
      );

      addErrorLog(
        messageId,
        'Dropped, reason: Wireless host "${state.name}" is not recipient of the Frame',
      );

      addErrorLog(
        state.id,
        'Drop message "${messageNotifier(messageId).state.name}", reason: not recipient of the Frame',
      );

      messageNotifier(messageId).dropMessage();
    }
  }

  void updateIpAddress(String ipAddress) {
    state = state.copyWith(ipAddress: ipAddress);
    addInfoLog(state.id, 'Ipv4 address updated to $ipAddress');
  }

  void updateSubnetMask(String subnetMask) {
    state = state.copyWith(subnetMask: subnetMask);
    addInfoLog(state.id, 'Subnetmask updated to $subnetMask');
  }

  void updateDefaultGateway(String defaultGateway) {
    state = state.copyWith(defaultGateway: defaultGateway);
    addInfoLog(state.id, 'DefualtGateway updated to $defaultGateway');
  }

  void updateWirelessConId(String wirelessConId) {
    if (wirelessConId == '') {
      addInfoLog(state.id, 'Connection Removed');
    }

    state = state.copyWith(wirelessConId: wirelessConId);
  }

  void connectToAccessPoint(String accessPointId) {
    if (state.wirelessConId.isNotEmpty) {
      disconnectToAccessPoint();
    }
    final wirelessConId = ref
        .read(simScreenProvider.notifier)
        .createWirelessConnection(state.id, accessPointId);

    updateWirelessConId(wirelessConId);

    ref
        .read(accessPointProvider(accessPointId).notifier)
        .updateConIdtoDeviceIdMap(wirelessConId, state.id);
  }

  void disconnectToAccessPoint() {
    ref.read(wirelessConProvider(state.wirelessConId).notifier).removeSelf();
  }

  void enqueueMessage(String messageId) {
    final newMessageIds = List<String>.from(state.messageIds)..add(messageId);
    state = state.copyWith(messageIds: newMessageIds);

    if (ref.read(simScreenProvider).isPlaying) {
      messageNotifier(messageId).updatePosition(state.posX, state.posY);
      if (!_isProcessingMessages) {
        startMessageProcessing();
      }
    }
  }

  void removeMessage(String messageId) {
    final newMessageIds = List<String>.from(state.messageIds)
      ..remove(messageId);
    state = state.copyWith(messageIds: newMessageIds);
  }

  void startMessageProcessing() {
    //*TODO: message Processing
  }

  void _updateArpTable(String ipAddress, String macAddress) {
    final newArpTable = Map<String, String>.from(state.arpTable);
    newArpTable[ipAddress] = macAddress;
    state = state.copyWith(arpTable: newArpTable);

    addInfoLog(state.id, 'Update ARP table $ipAddress -> $macAddress');
  }

  void _sendArpReply(String targetMac, String targetIp) {
    final message =
        SimObjectType.message.createSimObject(
              name: 'ARP Reply to $targetIp',
              srcId: state.id,
              dstId: 'ARP Reply to $targetIp',
            )
            as Message;

    ref.read(messageMapProvider.notifier).addSimObject(message);
    ref
        .read(messageWidgetsProvider.notifier)
        .addSimObjectWidget(MessageWidget(simObjectId: message.id));
    messageNotifier(message.id).updatePosition(state.posX, state.posY);
    messageNotifier(message.id).updateCurrentPlaceId(state.id);

    addInfoLog(message.id, 'Is at wireless host "${state.name}"');

    final newArpLayer = {
      MessageKey.operation.name: OperationType.reply.name,
      MessageKey.senderIp.name: state.ipAddress,
      MessageKey.targetIp.name: targetIp,
    };

    messageNotifier(message.id).pushLayer(newArpLayer);

    addInfoLog(message.id, 'ARP Layer add to the stack');

    final newDataLinkLayer = {
      MessageKey.source.name: state.macAddress,
      MessageKey.destination.name: targetMac,
      MessageKey.type.name: DataLinkLayerType.arp.name,
    };

    messageNotifier(message.id).pushLayer(newDataLinkLayer);

    addInfoLog(message.id, 'Data Link Layer add to the stack');

    addSystemInfoLog(
      'Wireless host "${state.name}" send "ARP Reply to $targetIp"',
    );

    addInfoLog(
      state.id,
      '"ARP Reply to $targetIp" sent to ${wirelessConNotifier(state.wirelessConId).state.name}',
    );

    sendMessageToConnection(state.wirelessConId, message.id, state.id);
  }

  void _receiveArpMsg(String messageId, Map<String, String> dataLinkLayer) {
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
        if (targetIp == state.ipAddress) {
          addSystemSuccessLog(
            '"${messageNotifier(messageId).state.name}" successfully arrive at wireless host "${state.name}"',
          );

          addSuccessLog(
            messageId,
            'Successfully arrive at wireless host "${state.name}"',
          );

          addSuccessLog(
            state.id,
            'Receive "${messageNotifier(messageId).state.name}"',
          );

          messageNotifier(messageId).dropMessage();
          _sendArpReply(dataLinkLayer[MessageKey.source.name]!, senderIp);
        } else {
          addErrorLog(
            messageId,
            'Dropped, reason: ARP Request is not for host "${state.name}"',
          );

          addErrorLog(
            state.id,
            'Drop "${messageNotifier(messageId).state.name}", reason: not recipient of the ARP Request',
          );

          messageNotifier(messageId).dropMessage();
        }
      case OperationType.reply:
        ref
            .read(wirelessHostPendingArpReqProvider(state.id).notifier)
            .removePendingRequest(senderIp);

        addSystemSuccessLog(
          '"${messageNotifier(messageId).state.name}" successfully arrive at wireless host "${state.name}"',
        );

        addSuccessLog(
          messageId,
          'Successfully arrive at wireless host "${state.name}"',
        );

        addSuccessLog(
          state.id,
          'Receive "${messageNotifier(messageId).state.name}"',
        );

        messageNotifier(messageId).dropMessage();
    }
  }

  void _receiveIpv4Msg(String messageId, Map<String, String> dataLinkLayer) {
    final networkLayer = messageNotifier(messageId).popLayer();

    addInfoLog(messageId, 'Network Layer removed');

    _updateArpTable(
      networkLayer[MessageKey.senderIp.name]!,
      dataLinkLayer[MessageKey.targetIp.name]!,
    );

    final targetIp = networkLayer[MessageKey.targetIp.name];

    if (targetIp == state.ipAddress) {
      addSystemSuccessLog(
        'Message "${messageNotifier(messageId).state.name}" successfully arrive at wireless host "${state.name}"',
      );

      addSuccessLog(
        state.id,
        'Successfully receive message "${messageNotifier(messageId).state.name}"',
      );

      addSuccessLog(
        messageId,
        'Successfully arrive at wireless host "${state.name}"',
      );

      messageNotifier(messageId).dropMessage();
    } else {
      addSystemErrorLog(
        'Message "${messageNotifier(messageId).state.name}" dropped, reason: not intended packet for wireless host "${state.name}"',
      );

      addErrorLog(
        messageId,
        'Dropped, reason: Wireless host "${state.name}" is not recipient of the Packet',
      );

      addErrorLog(
        state.id,
        'Drop message "${messageNotifier(messageId).state.name}", reason: not recipient of the Packet',
      );

      messageNotifier(messageId).dropMessage();
    }
  }
}

class WirelessHostPendingArpReqNotifier
    extends Notifier<Map<String, Duration>> {
  final String arg;
  WirelessHostPendingArpReqNotifier(this.arg);

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

class WirelessHostMapNotifier extends DeviceMapNotifier<WirelessHost> {
  WirelessHostMapNotifier()
    : super(
        mapProvider: wirelessHostMapProvider,
        objectProvider: wirelessHostProvider,
        widgetsProvider: wirelessHostWidgetsProvider,
      );
}

class WirelessHostWidgetsNotifier
    extends DeviceWidgetsNotifier<WirelessHostWidget> {}
