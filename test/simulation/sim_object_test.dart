import 'package:flutter_test/flutter_test.dart';
import 'package:netlab/simulation/sim_object/sim_object.dart';
import 'package:netlab/simulation/sim_screen_state/network_utils.dart';

void main() {
  group('Connection Test', () {
    late Connection connection;

    setUp(() {
      connection = const Connection(
        id: 'connId',
        conA: 'conAId',
        conB: 'conBId',
      );
    });
    test('copyWith creates new Connection with updated properties', () {
      final updatedConnection = connection.copyWith(
        conA: 'newConA',
        conB: 'newConB',
      );

      expect(updatedConnection.id, 'connId');
      expect(updatedConnection.conA, 'newConA');
      expect(updatedConnection.conB, 'newConB');
      expect(updatedConnection.type, SimObjectType.connection);
    });

    test('toMap and fromMap work correctly', () {
      final map = connection.toMap();
      final newConnection = Connection.fromMap(map);

      expect(newConnection.id, connection.id);
      expect(newConnection.conA, connection.conA);
      expect(newConnection.conB, connection.conB);
      expect(newConnection.type, connection.type);
    });
  });

  group('Host Test', () {
    late Host host;

    setUp(() {
      final macAddress = generateUniqueMacAddress();

      host = Host(
        id: 'hostId',
        name: 'Host_1',
        posX: 100,
        posY: 200,
        ipAddress: '192.168.1.3',
        subnetMask: '/24',
        macAddress: macAddress,
        defaultGateway: '192.168.1.1',
        connectedDeviceId: 'someIDhere',
        arpTable: {
          'someIPhere' : 'someMachere',
          'someIPhere1' : 'someMachere1',
          'someIPhere2' : 'someMachere2',
        }
      );
    });

    test('copyWith creates a new Host with updated properties', () {
      final updatedHost = host.copyWith(
        posX: 150,
        posY: 250,
        ipAddress: '192.168.2.4',
        subnetMask: '255.255.255.0',
        defaultGateway: '192.168.2.1',
        connectedDeviceId: 'newSomeIDhere',
        arpTable: {
          'someIPhere' : 'someMachere',
          'someIPhere1' : 'someMachere1',
          'someIPhere2' : 'someMachere2',
          'someIPhere3' : 'someMachere3',
        }
      );

      expect(updatedHost.id, host.id);
      expect(updatedHost.name, host.name);
      expect(updatedHost.posX, 150);
      expect(updatedHost.posY, 250);
      expect(updatedHost.ipAddress, '192.168.2.4');
      expect(updatedHost.subnetMask, '255.255.255.0');
      expect(RegExp(r'^([0-9A-F]{2}:){5}[0-9A-F]{2}$').hasMatch(updatedHost.macAddress), isTrue);
      expect(updatedHost.defaultGateway, '192.168.2.1');
      expect(updatedHost.connectedDeviceId, 'newSomeIDhere');
      expect(updatedHost.arpTable, {
          'someIPhere' : 'someMachere',
          'someIPhere1' : 'someMachere1',
          'someIPhere2' : 'someMachere2',
          'someIPhere3' : 'someMachere3',
        });
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
      expect(newHost.macAddress, host.macAddress);
      expect(newHost.defaultGateway, host.defaultGateway);
      expect(newHost.connectedDeviceId, host.connectedDeviceId);
      expect(newHost.arpTable, host.arpTable);
      expect(newHost.type, host.type);
    });
  });

  group('Router Test', () {
    late Router router;

    setUp(() {
      router = const Router(
        id: 'routerId',
        name: 'Router_1',
        posX: 100,
        posY: 200,
      );
    });

    test('copyWith creates a new Router with updated properties', () {
      final updatedRouter = router.copyWith(posX: 150, posY: 250);

      expect(updatedRouter.id, router.id);
      expect(updatedRouter.name, router.name);
      expect(updatedRouter.posX, 150);
      expect(updatedRouter.posY, 250);
      expect(updatedRouter.type, SimObjectType.router);
    });

    test('toMap and fromMap work correctly', () {
      final map = router.toMap();
      final newRouter = Router.fromMap(map);

      expect(newRouter.id, router.id);
      expect(newRouter.name, router.name);
      expect(newRouter.posX, router.posX);
      expect(newRouter.posY, router.posY);
      expect(newRouter.type, router.type);
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
      );
    });

    test('copyWith creates a new Switch with updated properties', () {
      final updatedSwitch = switch_.copyWith(posX: 150, posY: 250);

      expect(updatedSwitch.id, switch_.id);
      expect(updatedSwitch.name, switch_.name);
      expect(updatedSwitch.posX, 150);
      expect(updatedSwitch.posY, 250);
      expect(updatedSwitch.type, SimObjectType.switch_);
    });

    test('toMap and fromMap work correctly', () {
      final map = switch_.toMap();
      final newSwitch = Switch.fromMap(map);

      expect(newSwitch.id, switch_.id);
      expect(newSwitch.name, switch_.name);
      expect(newSwitch.posX, switch_.posX);
      expect(newSwitch.posY, switch_.posY);
      expect(newSwitch.type, switch_.type);
    });
  });
}
