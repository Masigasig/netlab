part of 'sim_screen_state.dart';

final messageMapProvider =
    StateNotifierProvider<MessageMapNotifier, Map<String, Message>>(
      (ref) => MessageMapNotifier(),
    );

final messageProvider =
    StateNotifierProvider.family<MessageNotifier, Message, String>(
      (ref, id) => MessageNotifier(ref, id),
    );

class MessageMapNotifier extends SimObjectMapNotifier<Message> {
  // void pushLayer(String messageId, Map<String, dynamic> newLayer) {
  //   final message = state[messageId]!;

  //   final newStack = List<Map<String, dynamic>>.from(message.layerStack)
  //     ..add(newLayer);

  //   final updatedMessage = message.copyWith(layerStack: newStack);

  //   state = {...state, messageId: updatedMessage};
  // }

  // Map<String, dynamic> popLayer(String messageId) {
  //   final message = state[messageId]!;

  //   final layer = message.layerStack.last;

  //   final newStack = List<Map<String, dynamic>>.from(message.layerStack)
  //     ..removeLast();

  //   state = {...state, messageId: message.copyWith(layerStack: newStack)};

  //   return layer;
  // }

  // void updateCurrentPlaceId(String messageId, String newPlace) {
  //   final message = state[messageId]!;

  //   state = {...state, messageId: message.copyWith(currentPlaceId: newPlace)};
  // }

  // void toggleShouldAnimate(String messageId) {
  //   final message = state[messageId]!;

  //   state = {
  //     ...state,
  //     messageId: message.copyWith(shouldAnimate: !message.shouldAnimate),
  //   };
  // }

  // void dropMessage(String messageId) {
  //   final newState = {...state};
  //   newState.remove(messageId);
  //   state = newState;
  // }
}

class MessageNotifier extends SimObjectNotifier<Message> {
  MessageNotifier(Ref ref, String id)
    : super(ref.read(messageMapProvider)[id]!, ref);
}
