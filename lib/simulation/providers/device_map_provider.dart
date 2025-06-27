import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/simulation/model/device.dart';

class DeviceMapNotifier extends StateNotifier<Map<String, Device>> {
  DeviceMapNotifier() : super({});

  final Map<String, int> _typeCounters = {};

  void syncCountersFromLoadedDevices() {
    _typeCounters.clear();
    for (final device in state.values) {
      final type = device.type.trim().toLowerCase();
      _typeCounters[type] = (_typeCounters[type] ?? 0) + 1;
    }
  }

  int getNextCounter(String type) {
    _typeCounters[type] = (_typeCounters[type] ?? 0) + 1;
    return _typeCounters[type]!;
  }

  void addDevice(Device device) {
    state = {...state, device.id: device};
  }

  void updatePosition(String deviceId, double x, double y) {
    if (state.containsKey(deviceId)) {
      final device = state[deviceId]!;
      final updatedDevice = device.copyWith(posX: x, posY: y);
      state = {...state, deviceId: updatedDevice};
    }
  }

  void removeDevice(String id) {
    final newState = Map<String, Device>.from(state);
    newState.remove(id);
    state = newState;
  }

  void setDevices(Map<String, Device> devices) {
    state = devices;
    syncCountersFromLoadedDevices();
  }

  Device createAndAddDevice({
    required String type,
    required double posX,
    required double posY,
  }) {
    final uniqueKey = DateTime.now().millisecondsSinceEpoch;
    final counter = getNextCounter(type);
    final device = Device(
      id: 'device_$uniqueKey',
      name: '${type}_$counter',
      type: type,
      posX: posX,
      posY: posY,
    );
    addDevice(device);
    return device;
  }
}

final deviceMapProvider =
    StateNotifierProvider<DeviceMapNotifier, Map<String, Device>>((ref) {
      return DeviceMapNotifier();
    });
