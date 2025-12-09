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
    // TODO: implement receiveMessage
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

  void startMessageProcessing() {
    //*TODO: message Processing
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
