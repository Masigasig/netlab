part of 'sim_screen_state.dart';

abstract class DeviceNotifier<T extends Device> extends SimObjectNotifier<T> {
  void updatePosition(String deviceId, double newX, double newY) {
    final device = state[deviceId]!;
    final updatedDevice = device.copyWith(posX: newX, posY: newY) as T;
    state = {...state, deviceId: updatedDevice};
  }
}

abstract class DeviceWidgetNotifier<T extends DeviceWidget>
    extends SimObjectWidgetNotifier<T> {}
