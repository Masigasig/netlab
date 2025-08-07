part of 'sim_screen_state.dart';

final hostProvider = StateNotifierProvider<HostNotifier, Map<String, Host>>(
  (ref) => HostNotifier(ref),
);
final hostWidgetProvider =
    StateNotifierProvider<HostWidgetNotifier, Map<String, HostWidget>>(
      (ref) => HostWidgetNotifier(),
    );

class HostNotifier extends DeviceNotifier<Host> {
  HostNotifier(super.ref);
}

class HostWidgetNotifier extends DeviceWidgetNotifier<HostWidget> {}
