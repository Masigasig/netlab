part of 'sim_object_notifier.dart';

enum DataLinkLayerType { arp, ipv4 }

enum OperationType { request, reply }

enum MessageKey { targetIp, senderIp, operation, destination, source, type }

enum MsgDropReason { success, fail }

final messageProvider = StateNotifierProvider.family
    .autoDispose<MessageNotifier, Message, String>(
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

  void dropMessage() {
    messageMapNotifier.removeSimObject(state.id);
  }

  String getTargetIp() => hostNotifier(state.dstId).state.ipAddress;
}

final messageMapProvider =
    StateNotifierProvider<MessageMapNotifier, Map<String, Message>>(
      (ref) => MessageMapNotifier(),
    );

class MessageMapNotifier extends SimObjectMapNotifier<Message> {}
