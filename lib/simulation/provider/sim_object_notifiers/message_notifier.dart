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
      ref.read(hostProvider(state.srcId).notifier).removeMessage(state.id);
    }

    ref.read(messageMapProvider.notifier).removeAllState(state.id);
  }

  void updateCurrentPlaceId(String newPlace) {
    state = state.copyWith(currentPlaceId: newPlace);
  }
}

class MessageMapNotifier extends SimObjectMapNotifier<Message> {
  @override
  void invalidateSpecificId(String objectId) {
    if (ref.read(simScreenProvider).selectedDeviceOnInfo == objectId) {
      ref.read(simScreenProvider.notifier).setSelectedDeviceOnInfo('');
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(messageProvider(objectId));
    });
  }

  @override
  void removeAllState(String objectId) {
    ref.read(messageWidgetsProvider.notifier).removeSimObjectWidget(objectId);

    invalidateSpecificId(objectId);
    removeSimObject(objectId);
  }
}

class MessageWidgetsNotifier extends SimObjectWidgetsNotifier<MessageWidget> {}
