// ignore_for_file: avoid_public_notifier_properties
part of 'sim_object_notifier.dart';

final switchProvider = NotifierProvider.family<SwitchNotifier, Switch, String>(
  SwitchNotifier.new,
);

class SwitchNotifier extends DeviceNotifier<Switch> {
  final String arg;
  SwitchNotifier(this.arg);

  @override
  Switch build() {
    switchQ.clear();
    _messageProcessingTimer?.cancel();
    _messageProcessingTimer = null;
    _isProcessingMessages = false;
    ref.onDispose(() {
      _messageProcessingTimer?.cancel();
    });
    return ref.read(switchMapProvider)[arg]!;
  }

  Queue<Map<String, String>> switchQ = Queue();
  static const _processingInterval = Duration(milliseconds: 500);
  Timer? _messageProcessingTimer;
  bool _isProcessingMessages = false;

  @override
  void receiveMessage(String messageId, String fromConId) {
    messageNotifier(messageId).updateCurrentPlaceId(state.id);
    final sourceMac = messageNotifier(
      messageId,
    ).state.layerStack.last[MessageKey.source.name]!;

    final port = state.conIdToPortMap[fromConId]!;

    updateMacTable(sourceMac, port);

    switchQ.add({'messageId': messageId, 'fromConId': fromConId});

    _startMessageProcessing();
  }

  void _startMessageProcessing() {
    if (_isProcessingMessages) return;
    _isProcessingMessages = true;
    _processNextMessage();
  }

  void _stopMessageProcessing() {
    _isProcessingMessages = false;
    _messageProcessingTimer?.cancel();
  }

  void _processNextMessage() {
    if (!_isProcessingMessages || switchQ.isEmpty) {
      _stopMessageProcessing();
      return;
    }

    final currentMessage = switchQ.removeFirst();
    final messageId = currentMessage['messageId']!;
    final fromConId = currentMessage['fromConId']!;

    if (currentMessage.isEmpty) {
      _scheduleNextProcessing();
      return;
    }

    final dstMac = messageNotifier(
      messageId,
    ).state.layerStack.last[MessageKey.destination.name]!;

    final port = getPortFromMacTable(dstMac);

    if (port.isEmpty) {
      final activePorts = state.activeConnectionIds;
      activePorts.remove(fromConId);

      final List<String> messagesIds = [messageId];

      for (int i = 0; i < activePorts.length - 1; i++) {
        messagesIds.add(duplicateMessage(messageId));
      }

      for (int i = 0; i < activePorts.length; i++) {
        sendMessageToConnection(activePorts[i], messagesIds[i], state.id);
      }
    } else {
      final connectionId = state.portToConIdMap[port]!;
      sendMessageToConnection(connectionId, messageId, state.id);
    }

    _scheduleNextProcessing();
  }

  String duplicateMessage(String messageId) {
    final dataLinkLayer = messageNotifier(messageId).popLayer();
    final networkLayer = messageNotifier(messageId).popLayer();
    messageNotifier(messageId).pushLayer(networkLayer);
    messageNotifier(messageId).pushLayer(dataLinkLayer);

    final newMessage =
        SimObjectType.message.createSimObject(
              name: messageNotifier(messageId).state.name,
              srcId: messageNotifier(messageId).state.srcId,
              dstId: messageNotifier(messageId).state.dstId,
            )
            as Message;

    final widget =
        SimObjectType.message.createSimObjectWidget(simObjectId: newMessage.id)
            as MessageWidget;

    ref.read(messageMapProvider.notifier).addSimObject(newMessage);
    ref.read(messageWidgetProvider.notifier).addSimObjectWidget(widget);

    messageNotifier(newMessage.id).updatePosition(
      messageNotifier(messageId).state.posX,
      messageNotifier(messageId).state.posY,
      duration: messageNotifier(messageId).state.duration,
    );

    messageNotifier(
      newMessage.id,
    ).updateCurrentPlaceId(messageNotifier(messageId).state.currentPlaceId);

    messageNotifier(newMessage.id).pushLayer(networkLayer);
    messageNotifier(newMessage.id).pushLayer(dataLinkLayer);

    return newMessage.id;
  }

  void _scheduleNextProcessing() {
    _messageProcessingTimer?.cancel();
    if (!_isProcessingMessages) return;
    _messageProcessingTimer = Timer(_processingInterval, _processNextMessage);
  }

