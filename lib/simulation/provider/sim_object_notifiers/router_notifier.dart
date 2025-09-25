part of 'sim_object_notifier.dart';

final routerProvider = NotifierProvider.family<RouterNotifier, Router, String>(
  RouterNotifier.new,
);

final routerMapProvider =
    NotifierProvider<RouterMapNotifier, Map<String, Router>>(
      RouterMapNotifier.new,
    );

final routerWidgetsProvider =
    NotifierProvider<RouterWidgetsNotifier, Map<String, RouterWidget>>(
      RouterWidgetsNotifier.new,
    );

class RouterNotifier extends DeviceNotifier<Router> {
  final String arg;
  RouterNotifier(this.arg);

  @override
  Router build() {
    return ref.read(routerMapProvider)[arg]!;
  }
}

class RouterMapNotifier extends DeviceMapNotifier<Router> {}

class RouterWidgetsNotifier extends DeviceWidgetsNotifier<RouterWidget> {}
