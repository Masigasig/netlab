import 'package:flutter_test/flutter_test.dart';

import 'package:netlab/simulation/core/enums.dart';
import 'package:netlab/simulation/core/mac_address_manager.dart';
import 'package:netlab/simulation/model/sim_objects/sim_object.dart';

void main() {
  late Host host;

  setUp(() {
    final mac = MacAddressManager.generateMacAddress();

    host = Host(
      id: 'hostId',
      name: 'hostName',
      posX: 100,
      posY: 100,
      ipAddress: '192.168.1.3',
      subnetMask: '/24',
      defaultGateway: '192.168.1.1',
      macAddress: mac,
      connectionId: 'conn_Id',
      arpTable: {
        'someIPhere': 'someMachere',
        'someIPhere1': 'someMachere1',
        'someIPhere2': 'someMachere2',
      },
      messageIds: ['someMsgId1', 'someMsgId2'],
    );
  });

  test('copyWith creates a new Host with updated properties', () {
    final updatedHost = host.copyWith(
      name: 'newName',
      posX: 150,
      posY: 250,
      ipAddress: '192.168.2.4',
      subnetMask: '255.255.255.0',
      defaultGateway: '192.168.2.1',
      connectionId: '',
      arpTable: {'someIPhere2': 'someMachere2', 'someIPhere3': 'someMachere3'},
      messageIds: ['someMsgId2', 'someMsgId3'],
    );

    expect(updatedHost.id, host.id);
    expect(updatedHost.name, 'newName');
    expect(updatedHost.posX, 150);
    expect(updatedHost.posY, 250);
    expect(updatedHost.ipAddress, '192.168.2.4');
    expect(updatedHost.subnetMask, '255.255.255.0');
    expect(updatedHost.defaultGateway, '192.168.2.1');
    expect(updatedHost.macAddress, host.macAddress);
    expect(updatedHost.arpTable, {
      'someIPhere2': 'someMachere2',
      'someIPhere3': 'someMachere3',
    });
    expect(updatedHost.messageIds, ['someMsgId2', 'someMsgId3']);
    expect(updatedHost.type, SimObjectType.host);
  });

  test('toMap and fromMap work correctly', () {
    final map = host.toMap();
    final newHost = Host.fromMap(map);

    expect(newHost.id, host.id);
    expect(newHost.name, host.name);
    expect(newHost.posX, host.posX);
    expect(newHost.posY, host.posY);
    expect(newHost.ipAddress, host.ipAddress);
    expect(newHost.subnetMask, host.subnetMask);
    expect(newHost.defaultGateway, host.defaultGateway);
    expect(newHost.macAddress, host.macAddress);
    expect(newHost.connectionId, host.connectionId);
    expect(newHost.arpTable, {});
    expect(newHost.messageIds, host.messageIds);
    expect(newHost.type, host.type);
  });
}
