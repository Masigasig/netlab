import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netlab/simulation/model/device_widget.dart';

class DeviceStackNotifier extends StateNotifier<Map<String, DeviceWidget>> {
  DeviceStackNotifier() : super({});

  void addDevice(String key, DeviceWidget device) {
    state = {...state, key: device};
  }

  void clear() {
    state = {};
  }

  void removeItem(String key) {
    final updated = Map<String, DeviceWidget>.from(state)..remove(key);
    state = updated;
  }
}

final deviceStackProvider =
    StateNotifierProvider<DeviceStackNotifier, Map<String, DeviceWidget>>(
      (ref) => DeviceStackNotifier(),
    );
