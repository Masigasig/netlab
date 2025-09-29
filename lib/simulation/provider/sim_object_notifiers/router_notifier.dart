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

  @override
  List<Map<String, String>> getAllConnectionInfo() {
    return [
      {
        ConnInfoKey.name.name: Eth.eth0.name,
        ConnInfoKey.conId.name: state.eth0conId,
      },
      {
        ConnInfoKey.name.name: Eth.eth1.name,
        ConnInfoKey.conId.name: state.eth1conId,
      },
      {
        ConnInfoKey.name.name: Eth.eth2.name,
        ConnInfoKey.conId.name: state.eth2conId,
      },
      {
        ConnInfoKey.name.name: Eth.eth3.name,
        ConnInfoKey.conId.name: state.eth3conId,
      },
    ];
  }

  void updateConIdByEthName(String ethName, String newConId) {
    final eth = Eth.values.firstWhere((e) => e.name == ethName);

    state = switch (eth) {
      Eth.eth0 => state.copyWith(eth0conId: newConId),
      Eth.eth1 => state.copyWith(eth1conId: newConId),
      Eth.eth2 => state.copyWith(eth2conId: newConId),
      Eth.eth3 => state.copyWith(eth3conId: newConId),
    };
  }

  void updateIpByEthName(String ethName, String newIp) {
    final eth = Eth.values.firstWhere((e) => e.name == ethName);
    switch (eth) {
      case Eth.eth0:
        state = state.copyWith(eth0IpAddress: newIp);
        break;
      case Eth.eth1:
        state = state.copyWith(eth1IpAddress: newIp);
        break;
      case Eth.eth2:
        state = state.copyWith(eth2IpAddress: newIp);
        break;
      case Eth.eth3:
        state = state.copyWith(eth3IpAddress: newIp);
        break;
    }
  }
}

class RouterMapNotifier extends DeviceMapNotifier<Router> {}

class RouterWidgetsNotifier extends DeviceWidgetsNotifier<RouterWidget> {}
