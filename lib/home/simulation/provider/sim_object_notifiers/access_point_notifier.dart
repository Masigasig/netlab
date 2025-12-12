part of 'sim_object_notifier.dart';

final accessPointProvider =
    NotifierProvider.family<AccessPointNotifier, AccessPoint, String>(
      AccessPointNotifier.new,
    );

final accessPointMapProvider =
    NotifierProvider<AccessPointMapNotifer, Map<String, AccessPoint>>(
      AccessPointMapNotifer.new,
    );

final accessPointWidgetsProvider =
    NotifierProvider<
      AccessPointWidgetsNotifier,
      Map<String, AccessPointWidget>
    >(AccessPointWidgetsNotifier.new);

class AccessPointNotifier extends DeviceNotifier<AccessPoint> {
  final String arg;
  final Queue<Map<String, String>> _accessPointQ = Queue();

  AccessPointNotifier(this.arg);

  @override
  AccessPoint build() {
    ref.onDispose(() {
      _isProcessingMessages = false;
      _messageProcessingTimer?.cancel();
      _messageProcessingTimer = null;
      _accessPointQ.clear();
    });
    return ref.read(accessPointMapProvider)[arg]!;
  }

  @override
  void removeSelf() {
    final wirelessConIds = state.wirelessConIdToDeviceIdMap.keys.toList();
    removeConnectionById(state.port0conId);
    removeMultipleWirelessCon(wirelessConIds);
    ref.read(accessPointMapProvider.notifier).removeAllState(state.id);
  }

  @override
  List<Map<String, String>> getAllConnectionInfo() {
    return [
      {
        ConnInfoKey.name.name: Port.port0.name,
        ConnInfoKey.conId.name: state.port0conId,
      },
    ];
  }

  @override
  void receiveMessage(String messageId, String fromConId) {
    messageNotifier(messageId).updateCurrentPlaceId(state.id);

    addSystemInfoLog(
      'Access Point "${state.name}" receive message "${messageNotifier(messageId).state.name}"',
    );

    addSystemInfoLog(
      'Message "${messageNotifier(messageId).state.name}" is at access point "${state.name}"',
    );

    addInfoLog(messageId, 'Is at access point "${state.name}"');

    addInfoLog(
      state.id,
      'Receive message "${messageNotifier(messageId).state.name}"',
    );

    final sourceMac = messageNotifier(
      messageId,
    ).state.layerStack.last[MessageKey.source.name]!;

    //* Temporary solution to unImplemented STP (Spanning Tree Protocol)
    if (state.macToConId.containsKey(sourceMac) &&
        state.macToConId[sourceMac] != fromConId) {
      addErrorLog(messageId, 'Dropped duplicated message');
      addErrorLog(
        state.id,
        'Dropped message "${messageNotifier(messageId).state.name}", reason: duplicated message',
      );
      messageNotifier(messageId).dropMessage();

      return;
    }

    _updateMacToConId(sourceMac, fromConId);

    _accessPointQ.add({'messageId': messageId, 'fromConId': fromConId});

    _startMessageProcessing();
  }

  void updatePort0conId(String connectionId) {
    if (connectionId == '') {
      addInfoLog(state.id, 'Connection Removed');
    }
    state = state.copyWith(port0conId: connectionId);
  }

  void updateConIdtoDeviceIdMap(String wirelessConId, String deviceId) {
    final newMap = Map<String, String>.from(state.wirelessConIdToDeviceIdMap);
    newMap[wirelessConId] = deviceId;
    state = state.copyWith(wirelessConIdToDeviceIdMap: newMap);
  }

  void removeConIdtoConIdtoDeviceIdMap(String wirelessConId) {
    final newMap = Map<String, String>.from(state.wirelessConIdToDeviceIdMap);
    newMap.remove(wirelessConId);
    state = state.copyWith(wirelessConIdToDeviceIdMap: newMap);
  }

  void _updateMacToConId(String mac, String conId) {
    final newMacToConId = Map<String, String>.from(state.macToConId);
    newMacToConId[mac] = conId;
    state = state.copyWith(macToConId: newMacToConId);

    String port = '';

    if (conId.startsWith(SimObjectType.connection.label)) {
      port = 'port0';
    } else {
      final deviceId = state.wirelessConIdToDeviceIdMap[conId]!;

      port = ref.read(wirelessHostProvider(deviceId)).name;
    }

    addInfoLog(state.id, 'Update MacTable $port => $mac');
  }

  void _startMessageProcessing() {
    if (_isProcessingMessages) return;
    _isProcessingMessages = true;
    addSystemInfoLog('AccessPoint "${state.name}" started processing message');
    addInfoLog(state.id, 'Started processing message');
    _processNextMessage();
  }

  void _stopMessageProcessing() {
    _isProcessingMessages = false;
    _messageProcessingTimer?.cancel();
    addSystemInfoLog('Access Point "${state.name}" stopped processing message');
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
    if (!_isProcessingMessages || _accessPointQ.isEmpty) {
      _stopMessageProcessing();
      return;
    }

    final currentMessage = _accessPointQ.removeFirst();
    final messageId = currentMessage['messageId']!;
    final fromConId = currentMessage['fromConId']!;

    if (currentMessage.isEmpty) {
      _scheduleNextProcessing();
      return;
    }

    final dstMac = messageNotifier(
      messageId,
    ).state.layerStack.last[MessageKey.destination.name]!;

    final toConId = _getConIdFromMacTable(dstMac);

    if (toConId.isEmpty) {
      final activeConId = state.wirelessConIdToDeviceIdMap.keys.toList();
      if (state.port0conId.isNotEmpty) {
        activeConId.add(state.port0conId);
      }

      activeConId.remove(fromConId);

      final List<String> messagesIds = [messageId];

      for (int i = 0; i < activeConId.length - 1; i++) {
        messagesIds.add(_duplicateMessage(messageId));
      }

      addSystemInfoLog(
        'Access Point "${state.name}" flood the connection for message "${messageNotifier(messageId).state.name}"',
      );

      addInfoLog(
        state.id,
        'Flood the connection for message "${messageNotifier(messageId).state.name}"',
      );

      for (int i = 0; i < activeConId.length; i++) {
        sendMessageToConnection(activeConId[i], messagesIds[i], state.id);
      }
    } else {
      addSystemInfoLog(
        'Access Point "${state.name}" forward  message "${messageNotifier(messageId).state.name}"',
      );

      if (toConId.startsWith(SimObjectType.connection.label)) {
        addInfoLog(
          state.id,
          'Forward message "${messageNotifier(messageId).state.name}" to connection "${connectionNotifier(toConId).state.name}"',
        );
      } else {
        addInfoLog(
          state.id,
          'Forward message "${messageNotifier(messageId).state.name}" to wireless connection "${wirelessConNotifier(toConId).state.name}"',
        );
      }

      sendMessageToConnection(toConId, messageId, state.id);
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

  String _getConIdFromMacTable(String macAddress) {
    return state.macToConId[macAddress] ?? '';
  }
}

class AccessPointMapNotifer extends DeviceMapNotifier<AccessPoint> {
  AccessPointMapNotifer()
    : super(
        mapProvider: accessPointMapProvider,
        objectProvider: accessPointProvider,
        widgetsProvider: accessPointWidgetsProvider,
      );
}

class AccessPointWidgetsNotifier
    extends DeviceWidgetsNotifier<AccessPointWidget> {}
