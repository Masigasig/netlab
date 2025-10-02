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

  @override
  void removeSelf() {
    if (state.port0conId.isNotEmpty) {
      ref.read(connectionProvider(state.port0conId).notifier).removeSelf();
    }
    if (state.port1conId.isNotEmpty) {
      ref.read(connectionProvider(state.port1conId).notifier).removeSelf();
    }
    if (state.port2conId.isNotEmpty) {
      ref.read(connectionProvider(state.port2conId).notifier).removeSelf();
    }
    if (state.port3conId.isNotEmpty) {
      ref.read(connectionProvider(state.port3conId).notifier).removeSelf();
    }
    if (state.port4conId.isNotEmpty) {
      ref.read(connectionProvider(state.port4conId).notifier).removeSelf();
    }
    if (state.port5conId.isNotEmpty) {
      ref.read(connectionProvider(state.port5conId).notifier).removeSelf();
    }

    ref.read(switchMapProvider.notifier).removeAllState(state.id);
  }

  @override
  List<Map<String, String>> getAllConnectionInfo() {
    return [
      {
        ConnInfoKey.name.name: Port.port0.name,
        ConnInfoKey.conId.name: state.port0conId,
      },
      {
        ConnInfoKey.name.name: Port.port1.name,
        ConnInfoKey.conId.name: state.port1conId,
      },
      {
        ConnInfoKey.name.name: Port.port2.name,
        ConnInfoKey.conId.name: state.port2conId,
      },
      {
        ConnInfoKey.name.name: Port.port3.name,
        ConnInfoKey.conId.name: state.port3conId,
      },
      {
        ConnInfoKey.name.name: Port.port4.name,
        ConnInfoKey.conId.name: state.port4conId,
      },
      {
        ConnInfoKey.name.name: Port.port5.name,
        ConnInfoKey.conId.name: state.port5conId,
      },
    ];
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
}

class SwitchMapNotifier extends DeviceMapNotifier<Switch> {
  @override
  void invalidateSpecificId(String objectId) {
    if (ref.read(simScreenProvider).selectedDeviceOnInfo == objectId) {
      ref.read(simScreenProvider.notifier).setSelectedDeviceOnInfo('');
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(switchProvider(objectId));
    });
  }

  @override
  void removeAllState(String objectId) {
    ref.read(switchWidgetsProvider.notifier).removeSimObjectWidget(objectId);

    invalidateSpecificId(objectId);
    removeSimObject(objectId);
  }
}

class SwitchWidgetsNotifier extends DeviceWidgetsNotifier<SwitchWidget> {}