  void updateMacTable(String mac, String port) {
    final newMacTable = Map<String, String>.from(state.macTable);
    newMacTable[mac] = port;
    state = state.copyWith(macTable: newMacTable);
  }

  String getPortFromMacTable(String macAddress) =>
      state.macTable[macAddress] ?? '';

  @override
  List<Map<String, String>> getAllConnectionInfo() {
    return [
      {
        ConnectionInfoKey.name.name: Port.port0.name,
        ConnectionInfoKey.conId.name: state.port0conId,
      },
      {
        ConnectionInfoKey.name.name: Port.port1.name,
        ConnectionInfoKey.conId.name: state.port1conId,
      },
      {
        ConnectionInfoKey.name.name: Port.port2.name,
        ConnectionInfoKey.conId.name: state.port2conId,
      },
      {
        ConnectionInfoKey.name.name: Port.port3.name,
        ConnectionInfoKey.conId.name: state.port3conId,
      },
      {
        ConnectionInfoKey.name.name: Port.port4.name,
        ConnectionInfoKey.conId.name: state.port4conId,
      },
      {
        ConnectionInfoKey.name.name: Port.port5.name,
        ConnectionInfoKey.conId.name: state.port5conId,
      },
    ];
  }

  void updateConIdByPortName(String portName, String conId) {
    final port = Port.values.firstWhere((p) => p.name == portName);

    switch (port) {
      case Port.port0:
        state = state.copyWith(port0conId: conId);
      case Port.port1:
        state = state.copyWith(port1conId: conId);
      case Port.port2:
        state = state.copyWith(port2conId: conId);
      case Port.port3:
        state = state.copyWith(port3conId: conId);
      case Port.port4:
        state = state.copyWith(port4conId: conId);
      case Port.port5:
        state = state.copyWith(port5conId: conId);
    }
  }

  void removeConIdByConId(String conId) {
    if (state.port0conId == conId) {
      state = state.copyWith(port0conId: '');
    } else if (state.port1conId == conId) {
      state = state.copyWith(port1conId: '');
    } else if (state.port2conId == conId) {
      state = state.copyWith(port2conId: '');
    } else if (state.port3conId == conId) {
      state = state.copyWith(port3conId: '');
    } else if (state.port4conId == conId) {
      state = state.copyWith(port4conId: '');
    } else if (state.port5conId == conId) {
      state = state.copyWith(port5conId: '');
    }
  }

  @override
  void removeSelf() {
    if (state.port0conId.isNotEmpty) {
      connectionNotifier(state.port0conId).removeSelf();
    }
    if (state.port1conId.isNotEmpty) {
      connectionNotifier(state.port1conId).removeSelf();
    }
    if (state.port2conId.isNotEmpty) {
      connectionNotifier(state.port2conId).removeSelf();
    }
    if (state.port3conId.isNotEmpty) {
      connectionNotifier(state.port3conId).removeSelf();
    }
    if (state.port4conId.isNotEmpty) {
      connectionNotifier(state.port4conId).removeSelf();
    }
    if (state.port5conId.isNotEmpty) {
      connectionNotifier(state.port5conId).removeSelf();
    }

    switchMapNotifier.removeAllState(state.id);
  }
}

final switchMapProvider =
    NotifierProvider<SwitchMapNotifier, Map<String, Switch>>(
      SwitchMapNotifier.new,
    );

class SwitchMapNotifier extends DeviceMapNotifier<Switch> {
  @override
  List<Map<String, dynamic>> exportToList() {
    return state.keys.map((id) {
      return ref.read(switchProvider(id)).toMap();
    }).toList();
  }

  @override
  void invalidateSpecificId(String objectId) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(switchProvider(objectId));
    });
  }

  @override
  void removeAllState(String objectId) {
    ref.read(switchWidgetProvider.notifier).removeSimObjectWidget(objectId);
    removeSimObject(objectId);
    invalidateSpecificId(objectId);
  }
}

final switchWidgetProvider =
    NotifierProvider<SwitchWidgetNotifier, Map<String, SwitchWidget>>(
      SwitchWidgetNotifier.new,
    );

class SwitchWidgetNotifier extends DeviceWidgetNotifier<SwitchWidget> {}
