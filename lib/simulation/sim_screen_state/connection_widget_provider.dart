part of 'sim_screen_state.dart';

final connectionWidgetProvider =
    StateNotifierProvider<
      ConnectionWidgetNotifier,
      Map<String, ConnectionWidget>
    >((ref) => ConnectionWidgetNotifier());

class ConnectionWidgetNotifier
    extends StateNotifier<Map<String, ConnectionWidget>> {
  ConnectionWidgetNotifier() : super({});

  void addConnection(String key, ConnectionWidget connection) {
    state = {...state, key: connection};
  }
}
