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

  AccessPointNotifier(this.arg);

  @override
  AccessPoint build() {
    ref.onDispose(() {
      _isProcessingMessages = false;
      _messageProcessingTimer?.cancel();
      _messageProcessingTimer = null;
    });
    return ref.read(accessPointMapProvider)[arg]!;
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
    // TODO: implement receiveMessage
  }

  @override
  void removeSelf() {
    // TODO: remove the connections

    ref.read(accessPointMapProvider.notifier).removeAllState(state.id);
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
