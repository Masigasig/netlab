part of 'sim_object_notifier.dart';

enum DataLinkLayerType { arp, ipv4 }

enum OperationType { request, reply }

enum MessageKey { destination, source, type }

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

  void toggleShouldAnimate() {
    state = state.copyWith(shouldAnimate: !state.shouldAnimate);
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
}

final messageMapProvider =
    StateNotifierProvider<MessageMapNotifier, Map<String, Message>>(
      (ref) => MessageMapNotifier(),
    );

class MessageMapNotifier extends SimObjectMapNotifier<Message> {
  // void dropMessage(String messageId) {
  //   final newState = {...state};
  //   newState.remove(messageId);
  //   state = newState;
  // }
}
