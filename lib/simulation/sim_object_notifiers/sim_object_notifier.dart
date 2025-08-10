import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/simulation/network_utils.dart';
import 'package:netlab/simulation/sim_objects/sim_object.dart';
import 'package:netlab/simulation/sim_object_widgets/sim_object_widget.dart';
import 'package:netlab/simulation/sim_screen_state.dart' show SimObjectTypeX;

part 'connection_notifier.dart';
part 'device_notifier.dart';
part 'host_notifier.dart';
part 'message_notifier.dart';
part 'router_notifier.dart';
part 'switch_notifier.dart';

abstract class SimObjectMapNotifier<T extends SimObject>
    extends StateNotifier<Map<String, T>> {
  SimObjectMapNotifier() : super({});

  void addSimObject(T simObject) {
    state = {...state, simObject.id: simObject};
  }

  void clearState() => state = {};

  List<Map<String, dynamic>> exportToList() =>
      state.values.map((obj) => obj.toMap()).toList();

  void importFromList(List<dynamic> list) {
    Map<String, T> newMap = {};
    for (final map in list) {
      final obj = SimObject.fromMap(map);
      newMap[obj.id] = obj as T;
    }

    state = newMap;
  }
}

abstract class SimObjectNotifier<T extends SimObject> extends StateNotifier<T> {
  final Ref ref;

  SimObjectNotifier(super.state, this.ref);
}

abstract class SimObjectWidgetNotifier<T extends SimObjectWidget>
    extends StateNotifier<Map<String, T>> {
  SimObjectWidgetNotifier() : super({});

  void clearState() => state = {};

  void importFromList(List<dynamic> list) {
    Map<String, T> newMap = {};
    for (final map in list) {
      final type = SimObjectType.values.byName(map['type']);
      final widget = SimObjectWidget.fromType(type, map['id']) as T;
      newMap[widget.simObjectId] = widget;
    }
    state = newMap;
  }

  void addSimObjectWidget(T simObjectWidget) {
    state = {...state, simObjectWidget.simObjectId: simObjectWidget};
  }
}
