part of 'sim_screen_state.dart';

final connectionProvider =
    StateNotifierProvider<ConnectionNotifier, Map<String, Connection>>(
      (ref) => ConnectionNotifier(ref),
    );
final connectionWidgetProvider =
    StateNotifierProvider<
      ConnectionWidgetNotifier,
      Map<String, ConnectionWidget>
    >((ref) => ConnectionWidgetNotifier());

class ConnectionNotifier extends SimObjectNotifier<Connection> {
  ConnectionNotifier(super.ref);
}

class ConnectionWidgetNotifier
    extends SimObjectWidgetNotifier<ConnectionWidget> {}
