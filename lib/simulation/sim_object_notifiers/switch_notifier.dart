part of 'sim_object_notifier.dart';

final switchProvider =
    StateNotifierProvider.family<SwitchNotifier, Switch, String>(
      (ref, id) => SwitchNotifier(ref, id),
    );

class SwitchNotifier extends DeviceNotifier<Switch> {
  SwitchNotifier(Ref ref, String id)
    : super(ref.read(switchMapProvider)[id]!, ref);

  @override
  void receiveMessage(String messageId) {
    // TODO: implement receiveMessage
  }
}

final switchMapProvider =
    StateNotifierProvider<SwitchMapNotifier, Map<String, Switch>>(
      (ref) => SwitchMapNotifier(ref),
    );

class SwitchMapNotifier extends DeviceMapNotifier<Switch> {
  SwitchMapNotifier(super.ref);

  @override
  List<Map<String, dynamic>> exportToList() {
    return state.keys.map((id) {
      return ref.read(switchProvider(id)).toMap();
    }).toList();
  }
}

final switchWidgetProvider =
    StateNotifierProvider<SwitchWidgetNotifier, Map<String, SwitchWidget>>(
      (ref) => SwitchWidgetNotifier(),
    );

class SwitchWidgetNotifier extends DeviceWidgetNotifier<SwitchWidget> {}
