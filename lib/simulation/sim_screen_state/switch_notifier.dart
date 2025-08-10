part of 'sim_object_notifier.dart';

final switchMapProvider =
    StateNotifierProvider<SwitchMapNotifier, Map<String, Switch>>(
      (ref) => SwitchMapNotifier(),
    );

final switchProvider = StateNotifierProvider.family
    .autoDispose<SwitchNotifier, Switch, String>(
      (ref, id) => SwitchNotifier(ref, id),
    );

class SwitchMapNotifier extends DeviceMapNotifier<Switch> {}

class SwitchNotifier extends DeviceNotifier<Switch> {
  SwitchNotifier(Ref ref, String id)
    : super(ref.read(switchMapProvider)[id]!, ref);
}

final switchWidgetProvider =
    StateNotifierProvider<SwitchWidgetNotifier, Map<String, SwitchWidget>>(
      (ref) => SwitchWidgetNotifier(),
    );

class SwitchWidgetNotifier extends DeviceWidgetNotifier<SwitchWidget> {}
