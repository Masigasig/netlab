part of 'sim_object_notifier.dart';

enum DataLinkLayerType { arp, ipv4 }

enum OperationType { request, reply }

enum MessageKey { targetIp, senderIp, operation, destination, source, type }

enum MsgDropReason {
  ipv4Success,
  ipv4Fail,
  notIntendedRecipientOfFrame,
  arpReqSuccess,
  arpReqNotMeant,
  arpReplySuccess,
  arpReqTimeout,
  noRouteForPacket,
}

final messageProvider =
    NotifierProvider.family<MessageNotifier, Message, String>(
      MessageNotifier.new,
    );

class MessageNotifier extends SimObjectNotifier<Message> {
  final String arg;
  MessageNotifier(this.arg);

  @override
  Message build() {
    return ref.read(messageMapProvider)[arg]!;
  }

  void updateCurrentPlaceId(String newPlace) {
    state = state.copyWith(currentPlaceId: newPlace);
  }

  void pushLayer(Map<String, String> newLayer) {
    final newStack = List<Map<String, String>>.from(state.layerStack)
      ..add(newLayer);

    state = state.copyWith(layerStack: newStack);
  }

  Map<String, String> popLayer() {
    final lastLayer = state.layerStack.last;

    final newStack = List<Map<String, String>>.from(state.layerStack)
      ..removeLast();

    state = state.copyWith(layerStack: newStack);

    return lastLayer;
  }

  void dropMessage(MsgDropReason reason) {
    simLogsNotifier.addLog(
      'Dropping message ${state.name} due to ${reason.name}',
    );
    ref.read(messageMapProvider.notifier).invalidateSpecificId(state.id);
  }

  @override
  void removeSelf() {
    ref.read(hostProvider(state.srcId).notifier).removeMessage(state.id);

    messageMapNotifier.removeAllState(state.id);
  }

  String getTargetIp() => hostNotifier(state.dstId).state.ipAddress;

  void updatePosition(double newX, double newY, {Duration? duration}) {
    state = state.copyWith(posX: newX, posY: newY, duration: duration);
  }
}

final messageMapProvider =
    NotifierProvider<MessageMapNotifier, Map<String, Message>>(
      MessageMapNotifier.new,
    );

class MessageMapNotifier extends SimObjectMapNotifier<Message> {
  @override
  List<Map<String, dynamic>> exportToList() {
    return state.keys.map((id) {
      return ref.read(messageProvider(id)).toMap();
    }).toList();
  }

  @override
  void invalidateSpecificId(String objectId) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(messageProvider(objectId));
    });
  }

  @override
  void removeAllState(String objectId) {
    ref.read(messageWidgetProvider.notifier).removeSimObjectWidget(objectId);
    removeSimObject(objectId);
    invalidateSpecificId(objectId);
  }
}

final messageWidgetProvider =
    NotifierProvider<MessageWidgetNotifier, Map<String, MessageWidget>>(
      MessageWidgetNotifier.new,
    );

class MessageWidgetNotifier extends SimObjectWidgetNotifier<MessageWidget> {}
