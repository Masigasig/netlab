part of 'sim_object_notifier.dart';

enum DataLinkLayerType { arp, ipv4 }

enum OperationType { request, reply }

enum MessageKey { targetIp, senderIp, operation, destination, source, type }

enum MsgDropReason {
  ipv4Success,
  ipv4Fail,
  arpReqSuccess,
  arpReqNotMeant,
  arpReplySuccess,
  arpReqTimeout,
}

final messageProvider =
    StateNotifierProvider.family<MessageNotifier, Message, String>(
      (ref, id) => MessageNotifier(ref, id),
    );

class MessageNotifier extends SimObjectNotifier<Message> {
  MessageNotifier(Ref ref, String id)
    : super(ref.read(messageMapProvider)[id]!, ref);

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
    print('Dropping message ${state.id} due to ${reason.name}');
    messageMapNotifier.removeSimObject(state.id);
  }

  String getTargetIp() => hostNotifier(state.dstId).state.ipAddress;

  void updatePosition(double newX, double newY, {Duration? duration}) {
    state = state.copyWith(posX: newX, posY: newY, duration: duration);
  }
}

final messageMapProvider =
    StateNotifierProvider<MessageMapNotifier, Map<String, Message>>(
      (ref) => MessageMapNotifier(),
    );

class MessageMapNotifier extends SimObjectMapNotifier<Message> {}

final messageWidgetProvider =
    StateNotifierProvider<MessageWidgetNotifier, Map<String, MessageWidget>>(
      (ref) => MessageWidgetNotifier(),
    );

class MessageWidgetNotifier extends SimObjectWidgetNotifier<MessageWidget> {}
