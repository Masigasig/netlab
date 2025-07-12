part of 'sim_screen_state.dart';

final deviceProvider =
    StateNotifierProvider<DeviceNotifier, Map<String, Device>>(
      (ref) => DeviceNotifier(),
    );

class DeviceNotifier extends StateNotifier<Map<String, Device>> {
  DeviceNotifier() : super({});

  void addDevice(Device device) {
    state = {...state, device.id: device};
  }

  void updatePosition(String deviceId, double newX, double newY) {
    final device = state[deviceId]!;
    final updatedDevice = device.copyWith(posX: newX, posY: newY);
    state = {...state, deviceId: updatedDevice};
  }
}
