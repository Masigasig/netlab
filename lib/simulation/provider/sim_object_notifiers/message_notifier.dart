part of 'sim_object_notifier.dart';

final messageProvider =
    NotifierProvider.family<MessageNotifier, Message, String>(
      MessageNotifier.new,
    );

final messageMapProvider =
    NotifierProvider<MessageMapNotifier, Map<String, Message>>(
      MessageMapNotifier.new,
    );

final messageWidgetsProvider =
    NotifierProvider<MessageWidgetsNotifier, Map<String, MessageWidget>>(
      MessageWidgetsNotifier.new,
    );

class MessageNotifier extends SimObjectNotifier<Message> {
  final String arg;
  MessageNotifier(this.arg);

  @override
  Message build() {
    return ref.read(messageMapProvider)[arg]!;
  }

  @override
  void removeSelf() {
    // TODO: implement removeSelf
  }

  void updateCurrentPlaceId(String newPlace) {
    state = state.copyWith(currentPlaceId: newPlace);
  }
}

class MessageMapNotifier extends SimObjectMapNotifier<Message> {
  @override
  void invalidateSpecificId(String objectId) {
    // TODO: implement invalidateSpecificId
  }

  @override
  void removeAllState(String objectId) {
    // TODO: implement removeAllState
  }
}

class MessageWidgetsNotifier extends SimObjectWidgetsNotifier<MessageWidget> {}
