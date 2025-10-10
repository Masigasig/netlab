part of 'sim_object_notifier.dart';

final switchProvider = NotifierProvider.family<SwitchNotifier, Switch, String>(
  SwitchNotifier.new,
);

final switchMapProvider =
    NotifierProvider<SwitchMapNotifier, Map<String, Switch>>(
      SwitchMapNotifier.new,
    );

final switchWidgetsProvider =
    NotifierProvider<SwitchWidgetsNotifier, Map<String, SwitchWidget>>(
      SwitchWidgetsNotifier.new,
    );

class SwitchNotifier extends DeviceNotifier<Switch> {
  final String arg;
  final Queue<Map<String, String>> _switchQ = Queue();

  SwitchNotifier(this.arg);

  @override
  Switch build() {
    ref.onDispose(() {
      _isProcessingMessages = false;
      _messageProcessingTimer?.cancel();
      _messageProcessingTimer = null;
      _switchQ.clear();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.invalidate(simObjectLogProvider(arg));
      });
    });
    return ref.read(switchMapProvider)[arg]!;
  }

  @override
  void removeSelf() {
    final connectionIds = [
      state.port0conId,
      state.port1conId,
      state.port2conId,
      state.port3conId,
      state.port4conId,
      state.port5conId,
    ];

    removeMultipleConnections(connectionIds);
    ref.read(switchMapProvider.notifier).removeAllState(state.id);
  }

  @override
  List<Map<String, String>> getAllConnectionInfo() {
    return [
      {
        ConnInfoKey.name.name: Port.port0.name,
        ConnInfoKey.conId.name: state.port0conId,
      },
      {
        ConnInfoKey.name.name: Port.port1.name,
        ConnInfoKey.conId.name: state.port1conId,
      },
      {
        ConnInfoKey.name.name: Port.port2.name,
        ConnInfoKey.conId.name: state.port2conId,
      },
      {
        ConnInfoKey.name.name: Port.port3.name,
        ConnInfoKey.conId.name: state.port3conId,
      },
      {
        ConnInfoKey.name.name: Port.port4.name,
        ConnInfoKey.conId.name: state.port4conId,
      },
      {
        ConnInfoKey.name.name: Port.port5.name,
        ConnInfoKey.conId.name: state.port5conId,
      },
    ];
  }

  @override
  void receiveMessage(String messageId, String fromConId) {
    messageNotifier(messageId).updateCurrentPlaceId(state.id);

    addSystemInfoLog(
      'Switch "${state.name}" receive message "${messageNotifier(messageId).state.name}"',
    );

    addSystemInfoLog(
      'Message "${messageNotifier(messageId).state.name}" is at switch "${state.name}"',
    );

    addInfoLog(messageId, 'Is at switch "${state.name}"');

    addInfoLog(
      state.id,
      'Receive message "${messageNotifier(messageId).state.name}"',
    );

    final sourceMac = messageNotifier(
      messageId,
    ).state.layerStack.last[MessageKey.source.name]!;

    final port = state.conIdToPortMap[fromConId]!;

    _updateMacTable(sourceMac, port);

    _switchQ.add({'messageId': messageId, 'fromConId': fromConId});

    _startMessageProcessing();
  }

  void updateConIdByPortName(String portName, String conId) {
    final port = Port.values.firstWhere((p) => p.name == portName);

    state = switch (port) {
      Port.port0 => state.copyWith(port0conId: conId),
      Port.port1 => state.copyWith(port1conId: conId),
      Port.port2 => state.copyWith(port2conId: conId),
      Port.port3 => state.copyWith(port3conId: conId),
      Port.port4 => state.copyWith(port4conId: conId),
      Port.port5 => state.copyWith(port5conId: conId),
    };

    addInfoLog(
      state.id,
      'Connected to ${connectionNotifier(conId).state.name}',
    );
  }

  void removeConIdByConId(String conId) {
    addInfoLog(
      state.id,
      'Connection "${connectionNotifier(conId).state.name}" removed',
    );

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

  void _updateMacTable(String mac, String port) {
    final newMacTable = Map<String, String>.from(state.macTable);
    newMacTable[mac] = port;
    state = state.copyWith(macTable: newMacTable);
    addInfoLog(state.id, 'Update MacTable $port => $mac');
  }

  void _startMessageProcessing() {
    if (_isProcessingMessages) return;
    _isProcessingMessages = true;
    addSystemInfoLog('Switch "${state.name}" started processing message');
    addInfoLog(state.id, 'Started processing message');
    _processNextMessage();
  }

  void _stopMessageProcessing() {
    _isProcessingMessages = false;
    _messageProcessingTimer?.cancel();
    addSystemInfoLog('Switch "${state.name} stopped processing message');
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

  void _processNextMessage() {
    if (!_isProcessingMessages || _switchQ.isEmpty) {
      _stopMessageProcessing();
      return;
    }

    final currentMessage = _switchQ.removeFirst();
    final messageId = currentMessage['messageId']!;
    final fromConId = currentMessage['fromConId']!;

    if (currentMessage.isEmpty) {
      _scheduleNextProcessing();
      return;
    }

    final dstMac = messageNotifier(
      messageId,
    ).state.layerStack.last[MessageKey.destination.name]!;

    final port = _getPortFromMacTable(dstMac);

    if (port.isEmpty) {
      final activePorts = state.activeConnectionIds;
      activePorts.remove(fromConId);

      final List<String> messagesIds = [messageId];

      for (int i = 0; i < activePorts.length - 1; i++) {
        messagesIds.add(_duplicateMessage(messageId));
      }

      addSystemInfoLog(
        'Switch "${state.name}" flood the port for message "${messageNotifier(messageId).state.name}"',
      );

      addInfoLog(
        state.id,
        'Flood the port for message "${messageNotifier(messageId).state.name}"',
      );

      for (int i = 0; i < activePorts.length; i++) {
        sendMessageToConnection(activePorts[i], messagesIds[i], state.id);
      }
    } else {
      final connectionId = state.portToConIdMap[port]!;

      addSystemInfoLog(
        'Switch "${state.name}" forward  message "${messageNotifier(messageId).state.name}"',
      );

      addInfoLog(
        state.id,
        'Forward message "${messageNotifier(messageId).state.name}" to connection "${connectionNotifier(connectionId)}"',
      );

      sendMessageToConnection(connectionId, messageId, state.id);
    }

    _scheduleNextProcessing();
  }

  String _duplicateMessage(String messageId) {
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
        SimObjectType.message.createSimObjectWidget(newMessage.id)
            as MessageWidget;

    ref.read(messageMapProvider.notifier).addSimObject(newMessage);
    ref.read(messageWidgetsProvider.notifier).addSimObjectWidget(widget);

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

  String _getPortFromMacTable(String macAddress) =>
      state.macTable[macAddress] ?? '';
}

class SwitchMapNotifier extends DeviceMapNotifier<Switch> {
  SwitchMapNotifier()
    : super(
        mapProvider: switchMapProvider,
        objectProvider: switchProvider,
        widgetsProvider: switchWidgetsProvider,
      );
}

class SwitchWidgetsNotifier extends DeviceWidgetsNotifier<SwitchWidget> {}
