import 'package:flutter_test/flutter_test.dart';

import 'package:netlab/simulation/core/enums.dart';
import 'package:netlab/simulation/core/mac_address_manager.dart';
import 'package:netlab/simulation/model/sim_objects/sim_object.dart';

void main() {
  late Router router;

  setUp(() {
    router = Router(
      id: 'routerId',
      name: 'Router_1',
      posX: 100,
      posY: 200,
      eth0IpAddress: 'sample.eth0.ip',
      eth1IpAddress: 'sample.eth1.ip',
      eth2IpAddress: 'sample.eth2.ip',
      eth3IpAddress: 'sample.eth3.ip',
      eth0SubnetMask: 'sample.eth0.subnet',
      eth1SubnetMask: 'sample.eth1.subnet',
      eth2SubnetMask: 'sample.eth2.subnet',
      eth3SubnetMask: 'sample.eth3.subnet',
      eth0MacAddress: MacAddressManager.generateMacAddress(),
      eth1MacAddress: MacAddressManager.generateMacAddress(),
      eth2MacAddress: MacAddressManager.generateMacAddress(),
      eth3MacAddress: MacAddressManager.generateMacAddress(),
      eth0conId: 'connId0',
      eth1conId: 'connId1',
      eth2conId: 'connId2',
      eth3conId: 'connId3',
      arpTable: {
        'someIPhere': 'someMacAddressHere',
        'someIPhere1': 'someMacAddressHere1',
      },
      routingTable: {
        'networkAddressWithSubnetMask': {
          'type': 'directed',
          'interface': 'eth',
        },
        'networkAddressWithSubnetMask2': {
          'type': 'static',
          'interface': 'someIpAddress',
        },
      },
    );
  });

  test('copyWith creates a new Router with updated properties', () {
    final updatedRouter = router.copyWith(
      posX: 150,
      posY: 250,
      eth0IpAddress: 'new.eth0.ip',
      eth1IpAddress: 'new.eth1.ip',
      eth2IpAddress: 'new.eth2.ip',
      eth3IpAddress: 'new.eth3.ip',
      eth0SubnetMask: 'new.eth0.subnet',
      eth1SubnetMask: 'new.eth1.subnet',
      eth2SubnetMask: 'new.eth2.subnet',
      eth3SubnetMask: 'new.eth3.subnet',
      eth0conId: 'newConnId0',
      eth1conId: 'newConnId1',
      eth2conId: 'newConnId2',
      eth3conId: 'newConnId3',
      arpTable: {
        'newIPhere': 'newMacAddressHere',
        'newIPhere1': 'newMacAddressHere1',
      },
      routingTable: {
        'newnetworkAddressWithSubnetMask': {
          'type': 'directed',
          'interface': 'eth3',
        },
        'newnetworkAddressWithSubnetMask2': {
          'type': 'static',
          'interface': 'someIpAddress2',
        },
      },
    );

    expect(updatedRouter.id, router.id);
    expect(updatedRouter.name, router.name);
    expect(updatedRouter.posX, 150);
    expect(updatedRouter.posY, 250);
    expect(updatedRouter.eth0IpAddress, 'new.eth0.ip');
    expect(updatedRouter.eth1IpAddress, 'new.eth1.ip');
    expect(updatedRouter.eth2IpAddress, 'new.eth2.ip');
    expect(updatedRouter.eth3IpAddress, 'new.eth3.ip');
    expect(updatedRouter.eth0SubnetMask, 'new.eth0.subnet');
    expect(updatedRouter.eth1SubnetMask, 'new.eth1.subnet');
    expect(updatedRouter.eth2SubnetMask, 'new.eth2.subnet');
    expect(updatedRouter.eth3SubnetMask, 'new.eth3.subnet');
    expect(updatedRouter.eth0conId, 'newConnId0');
    expect(updatedRouter.eth1conId, 'newConnId1');
    expect(updatedRouter.eth2conId, 'newConnId2');
    expect(updatedRouter.eth3conId, 'newConnId3');
    expect(updatedRouter.arpTable, {
      'newIPhere': 'newMacAddressHere',
      'newIPhere1': 'newMacAddressHere1',
    });
    expect(updatedRouter.routingTable, {
      'newnetworkAddressWithSubnetMask': {
        'type': 'directed',
        'interface': 'eth3',
      },
      'newnetworkAddressWithSubnetMask2': {
        'type': 'static',
        'interface': 'someIpAddress2',
      },
    });
    expect(updatedRouter.type, SimObjectType.router);
  });

  test('toMap and fromMap work correctly', () {
    final map = router.toMap();
    final newRouter = Router.fromMap(map);

    expect(newRouter.id, router.id);
    expect(newRouter.name, router.name);
    expect(newRouter.posX, router.posX);
    expect(newRouter.posY, router.posY);
    expect(newRouter.eth0IpAddress, router.eth0IpAddress);
    expect(newRouter.eth1IpAddress, router.eth1IpAddress);
    expect(newRouter.eth2IpAddress, router.eth2IpAddress);
    expect(newRouter.eth3IpAddress, router.eth3IpAddress);
    expect(newRouter.eth0SubnetMask, router.eth0SubnetMask);
    expect(newRouter.eth1SubnetMask, router.eth1SubnetMask);
    expect(newRouter.eth2SubnetMask, router.eth2SubnetMask);
    expect(newRouter.eth3SubnetMask, router.eth3SubnetMask);
    expect(newRouter.eth0MacAddress, router.eth0MacAddress);
    expect(newRouter.eth1MacAddress, router.eth1MacAddress);
    expect(newRouter.eth2MacAddress, router.eth2MacAddress);
    expect(newRouter.eth3MacAddress, router.eth3MacAddress);
    expect(newRouter.eth0conId, router.eth0conId);
    expect(newRouter.eth1conId, router.eth1conId);
    expect(newRouter.eth2conId, router.eth2conId);
    expect(newRouter.eth3conId, router.eth3conId);
    expect(newRouter.arpTable, {});
    expect(newRouter.routingTable, router.routingTable);
    expect(newRouter.type, router.type);
  });
}
