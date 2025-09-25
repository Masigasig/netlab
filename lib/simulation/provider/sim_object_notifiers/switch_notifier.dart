part of 'sim_object_notifier.dart';

final switchProvider = NotifierProvider.family<SwitchNotifier, Switch, String>(
  SwitchNotifier.new,
);

final switchMapProvider =
    NotifierProvider<SwitchMapNotifier, Map<String, Switch>>(
      SwitchMapNotifier.new,
    );

final switchWidgetsProvider =
    NotifierProvider<SwitchWidgetsNotifier, Map<String, SwitchWidget>>(
      SwitchWidgetsNotifier.new,
    );

class SwitchNotifier extends DeviceNotifier<Switch> {
  final String arg;
  SwitchNotifier(this.arg);

  @override
  Switch build() {
    return ref.read(switchMapProvider)[arg]!;
  }
}

class SwitchMapNotifier extends DeviceMapNotifier<Switch> {}

class SwitchWidgetsNotifier extends DeviceWidgetsNotifier<SwitchWidget> {}
