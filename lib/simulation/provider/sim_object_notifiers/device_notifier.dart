part of 'sim_object_notifier.dart';

abstract class DeviceNotifier<T extends Device> extends SimObjectNotifier<T> {
  void updatePosition(double newX, double newY) {
    state = state.copyWith(posX: newX, posY: newY) as T;
  }

  List<Map<String, String>> getAllConnectionInfo();

  void removeConnectionById(String connectionId) {
    if (connectionId.isNotEmpty) {
      ref.read(connectionProvider(connectionId).notifier).removeSelf();
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
