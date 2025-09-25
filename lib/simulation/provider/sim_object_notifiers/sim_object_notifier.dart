import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netlab/simulation/model/sim_objects/sim_object.dart';
import 'package:netlab/simulation/widgets/sim_object_widgets/sim_object_widget.dart';

part 'connection_notifier.dart';
part 'device_notifier.dart';
part 'host_notifier.dart';
part 'message_notifier.dart';
part 'router_notifier.dart';
part 'switch_notifier.dart';

abstract class SimObjectNotifier<T extends SimObject> extends Notifier<T> {
  @override
  T build();
}

abstract class SimObjectMapNotifier<T extends SimObject>
    extends Notifier<Map<String, T>> {
  @override
  Map<String, T> build() => {};
}

abstract class SimObjectWidgetsNotifier<T extends SimObjectWidget>
    extends Notifier<Map<String, T>> {
  @override
  Map<String, T> build() => {};
}
