part of 'sim_object_notifier.dart';

abstract class DeviceNotifier<T extends Device> extends SimObjectNotifier<T> {
  void updatePosition(double newX, double newY) {
    state = state.copyWith(posX: newX, posY: newY) as T;
  }
}

abstract class DeviceMapNotifier<T extends Device>
    extends SimObjectMapNotifier<T> {}

abstract class DeviceWidgetsNotifier<T extends DeviceWidget>
    extends SimObjectWidgetsNotifier<T> {}
