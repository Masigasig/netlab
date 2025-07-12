part of 'sim_screen_state.dart';

final deviceWidgetProvider =
    StateNotifierProvider<DeviceWidgetNotifier, Map<String, DeviceWidget>>(
      (ref) => DeviceWidgetNotifier(),
    );

class DeviceWidgetNotifier extends StateNotifier<Map<String, DeviceWidget>> {
  DeviceWidgetNotifier() : super({});

  void addDevice(String key, DeviceWidget device) {
    state = {...state, key: device};
  }
}
