part of 'sim_screen_state.dart';

abstract class SimObjectNotifier<T extends SimObject>
    extends StateNotifier<Map<String, T>> {
  SimObjectNotifier() : super({});

  void addSimObject(T simObject) {
    state = {...state, simObject.id: simObject};
  }
}

abstract class SimObjectWidgetNotifier<T extends SimObjectWidget>
    extends StateNotifier<Map<String, T>> {
  SimObjectWidgetNotifier() : super({});

  void addSimObjectWidget(T simObjectWidget) {
    state = {...state, simObjectWidget.simObjectId: simObjectWidget};
  }
}
