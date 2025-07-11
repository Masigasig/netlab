import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/simulation/model/sim_object/sim_object.dart';

final simObjectMapProvider =
    StateNotifierProvider<SimObjectMapNotifier, Map<String, SimObject>>(
      (ref) => SimObjectMapNotifier(ref),
    );

class SimObjectMapNotifier extends StateNotifier<Map<String, SimObject>> {
  final Ref ref;

  SimObjectMapNotifier(this.ref) : super({});

  void addObject(SimObject object) {
    state = {...state, object.id: object};
  }

  void updatePosition(String deviceId, double x, double y) {
    if (state.containsKey(deviceId)) {
      final simObject = state[deviceId]!;
      if (simObject is Device) {
        final updatedDevice = simObject.copyWith(posX: x, posY: y);
        state = {...state, deviceId: updatedDevice};
      }
    }
  }
}