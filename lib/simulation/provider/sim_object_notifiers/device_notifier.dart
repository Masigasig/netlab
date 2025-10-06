part of 'sim_object_notifier.dart';

abstract class DeviceNotifier<T extends Device> extends SimObjectNotifier<T> {
  static const processingInterval = Duration(milliseconds: 500);
  bool _isProcessingMessages = false;
  Timer? _messageProcessingTimer;

  void receiveMessage(String messageId, String fromConId);

  List<Map<String, String>> getAllConnectionInfo();

  void updatePosition(double newX, double newY) {
    state = state.copyWith(posX: newX, posY: newY) as T;
  }

  void sendMessageToConnection(
    String connectionId,
    String messageId,
    String fromId,
  ) {
    if (connectionId.isEmpty) {
      addSystemErrorLog(
        'Message "${messageNotifier(messageId).state.name}" dropped, reason: Device "${state.name}" has no connection for the message',
      );

      addErrorLog(
        messageId,
        'Dropped, reason: Device "${state.name}" has no connection',
      );

      addErrorLog(
        state.id,
        'Message "${messageNotifier(messageId).state.name}" dropped, reason: has no connection for the message',
      );

      messageNotifier(messageId).dropMessage();

      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      connectionNotifier(connectionId).receiveMessage(messageId, fromId);
    });
  }

  void removeIpFromManager(String ipAddress) =>
      Ipv4AddressManager.removeIp(ipAddress);

  void removeMacFromManager(String macAddress) =>
      MacAddressManager.removeMac(macAddress);

  void removeConnectionById(String connectionId) {
    if (connectionId.isNotEmpty) {
      connectionNotifier(connectionId).removeSelf();
    }
  }

  void removeMultipleIps(List<String> ipAddresses) {
    for (final ip in ipAddresses) {
      removeIpFromManager(ip);
    }
  }

  void removeMulitpleMacs(List<String> macAddresses) {
    for (final mac in macAddresses) {
      removeMacFromManager(mac);
    }
  }

  void removeMultipleConnections(List<String> connectionIds) {
    for (final id in connectionIds) {
      removeConnectionById(id);
    }
  }
}

abstract class DeviceMapNotifier<T extends Device>
    extends SimObjectMapNotifier<T> {
  DeviceMapNotifier({
    required super.mapProvider,
    required super.objectProvider,
    required super.widgetsProvider,
  });
}

abstract class DeviceWidgetsNotifier<T extends DeviceWidget>
    extends SimObjectWidgetsNotifier<T> {}
