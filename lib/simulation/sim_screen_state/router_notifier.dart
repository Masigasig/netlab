part of 'sim_screen_state.dart';

final routerProvider =
    StateNotifierProvider<RouterNotifier, Map<String, Router>>(
      (ref) => RouterNotifier(ref),
    );
final routerWidgetProvider =
    StateNotifierProvider<RouterWidgetNotifier, Map<String, RouterWidget>>(
      (ref) => RouterWidgetNotifier(),
    );

class RouterNotifier extends DeviceNotifier<Router> {
  RouterNotifier(super.ref);
}

class RouterWidgetNotifier extends DeviceWidgetNotifier<RouterWidget> {}
