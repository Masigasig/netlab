import 'package:flutter_test/flutter_test.dart';

import 'package:netlab/simulation/core/enums.dart';
import 'package:netlab/simulation/model/sim_objects/sim_object.dart';

void main() {
  late Switch switch_;

  setUp(() {
    switch_ = const Switch(
      id: 'switchId',
      name: 'Switch_1',
      posX: 100,
      posY: 200,
      port0conId: 'connId0',
      port1conId: 'connId1',
      port2conId: 'connId2',
      port3conId: 'connId3',
      port4conId: 'connId4',
      port5conId: 'connId5',
      macTable: {
        'macAddress0': 'port0',
        'macAddress1': 'port1',
        'macAddress2': 'port2',
        'macAddress3': 'port3',
        'macAddress4': 'port4',
        'macAddress5': 'port5',
      },
    );
  });

  test('copyWith creates a new Switch with updated properties', () {
    final updatedSwitch = switch_.copyWith(
      posX: 150,
      posY: 250,
      port0conId: 'newConnId0',
      port1conId: 'newConnId1',
      port2conId: 'newConnId2',
      port3conId: 'newConnId3',
      port4conId: 'newConnId4',
      port5conId: 'newConnId5',
      macTable: {
        'newMacAddress0': 'newPort0',
        'newMacAddress1': 'newPort1',
        'newMacAddress2': 'newPort2',
        'newMacAddress3': 'newPort3',
        'newMacAddress4': 'newPort4',
        'newMacAddress5': 'newPort5',
      },
    );

    expect(updatedSwitch.id, switch_.id);
    expect(updatedSwitch.name, switch_.name);
    expect(updatedSwitch.posX, 150);
    expect(updatedSwitch.posY, 250);
    expect(updatedSwitch.port0conId, 'newConnId0');
    expect(updatedSwitch.port1conId, 'newConnId1');
    expect(updatedSwitch.port2conId, 'newConnId2');
    expect(updatedSwitch.port3conId, 'newConnId3');
    expect(updatedSwitch.port4conId, 'newConnId4');
    expect(updatedSwitch.port5conId, 'newConnId5');
    expect(updatedSwitch.macTable, {
      'newMacAddress0': 'newPort0',
      'newMacAddress1': 'newPort1',
      'newMacAddress2': 'newPort2',
      'newMacAddress3': 'newPort3',
      'newMacAddress4': 'newPort4',
      'newMacAddress5': 'newPort5',
    });
    expect(updatedSwitch.type, SimObjectType.switch_);
  });

  test('toMap and fromMap work correctly', () {
    final map = switch_.toMap();
    final newSwitch = Switch.fromMap(map);

    expect(newSwitch.id, switch_.id);
    expect(newSwitch.name, switch_.name);
    expect(newSwitch.posX, switch_.posX);
    expect(newSwitch.posY, switch_.posY);
    expect(newSwitch.port0conId, switch_.port0conId);
    expect(newSwitch.port1conId, switch_.port1conId);
    expect(newSwitch.port2conId, switch_.port2conId);
    expect(newSwitch.port3conId, switch_.port3conId);
    expect(newSwitch.port4conId, switch_.port4conId);
    expect(newSwitch.port5conId, switch_.port5conId);
    expect(newSwitch.macTable, {});
    expect(newSwitch.type, switch_.type);
  });
}
