part of 'sim_object_notifier.dart';

abstract class DeviceMapNotifier<T extends Device>
    extends SimObjectMapNotifier<T> {}

abstract class DeviceNotifier<T extends Device> extends SimObjectNotifier<T> {
  DeviceNotifier(super.state, super.ref);

  void sendMessageToConnection(String connectionId, String messageId) {
    connectionNotifier(connectionId).receiveMessage(messageId);
  }

  void receiveMessage(String messageId);

  void updatePosition(double newX, double newY) {
    state = state.copyWith(posX: newX, posY: newY) as T;
  }
}

abstract class DeviceWidgetNotifier<T extends DeviceWidget>
    extends SimObjectWidgetNotifier<T> {}
