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

  void updateConIdByPortName(String portName, String conId) {
    final port = Port.values.firstWhere((p) => p.name == portName);

    state = switch (port) {
      Port.port0 => state.copyWith(port0conId: conId),
      Port.port1 => state.copyWith(port1conId: conId),
      Port.port2 => state.copyWith(port2conId: conId),
      Port.port3 => state.copyWith(port3conId: conId),
      Port.port4 => state.copyWith(port4conId: conId),
      Port.port5 => state.copyWith(port5conId: conId),
    };
  }
}

class SwitchMapNotifier extends DeviceMapNotifier<Switch> {}

class SwitchWidgetsNotifier extends DeviceWidgetsNotifier<SwitchWidget> {}
