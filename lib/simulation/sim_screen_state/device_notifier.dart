part of 'sim_screen_state.dart';

abstract class DeviceNotifier<T extends Device> extends SimObjectNotifier<T> {
  DeviceNotifier(super.ref);

  MessageNotifier get messageNotifier => ref.read(messageProvider.notifier);

  void sendToConnection(String connectionId, String messageId) {
    ref
        .read(connectionProvider.notifier)
        .receiveMessage(connectionId, messageId);
  }

  void updatePosition(String deviceId, double newX, double newY) {
    final device = state[deviceId]!;
    final updatedDevice = device.copyWith(posX: newX, posY: newY) as T;
    state = {...state, deviceId: updatedDevice};
  }
}

abstract class DeviceWidgetNotifier<T extends DeviceWidget>
    extends SimObjectWidgetNotifier<T> {}
