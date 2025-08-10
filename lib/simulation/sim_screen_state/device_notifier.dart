part of 'sim_screen_state.dart';

abstract class DeviceMapNotifier<T extends Device>
    extends SimObjectMapNotifier<T> {}

abstract class DeviceNotifier<T extends Device> extends SimObjectNotifier<T> {
  DeviceNotifier(super.state, super.ref);

  // MessageNotifier get messageNotifier => ref.read(messageProvider.notifier);

  // void sendToConnection(String connectionId, String messageId) {
  //   ref
  //       .read(connectionProvider.notifier)
  //       .receiveMessage(connectionId, messageId);
  // }

  void updatePosition(double newX, double newY) {
    state = state.copyWith(posX: newX, posY: newY) as T;
  }
}

abstract class DeviceWidgetNotifier<T extends DeviceWidget>
    extends SimObjectWidgetNotifier<T> {}
