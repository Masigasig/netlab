part of 'sim_object_notifier.dart';

final connectionProvider =
    NotifierProvider.family<ConnectionNotifier, Connection, String>(
      ConnectionNotifier.new,
    );

final connectionMapProvider =
    NotifierProvider<ConnectionMapNotifier, Map<String, Connection>>(
      ConnectionMapNotifier.new,
    );

final connectionWidgetsProvider =
    NotifierProvider<ConnectionWidgetsNotifier, Map<String, ConnectionWidget>>(
      ConnectionWidgetsNotifier.new,
    );

class ConnectionNotifier extends SimObjectNotifier<Connection> {
  final String arg;
  ConnectionNotifier(this.arg);

  @override
  Connection build() {
    return ref.read(connectionMapProvider)[arg]!;
  }

  @override
  void removeSelf() {
    if (state.conAId.startsWith(SimObjectType.host.label)) {
      ref.read(hostProvider(state.conAId).notifier).updateConnectionId('');
    } else if (state.conAId.startsWith(SimObjectType.switch_.label)) {
      ref
          .read(switchProvider(state.conAId).notifier)
          .removeConIdByConId(state.id);
    } else if (state.conAId.startsWith(SimObjectType.router.label)) {
      ref
          .read(routerProvider(state.conAId).notifier)
          .removeConIdByConId(state.id);
    }

    if (state.conBId.startsWith(SimObjectType.host.label)) {
      ref.read(hostProvider(state.conBId).notifier).updateConnectionId('');
    } else if (state.conBId.startsWith(SimObjectType.switch_.label)) {
      ref
          .read(switchProvider(state.conBId).notifier)
          .removeConIdByConId(state.id);
    } else if (state.conBId.startsWith(SimObjectType.router.label)) {
      ref
          .read(routerProvider(state.conBId).notifier)
          .removeConIdByConId(state.id);
    }

    ref.read(connectionMapProvider.notifier).removeAllState(state.id);
  }
}

class ConnectionMapNotifier extends SimObjectMapNotifier<Connection> {
  @override
  void invalidateSpecificId(String objectId) {
    if (ref.read(simScreenProvider).selectedDeviceOnInfo == objectId) {
      ref.read(simScreenProvider.notifier).setSelectedDeviceOnInfo('');
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(connectionProvider(objectId));
    });
  }

  @override
  void removeAllState(String objectId) {
    ref
        .read(connectionWidgetsProvider.notifier)
        .removeSimObjectWidget(objectId);

    invalidateSpecificId(objectId);
    removeSimObject(objectId);
  }
}

class ConnectionWidgetsNotifier
    extends SimObjectWidgetsNotifier<ConnectionWidget> {}
