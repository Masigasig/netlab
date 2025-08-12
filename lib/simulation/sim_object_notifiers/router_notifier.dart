part of 'sim_object_notifier.dart';

final routerMapProvider =
    StateNotifierProvider<RouterMapNotifier, Map<String, Router>>(
      (ref) => RouterMapNotifier(),
    );

final routerProvider = StateNotifierProvider.family
    .autoDispose<RouterNotifier, Router, String>(
      (ref, id) => RouterNotifier(ref, id),
    );

class RouterMapNotifier extends DeviceMapNotifier<Router> {}

class RouterNotifier extends DeviceNotifier<Router> {
  RouterNotifier(Ref ref, String id)
    : super(ref.read(routerMapProvider)[id]!, ref);

  @override
  void receiveMessage(String messageId) {
    // TODO: implement receiveMessage
  }
}

final routerWidgetProvider =
    StateNotifierProvider<RouterWidgetNotifier, Map<String, RouterWidget>>(
      (ref) => RouterWidgetNotifier(),
    );

class RouterWidgetNotifier extends DeviceWidgetNotifier<RouterWidget> {}
