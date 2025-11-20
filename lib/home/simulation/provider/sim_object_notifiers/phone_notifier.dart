part of 'sim_object_notifier.dart';

final phoneProvider = NotifierProvider.family<PhoneNotifier, Phone, String>(
  PhoneNotifier.new,
);

final phonePendingArpReqProvider =
    NotifierProvider.family<
      PhonePendingArpReqNotifier,
      Map<String, Duration>,
      String
    >(PhonePendingArpReqNotifier.new);

final phoneMapProvider = NotifierProvider<PhoneMapNotifier, Map<String, Phone>>(
  PhoneMapNotifier.new,
);

final phoneWidgetsProvider =
    NotifierProvider<PhoneWidgetsNotifier, Map<String, PhoneWidget>>(
      PhoneWidgetsNotifier.new,
    );

class PhoneNotifier extends DeviceNotifier<Phone> {
  final String arg;

  PhoneNotifier(this.arg);

  @override
  Phone build() {
    ref.onDispose(() {
      _isProcessingMessages = false;
      _messageProcessingTimer?.cancel();
      _messageProcessingTimer = null;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.invalidate(phonePendingArpReqProvider(arg));
      });
    });
    return ref.read(phoneMapProvider)[arg]!;
  }

  @override
  List<Map<String, String>> getAllConnectionInfo() {
    // TODO: implement getAllConnectionInfo
    throw UnimplementedError();
  }

  @override
  void receiveMessage(String messageId, String fromConId) {
    // TODO: implement receiveMessage
  }

  @override
  void removeSelf() {
    // TODO: implement removeSelf
  }
}

class PhonePendingArpReqNotifier extends Notifier<Map<String, Duration>> {
  final String arg;
  PhonePendingArpReqNotifier(this.arg);

  @override
  Map<String, Duration> build() {
    return {};
  }
}

class PhoneMapNotifier extends DeviceMapNotifier<Phone> {
  PhoneMapNotifier()
    : super(
        mapProvider: phoneMapProvider,
        objectProvider: phoneProvider,
        widgetsProvider: phoneWidgetsProvider,
      );
}

class PhoneWidgetsNotifier extends DeviceWidgetsNotifier<PhoneWidget> {}
