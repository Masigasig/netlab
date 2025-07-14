part of 'sim_screen_state.dart';

final connectionProvider =
    StateNotifierProvider<ConnectionNotifier, Map<String, Connection>>(
      (ref) => ConnectionNotifier(),
    );
final connectionWidgetProvider =
    StateNotifierProvider<
      ConnectionWidgetNotifier,
      Map<String, ConnectionWidget>
    >((ref) => ConnectionWidgetNotifier());

class ConnectionNotifier extends SimObjectNotifier<Connection> {}

class ConnectionWidgetNotifier
    extends SimObjectWidgetNotifier<ConnectionWidget> {}
