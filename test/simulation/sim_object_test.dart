import 'package:flutter_test/flutter_test.dart';
import 'package:netlab/simulation/sim_object/sim_object.dart';

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
      host = const Host(id: 'hostId', name: 'Host_1', posX: 100, posY: 200);
    });

    test('copyWith creates a new Host with updated properties', () {
      final updatedHost = host.copyWith(posX: 150, posY: 250);

      expect(updatedHost.id, host.id);
      expect(updatedHost.name, host.name);
      expect(updatedHost.posX, 150);
      expect(updatedHost.posY, 250);
      expect(updatedHost.type, SimObjectType.host);
    });

    test('toMap and fromMap work correctly', () {
      final map = host.toMap();
      final newHost = Host.fromMap(map);

      expect(newHost.id, host.id);
      expect(newHost.name, host.name);
      expect(newHost.posX, host.posX);
      expect(newHost.posY, host.posY);
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
