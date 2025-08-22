part of 'sim_object_notifier.dart';

final routerProvider =
    StateNotifierProvider.family<RouterNotifier, Router, String>(
      (ref, id) => RouterNotifier(ref, id),
    );

class RouterNotifier extends DeviceNotifier<Router> {
  RouterNotifier(Ref ref, String id)
    : super(ref.read(routerMapProvider)[id]!, ref);

  @override
  void receiveMessage(String messageId, String fromConId) {
    // TODO: implement receiveMessage
  }

  @override
  List<Map<String, String>> getAllConnectionInfo() {
    // TODO: implement getAllConnectionInfo
    throw UnimplementedError();
  }

  @override
  void removeSelf() {
    // TODO: implement removeSelf
  }
}

final routerMapProvider =
    StateNotifierProvider<RouterMapNotifier, Map<String, Router>>(
      (ref) => RouterMapNotifier(ref),
    );

class RouterMapNotifier extends DeviceMapNotifier<Router> {
  RouterMapNotifier(super.ref);

  @override
  List<Map<String, dynamic>> exportToList() {
    return state.keys.map((id) {
      return ref.read(routerProvider(id)).toMap();
    }).toList();
  }

  @override
  void invalidateSpecificId(String objectId) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(routerProvider(objectId));
    });
  }

  @override
  void removeAllState(String objectId) {
    ref.read(routerWidgetProvider.notifier).removeSimObjectWidget(objectId);
    removeSimObject(objectId);
    invalidateSpecificId(objectId);
  }
}

final routerWidgetProvider =
    StateNotifierProvider<RouterWidgetNotifier, Map<String, RouterWidget>>(
      (ref) => RouterWidgetNotifier(),
    );

class RouterWidgetNotifier extends DeviceWidgetNotifier<RouterWidget> {}
