part of 'sim_screen_state.dart';

final switchProvider =
    StateNotifierProvider<SwitchNotifier, Map<String, Switch>>(
      (ref) => SwitchNotifier(),
    );
final switchWidgetProvider =
    StateNotifierProvider<SwitchWidgetNotifier, Map<String, SwitchWidget>>(
      (ref) => SwitchWidgetNotifier(),
    );

class SwitchNotifier extends DeviceNotifier<Switch> {}

class SwitchWidgetNotifier extends DeviceWidgetNotifier<SwitchWidget> {}
