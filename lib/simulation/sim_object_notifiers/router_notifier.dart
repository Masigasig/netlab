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
    return [
      {
        ConnectionInfoKey.name.name: Eth.eth0.name,
        ConnectionInfoKey.conId.name: state.eth0conId,
      },
      {
        ConnectionInfoKey.name.name: Eth.eth1.name,
        ConnectionInfoKey.conId.name: state.eth1conId,
      },
      {
        ConnectionInfoKey.name.name: Eth.eth2.name,
        ConnectionInfoKey.conId.name: state.eth2conId,
      },
      {
        ConnectionInfoKey.name.name: Eth.eth3.name,
        ConnectionInfoKey.conId.name: state.eth3conId,
      },
    ];
  }

  @override
  void removeSelf() {
    if (state.eth0conId.isNotEmpty) {
      connectionNotifier(state.eth0conId).removeSelf();
    }

    if (state.eth1conId.isNotEmpty) {
      connectionNotifier(state.eth1conId).removeSelf();
    }

    if (state.eth2conId.isNotEmpty) {
      connectionNotifier(state.eth2conId).removeSelf();
    }

    if (state.eth3conId.isNotEmpty) {
      connectionNotifier(state.eth3conId).removeSelf();
    }

    routerMapNotifier.removeAllState(state.id);
  }

  void updateConIdByEthName(String ethName, String newConId) {
    final eth = Eth.values.firstWhere((e) => e.name == ethName);
    switch (eth) {
      case Eth.eth0:
        state = state.copyWith(eth0conId: newConId);
        break;
      case Eth.eth1:
        state = state.copyWith(eth1conId: newConId);
        break;
      case Eth.eth2:
        state = state.copyWith(eth2conId: newConId);
        break;
      case Eth.eth3:
        state = state.copyWith(eth3conId: newConId);
        break;
    }
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
