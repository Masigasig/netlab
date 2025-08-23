part of 'sim_object_notifier.dart';

enum ConnectionInfoKey { name, conId }

enum Eth { eth0, eth1, eth2, eth3 }

enum Port { port0, port1, port2, port3, port4, port5 }

abstract class DeviceNotifier<T extends Device> extends SimObjectNotifier<T> {
  DeviceNotifier(super.state, super.ref);

  void sendMessageToConnection(
    String connectionId,
    String messageId,
    String fromId,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      connectionNotifier(connectionId).receiveMessage(messageId, fromId);
    });
  }

  void receiveMessage(String messageId, String fromConId);

  List<Map<String, String>> getAllConnectionInfo();

  void updatePosition(double newX, double newY) {
    state = state.copyWith(posX: newX, posY: newY) as T;
  }
}

abstract class DeviceMapNotifier<T extends Device>
    extends SimObjectMapNotifier<T> {
  DeviceMapNotifier(super.ref);
}

abstract class DeviceWidgetNotifier<T extends DeviceWidget>
    extends SimObjectWidgetNotifier<T> {}
