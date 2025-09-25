import 'package:flutter_test/flutter_test.dart';
import 'package:netlab/temp/simulation/sim_objects/sim_object.dart';
import 'package:netlab/temp/simulation/network_utils.dart';

void main() {
  group('Connection Test', () {
    late Connection connection;

    setUp(() {
      connection = const Connection(
        id: 'connId',
        conAId: 'conAIdTest',
        conBId: 'conBIdTest',
      );
    });
    test('copyWith creates new Connection with updated properties', () {
      final updatedConnection = connection.copyWith();

      expect(updatedConnection.id, connection.id);
      expect(updatedConnection.conAId, connection.conAId);
      expect(updatedConnection.conBId, connection.conBId);
      expect(updatedConnection.type, SimObjectType.connection);
    });

    test('toMap and fromMap work correctly', () {
      final map = connection.toMap();
      final newConnection = Connection.fromMap(map);

      expect(newConnection.id, connection.id);
      expect(newConnection.conAId, connection.conAId);
      expect(newConnection.conBId, connection.conBId);
      expect(newConnection.type, connection.type);
    });
  });

  group('Host Test', () {
    late Host host;

    setUp(() {
      final macAddress = MacAddressManager.generateUniqueMacAddress();

      host = Host(
        id: 'hostId',
        name: 'Host_1',
        posX: 100,
        posY: 200,
        ipAddress: '192.168.1.3',
        subnetMask: '/24',
        defaultGateway: '192.168.1.1',
        macAddress: macAddress,
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
        posX: 150,
        posY: 250,
        ipAddress: '192.168.2.4',
        subnetMask: '255.255.255.0',
        defaultGateway: '192.168.2.1',
        connectionId: '',
        arpTable: {
          'someIPhere2': 'someMachere2',
          'someIPhere3': 'someMachere3',
        },
        messageIds: ['someMsgId2', 'someMsgId3'],
      );

      expect(updatedHost.id, host.id);
      expect(updatedHost.name, host.name);
      expect(updatedHost.posX, 150);
      expect(updatedHost.posY, 250);
      expect(updatedHost.ipAddress, '192.168.2.4');
      expect(updatedHost.subnetMask, '255.255.255.0');
      expect(
        RegExp(
          r'^([0-9A-F]{2}:){5}[0-9A-F]{2}$',
        ).hasMatch(updatedHost.macAddress),
        isTrue,
      );
      expect(updatedHost.defaultGateway, '192.168.2.1');
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
  });

  group('Message Test', () {
    late Message message;

    setUp(() {
      message = const Message(
        id: 'messageId',
        name: 'Message_1',
        posX: 50,
        posY: 100,
        duration: Duration(seconds: 0),
        srcId: 'someSrcId',
        dstId: 'someDstId',
        currentPlaceId: 'someCrntId',
        layerStack: [
          {'lvl3src': 'someIPsrc', 'lvl3dst': 'someIPdst'},
          {'lvl2src': 'someMACsrc', 'lvl2dst': 'someMACdst'},
          {'lvl1src': 'someConnsrc', 'lvl1dst': 'someConndst'},
        ],
      );
    });

    test('copyWith creates a new Message with updated properties', () {
      final updatedMessage = message.copyWith(
        posX: 75,
        posY: 125,
        duration: const Duration(seconds: 5),
        currentPlaceId: 'newsomeCrntId',
        layerStack: [
          {'newlvl4src': 'newsomePortsrc', 'newlvl4dst': 'newsomePortdst'},
          {'newlvl3src': 'newsomeIPsrc', 'newlvl3dst': 'newsomeIPdst'},
        ],
      );

      expect(updatedMessage.id, message.id);
      expect(updatedMessage.name, message.name);
      expect(updatedMessage.posX, 75);
      expect(updatedMessage.posY, 125);
      expect(updatedMessage.duration, const Duration(seconds: 5));
      expect(updatedMessage.srcId, message.srcId);
      expect(updatedMessage.dstId, message.dstId);
      expect(updatedMessage.currentPlaceId, 'newsomeCrntId');
      expect(updatedMessage.layerStack, [
        {'newlvl4src': 'newsomePortsrc', 'newlvl4dst': 'newsomePortdst'},
        {'newlvl3src': 'newsomeIPsrc', 'newlvl3dst': 'newsomeIPdst'},
      ]);
    });

    test('toMap and fromMap work correctly', () {
      final map = message.toMap();
      final newMessage = Message.fromMap(map);

      expect(newMessage.id, message.id);
      expect(newMessage.name, message.name);
      expect(newMessage.posX, message.posX);
      expect(newMessage.posY, message.posY);
      expect(newMessage.duration, message.duration);
      expect(newMessage.srcId, message.srcId);
      expect(newMessage.dstId, message.dstId);
      expect(newMessage.currentPlaceId, message.currentPlaceId);
      expect(newMessage.layerStack, message.layerStack);
      expect(newMessage.type, message.type);
    });
  });

  group('Switch Test', () {
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
  });

  group('Router Test', () {
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
        eth0MacAddress: MacAddressManager.generateUniqueMacAddress(),
        eth1MacAddress: MacAddressManager.generateUniqueMacAddress(),
        eth2MacAddress: MacAddressManager.generateUniqueMacAddress(),
        eth3MacAddress: MacAddressManager.generateUniqueMacAddress(),
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
  });
}
