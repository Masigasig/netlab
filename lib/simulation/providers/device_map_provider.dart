import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/simulation/model/device.dart';

class DeviceMapNotifier extends StateNotifier<Map<String, Device>> {
  DeviceMapNotifier() : super({});

  final Map<String, int> _typeCounters = {};

  void syncCountersFromLoadedDevices() {
    _typeCounters.clear();
    for (final device in state.values) {
      final type = device.type;
      final name = device.name;
      final match = RegExp(r'${type.toLowerCase()}_(\d+)').firstMatch(name);
      if (match != null) {
        final num = int.parse(match.group(1)!);
        if ((_typeCounters[type] ?? 0) < num) {
          _typeCounters[type] = num;
        }
      }
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

  void updateDevice(Device device) {
    state = {...state, device.id: device};
  }

  void removeDevice(String id) {
    final newState = Map<String, Device>.from(state);
    newState.remove(id);
    state = newState;
  }
}

final deviceMapProvider =
    StateNotifierProvider<DeviceMapNotifier, Map<String, Device>>((ref) {
      return DeviceMapNotifier();
    });
