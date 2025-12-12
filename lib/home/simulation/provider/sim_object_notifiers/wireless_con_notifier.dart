part of 'sim_object_notifier.dart';

final wirelessConProvider =
    NotifierProvider.family<WirelessConNotifier, WirelessCon, String>(
      WirelessConNotifier.new,
    );

final wirelessConDeviceToIdMapProvider =
    NotifierProvider.family<
      WirelessConDeviceToIdMapNotifier,
      Map<String, String>,
      String
    >(WirelessConDeviceToIdMapNotifier.new);

final wirelessConMapProvider =
    NotifierProvider<WirelessConMapNotifier, Map<String, WirelessCon>>(
      WirelessConMapNotifier.new,
    );

final wirelessConWidgetsProvider =
    NotifierProvider<
      WirelessConWidgetsNotifier,
      Map<String, WirelessConWidget>
    >(WirelessConWidgetsNotifier.new);

class WirelessConNotifier extends SimObjectNotifier<WirelessCon> {
  final String arg;

  WirelessConNotifier(this.arg);

  @override
  WirelessCon build() {
    ref.onDispose(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.invalidate(wirelessConDeviceToIdMapProvider(arg));
      });
    });
    return ref.read(wirelessConMapProvider)[arg]!;
  }

  @override
  void removeSelf() {
    if (state.conAId.startsWith(SimObjectType.accessPoint.label)) {
      accessPointNotifier(
        state.conAId,
      ).removeConIdtoConIdtoDeviceIdMap(state.id);
    } else if (state.conAId.startsWith(SimObjectType.wirelessHost.label)) {
      wirelessHostNotifier(state.conAId).updateWirelessConId('');
    }

    if (state.conBId.startsWith(SimObjectType.accessPoint.label)) {
      accessPointNotifier(
        state.conBId,
      ).removeConIdtoConIdtoDeviceIdMap(state.id);
    } else if (state.conBId.startsWith(SimObjectType.wirelessHost.label)) {
      wirelessHostNotifier(state.conBId).updateWirelessConId('');
    }

    ref.read(wirelessConMapProvider.notifier).removeAllState(state.id);
  }

  void receiveMessage(String messageId, String fromId) {
    messageNotifier(messageId).updateCurrentPlaceId(state.id);
    messageNotifier(messageId).pushLayer({});

    addInfoLog(
      state.id,
      'Receive message "${ref.read(messageProvider(messageId)).name}" from "${_getDeviceById(fromId).name}"',
    );

    addInfoLog(
      messageId,
      'Is at wireless connection "${state.name}", coming from device "${_getDeviceById(fromId).name}"',
    );

    final targetId = fromId == state.conAId ? state.conBId : state.conAId;

    ref
        .read(wirelessConDeviceToIdMapProvider(state.id).notifier)
        .addDeviceToId(messageId, targetId);

    final deviceFrom = _getDeviceById(fromId);
    final deviceTo = _getDeviceById(targetId);

    final distance =
        (Offset(deviceTo.posX, deviceTo.posY) -
                Offset(deviceFrom.posX, deviceFrom.posY))
            .distance;

    final currentSpeed =
        ref.watch(simScreenProvider.select((s) => s.messageSpeed)) * 100;
    final duration = Duration(
      milliseconds: ((distance / currentSpeed) * 1000).toInt(),
    );

    Future.delayed(duration, () {
      if (ref
          .read(wirelessConDeviceToIdMapProvider(state.id))
          .containsKey(messageId)) {
        sendMessage(messageId);
      }
    });

    messageNotifier(
      messageId,
    ).updatePosition(deviceTo.posX, deviceTo.posY, duration: duration);
  }

  void sendMessage(String messageId) {
    messageNotifier(messageId).popLayer();

    final deviceToId = ref.read(
      wirelessConDeviceToIdMapProvider(state.id),
    )[messageId]!;

    final deviceNotifier = _getDeviceNotifierById(deviceToId);

    ref
        .read(wirelessConDeviceToIdMapProvider(state.id).notifier)
        .removeDeviceToId(messageId);

    addInfoLog(
      state.id,
      'Message "${ref.read(messageProvider(messageId)).name}" sent to device "${_getDeviceById(deviceToId).name}"',
    );

    deviceNotifier.receiveMessage(messageId, state.id);
  }

  String getConnectedDeviceId(String simObjectId) {
    if (simObjectId == state.conAId) {
      return state.conBId;
    } else {
      return state.conAId;
    }
  }

  Device _getDeviceById(String simObjectId) {
    //* only 2 possible wireless connection
    if (simObjectId.startsWith(SimObjectType.accessPoint.label)) {
      return ref.read(accessPointProvider(simObjectId));
    } else {
      return ref.read(wirelessHostProvider(simObjectId));
    }
  }

  DeviceNotifier _getDeviceNotifierById(String simObjectId) {
    //* only 2 possible wireless connection
    if (simObjectId.startsWith(SimObjectType.accessPoint.label)) {
      return accessPointNotifier(simObjectId);
    } else {
      return wirelessHostNotifier(simObjectId);
    }
  }
}

class WirelessConDeviceToIdMapNotifier extends Notifier<Map<String, String>> {
  final String arg;
  WirelessConDeviceToIdMapNotifier(this.arg);

  @override
  Map<String, String> build() {
    return {};
  }

  void addDeviceToId(String messageId, String deviceId) {
    state = {...state, messageId: deviceId};
  }

  void removeDeviceToId(String messageId) {
    state = {...state}..remove(messageId);
  }
}

class WirelessConMapNotifier extends SimObjectMapNotifier<WirelessCon> {
  WirelessConMapNotifier()
    : super(
        mapProvider: wirelessConMapProvider,
        objectProvider: wirelessConProvider,
        widgetsProvider: wirelessConWidgetsProvider,
      );
}

class WirelessConWidgetsNotifier
    extends SimObjectWidgetsNotifier<WirelessConWidget> {}
