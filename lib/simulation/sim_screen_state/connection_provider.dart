part of 'sim_screen_state.dart';

final connectionProvider =
    StateNotifierProvider<ConnectionNotifier, Map<String, Connection>>(
      (ref) => ConnectionNotifier(),
    );

class ConnectionNotifier extends StateNotifier<Map<String, Connection>> {
  ConnectionNotifier() : super({});

  void addConnection(Connection connection) {
    state = {...state, connection.id: connection};
  }
}
