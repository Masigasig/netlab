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
      hostNotifier(state.conAId).updateConnectionId('');
    } else if (state.conAId.startsWith(SimObjectType.router.label)) {
      routerNotifier(state.conAId).removeConIdByConId(state.id);
    } else if (state.conAId.startsWith(SimObjectType.switch_.label)) {
      switchNotifier(state.conAId).removeConIdByConId(state.id);
    }

    if (state.conBId.startsWith(SimObjectType.host.label)) {
      hostNotifier(state.conBId).updateConnectionId('');
    } else if (state.conBId.startsWith(SimObjectType.router.label)) {
      routerNotifier(state.conBId).removeConIdByConId(state.id);
    } else if (state.conBId.startsWith(SimObjectType.switch_.label)) {
      switchNotifier(state.conBId).removeConIdByConId(state.id);
    }

    ref.read(connectionMapProvider.notifier).removeAllState(state.id);
  }
}

class ConnectionMapNotifier extends SimObjectMapNotifier<Connection> {
  ConnectionMapNotifier()
    : super(
        mapProvider: connectionMapProvider,
        objectProvider: connectionProvider,
        widgetsProvider: connectionWidgetsProvider,
      );
}

class ConnectionWidgetsNotifier
    extends SimObjectWidgetsNotifier<ConnectionWidget> {}
