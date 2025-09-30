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

    state = switch (eth) {
      Eth.eth0 => state.copyWith(eth0IpAddress: newIp),
      Eth.eth1 => state.copyWith(eth1IpAddress: newIp),
      Eth.eth2 => state.copyWith(eth2IpAddress: newIp),
      Eth.eth3 => state.copyWith(eth3IpAddress: newIp),
    };
  }

  void updateSubnetMaskByEthName(String ethName, String newSubnetMask) {
    final eth = Eth.values.firstWhere((e) => e.name == ethName);

    state = switch (eth) {
      Eth.eth0 => state.copyWith(eth0SubnetMask: newSubnetMask),
      Eth.eth1 => state.copyWith(eth1SubnetMask: newSubnetMask),
      Eth.eth2 => state.copyWith(eth2SubnetMask: newSubnetMask),
      Eth.eth3 => state.copyWith(eth3SubnetMask: newSubnetMask),
    };
  }

  void updateOrAddRoutingEntry({
    required String type,
    required String subnetMask,
    required String ipAddress,
    required String targetInterface,
  }) {
    final newRoutingTable = Map<String, Map<String, String>>.from(
      state.routingTable,
    );

    // Find existing entry by interface
    String? keyToUpdate;
    for (final entry in newRoutingTable.entries) {
      if (entry.value['interface'] == targetInterface) {
        keyToUpdate = entry.key;
        break;
      }
    }

    if (ipAddress.trim().isEmpty) {
      // Remove if IP is empty and entry exists
      if (keyToUpdate != null) {
        newRoutingTable.remove(keyToUpdate);
      }
    } else {
      final subnetInCidr = Ipv4AddressManager.subnetToCidr(subnetMask);
      final networkAddress = Ipv4AddressManager.getNetworkAddress(
        ipAddress,
        subnetMask,
      );
      final newKey = networkAddress + subnetInCidr;

      // If entry exists, update it
      if (keyToUpdate != null && keyToUpdate != newKey) {
        newRoutingTable.remove(keyToUpdate);
      }

      newRoutingTable[newKey] = {'type': type, 'interface': targetInterface};
    }

    state = state.copyWith(routingTable: newRoutingTable);
  }
}

class RouterMapNotifier extends DeviceMapNotifier<Router> {}

class RouterWidgetsNotifier extends DeviceWidgetsNotifier<RouterWidget> {}
