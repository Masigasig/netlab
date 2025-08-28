part of 'sim_object_notifier.dart';

final routerProvider =
    StateNotifierProvider.family<RouterNotifier, Router, String>(
      (ref, id) => RouterNotifier(ref, id),
    );

class RouterNotifier extends DeviceNotifier<Router> {
  RouterNotifier(Ref ref, String id)
    : super(ref.read(routerMapProvider)[id]!, ref);

  // static const _arpTimeout = Duration(seconds: 50);
  // static const _processingInterval = Duration(milliseconds: 500);
  final Map<String, DateTime> _pendingArpRequests = {};
  // Timer? _messageProcessingTimer;
  // bool _isProcessingMessages = false;

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
        // handle Ipv4
        // TODO* implement IPv4 message handling
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
