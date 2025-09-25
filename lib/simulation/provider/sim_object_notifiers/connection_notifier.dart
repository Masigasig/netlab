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
}

class ConnectionMapNotifier extends SimObjectMapNotifier<Connection> {}

class ConnectionWidgetsNotifier
    extends SimObjectWidgetsNotifier<ConnectionWidget> {}
