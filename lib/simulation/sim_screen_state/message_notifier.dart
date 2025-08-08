part of 'sim_screen_state.dart';

final messageProvider =
    StateNotifierProvider<MessageNotifier, Map<String, Message>>(
      (ref) => MessageNotifier(ref),
    );

class MessageNotifier extends SimObjectNotifier<Message> {
  MessageNotifier(super.ref);

  void pushLayer(String messageId, Map<String, String> newLayer) {
    final message = state[messageId]!;

    final newStack = List<Map<String, String>>.from(message.layerStack)
      ..add(newLayer);

    final updatedMessage = message.copyWith(layerStack: newStack);

    state = {...state, messageId: updatedMessage};
  }

  void popLayer(String messageId) {
    final message = state[messageId]!;

    final newStack = List<Map<String, String>>.from(message.layerStack)
      ..removeLast();

    final updatedMessage = message.copyWith(layerStack: newStack);

    state = {...state, messageId: updatedMessage};
  }

  Map<String, String> peekLayerStack(String messageId) =>
      state[messageId]!.layerStack.last;

  void updateCurrentPlaceId(String messageId, String newPlace) {
    final message = state[messageId]!;

    state = {...state, messageId: message.copyWith(currentPlaceId: newPlace)};
  }
}
