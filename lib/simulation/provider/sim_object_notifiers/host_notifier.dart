part of 'sim_object_notifier.dart';

final hostProvider = NotifierProvider.family<HostNotifier, Host, String>(
  HostNotifier.new,
);

final hostMapProvider = NotifierProvider<HostMapNotifier, Map<String, Host>>(
  HostMapNotifier.new,
);

final hostWidgetsProvider =
    NotifierProvider<HostWidgetsNotifier, Map<String, HostWidget>>(
      HostWidgetsNotifier.new,
    );

class HostNotifier extends DeviceNotifier<Host> {
  final String arg;
  HostNotifier(this.arg);

  @override
  Host build() {
    return ref.read(hostMapProvider)[arg]!;
  }
}

class HostMapNotifier extends DeviceMapNotifier<Host> {}

class HostWidgetsNotifier extends DeviceWidgetsNotifier<HostWidget> {}
