part of 'sim_object_notifier.dart';

final switchProvider =
    StateNotifierProvider.family<SwitchNotifier, Switch, String>(
      (ref, id) => SwitchNotifier(ref, id),
    );

class SwitchNotifier extends DeviceNotifier<Switch> {
  SwitchNotifier(Ref ref, String id)
    : super(ref.read(switchMapProvider)[id]!, ref);

  @override
  void receiveMessage(String messageId, String fromConId) {
    // TODO: implement receiveMessage
  }

  @override
  List<Map<String, String>> getAllConnectionInfo() {
    return [
      {
        ConnectionInfoKey.name.name: ConnectionInfoName.port0.name,
        ConnectionInfoKey.conId.name: state.port0conId,
      },
      {
        ConnectionInfoKey.name.name: ConnectionInfoName.port1.name,
        ConnectionInfoKey.conId.name: state.port1conId,
      },
      {
        ConnectionInfoKey.name.name: ConnectionInfoName.port2.name,
        ConnectionInfoKey.conId.name: state.port2conId,
      },
      {
        ConnectionInfoKey.name.name: ConnectionInfoName.port3.name,
        ConnectionInfoKey.conId.name: state.port3conId,
      },
      {
        ConnectionInfoKey.name.name: ConnectionInfoName.port4.name,
        ConnectionInfoKey.conId.name: state.port4conId,
      },
      {
        ConnectionInfoKey.name.name: ConnectionInfoName.port5.name,
        ConnectionInfoKey.conId.name: state.port5conId,
      },
    ];
  }

  void updateConIdByPortName(String portName, String conId) {
    switch (portName) {
      case 'port0':
        state = state.copyWith(port0conId: conId);
      case 'port1':
        state = state.copyWith(port1conId: conId);
      case 'port2':
        state = state.copyWith(port2conId: conId);
      case 'port3':
        state = state.copyWith(port3conId: conId);
      case 'port4':
        state = state.copyWith(port4conId: conId);
      case 'port5':
        state = state.copyWith(port5conId: conId);
    }
  }

  void removeConIdByConId(String conId) {
    if (state.port0conId == conId) {
      state = state.copyWith(port0conId: '');
    } else if (state.port1conId == conId) {
      state = state.copyWith(port1conId: '');
    } else if (state.port2conId == conId) {
      state = state.copyWith(port2conId: '');
    } else if (state.port3conId == conId) {
      state = state.copyWith(port3conId: '');
    } else if (state.port4conId == conId) {
      state = state.copyWith(port4conId: '');
    } else if (state.port5conId == conId) {
      state = state.copyWith(port5conId: '');
    }
  }

  @override
  void removeSelf() {
    if (state.port0conId.isNotEmpty) {
      connectionNotifier(state.port0conId).removeSelf();
    }
    if (state.port1conId.isNotEmpty) {
      connectionNotifier(state.port1conId).removeSelf();
    }
    if (state.port2conId.isNotEmpty) {
      connectionNotifier(state.port2conId).removeSelf();
    }
    if (state.port3conId.isNotEmpty) {
      connectionNotifier(state.port3conId).removeSelf();
    }
    if (state.port4conId.isNotEmpty) {
      connectionNotifier(state.port4conId).removeSelf();
    }
    if (state.port5conId.isNotEmpty) {
      connectionNotifier(state.port5conId).removeSelf();
    }

    switchMapNotifier.removeAllState(state.id);
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

  @override
  void invalidateSpecificId(String objectId) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(switchProvider(objectId));
    });
  }

  @override
  void removeAllState(String objectId) {
    ref.read(switchWidgetProvider.notifier).removeSimObjectWidget(objectId);
    removeSimObject(objectId);
    invalidateSpecificId(objectId);
  }
}

final switchWidgetProvider =
    StateNotifierProvider<SwitchWidgetNotifier, Map<String, SwitchWidget>>(
      (ref) => SwitchWidgetNotifier(),
    );

class SwitchWidgetNotifier extends DeviceWidgetNotifier<SwitchWidget> {}
