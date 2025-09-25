part of 'sim_object_notifier.dart';

abstract class DeviceNotifier<T extends Device> extends SimObjectNotifier<T> {}

abstract class DeviceMapNotifier<T extends Device>
    extends SimObjectMapNotifier<T> {}

abstract class DeviceWidgetsNotifier<T extends DeviceWidget>
    extends SimObjectWidgetsNotifier<T> {}
