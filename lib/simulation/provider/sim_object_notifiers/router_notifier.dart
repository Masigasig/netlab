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
  void removeSelf() {
    if (state.eth0conId.isNotEmpty) {
      ref.read(connectionProvider(state.eth0conId).notifier).removeSelf();
    }

    if (state.eth1conId.isNotEmpty) {
      ref.read(connectionProvider(state.eth1conId).notifier).removeSelf();
    }

    if (state.eth2conId.isNotEmpty) {
      ref.read(connectionProvider(state.eth2conId).notifier).removeSelf();
    }

    if (state.eth3conId.isNotEmpty) {
      ref.read(connectionProvider(state.eth3conId).notifier).removeSelf();
    }

    ref.read(routerMapProvider.notifier).removeAllState(state.id);
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

  void addStaticRoute({required String networkId, required String interface_}) {
    final newRoutingTable = Map<String, Map<String, String>>.from(
      state.routingTable,
    );

    newRoutingTable[networkId] = {
      'type': RouteType.static_.label,
      'interface': interface_,
    };

    state = state.copyWith(routingTable: newRoutingTable);
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

    String? keyToUpdate;
    for (final entry in newRoutingTable.entries) {
      if (entry.value['interface'] == targetInterface) {
        keyToUpdate = entry.key;
        break;
      }
    }

    if (ipAddress.trim().isEmpty) {
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

      if (keyToUpdate != null && keyToUpdate != newKey) {
        newRoutingTable.remove(keyToUpdate);
      }

      newRoutingTable[newKey] = {'type': type, 'interface': targetInterface};
    }

    state = state.copyWith(routingTable: newRoutingTable);
  }

  void removeRoute(String networkId) {
    final newRoutingTable = Map<String, Map<String, String>>.from(
      state.routingTable,
    );

    newRoutingTable.remove(networkId);

    state = state.copyWith(routingTable: newRoutingTable);
  }

  void removeConIdByConId(String conId) {
    if (state.eth0conId == conId) {
      state = state.copyWith(eth0conId: '');
    } else if (state.eth1conId == conId) {
      state = state.copyWith(eth1conId: '');
    } else if (state.eth2conId == conId) {
      state = state.copyWith(eth2conId: '');
    } else if (state.eth3conId == conId) {
      state = state.copyWith(eth3conId: '');
    }
  }
}

class RouterMapNotifier extends DeviceMapNotifier<Router> {
  @override
  void invalidateSpecificId(String objectId) {
    if (ref.read(simScreenProvider).selectedDeviceOnInfo == objectId) {
      ref.read(simScreenProvider.notifier).setSelectedDeviceOnInfo('');
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(routerProvider(objectId));
    });
  }

  @override
  void removeAllState(String objectId) {
    ref.read(routerWidgetsProvider.notifier).removeSimObjectWidget(objectId);

    invalidateSpecificId(objectId);
    removeSimObject(objectId);
  }
}

class RouterWidgetsNotifier extends DeviceWidgetsNotifier<RouterWidget> {}
