part of 'sim_screen_state.dart';

final switchProvider =
    StateNotifierProvider<SwitchNotifier, Map<String, Switch>>(
      (ref) => SwitchNotifier(ref),
    );
final switchWidgetProvider =
    StateNotifierProvider<SwitchWidgetNotifier, Map<String, SwitchWidget>>(
      (ref) => SwitchWidgetNotifier(),
    );

class SwitchNotifier extends DeviceNotifier<Switch> {
  SwitchNotifier(super.ref);
}

class SwitchWidgetNotifier extends DeviceWidgetNotifier<SwitchWidget> {}
