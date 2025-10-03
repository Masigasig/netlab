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
    if (state.srcId.startsWith(SimObjectType.host.label)) {
      hostNotifier(state.srcId).removeMessage(state.id);
    }

    ref.read(messageMapProvider.notifier).removeAllState(state.id);
  }

  void updateCurrentPlaceId(String newPlace) {
    state = state.copyWith(currentPlaceId: newPlace);
  }

  void updatePosition(double newX, double newY, {Duration? duration}) {
    state = state.copyWith(posX: newX, posY: newY, duration: duration);
  }
}

class MessageMapNotifier extends SimObjectMapNotifier<Message> {
  MessageMapNotifier()
    : super(
        mapProvider: messageMapProvider,
        objectProvider: messageProvider,
        widgetsProvider: messageWidgetsProvider,
      );
}

class MessageWidgetsNotifier extends SimObjectWidgetsNotifier<MessageWidget> {}
