import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/simulation/sim_screen_state/sim_screen_state.dart';

void main() {
  late ProviderContainer container;
  late SimScreenState state;

  setUp(() {
    container = ProviderContainer();
    state = container.read(simScreenState.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  group('SimScreenState Device Creation', () {
    test('createDevice should create host correctly', () {
      state.createDevice(
        type: SimObjectType.host,
        posX: 100,
        posY: 200,
      );

      final hosts = container.read(hostProvider);
      expect(hosts.length, 1);
      expect(hosts.values.first.name, 'Host 1');
      expect(hosts.values.first.posX, 100);
      expect(hosts.values.first.posY, 200);
    });

    test('createDevice should increment counter correctly', () {
      state.createDevice(
        type: SimObjectType.router,
        posX: 100,
        posY: 200,
      );
      state.createDevice(
        type: SimObjectType.router,
        posX: 300,
        posY: 400,
      );

      final routers = container.read(routerProvider);
      expect(routers.length, 2);
      expect(routers.values.first.name, 'Router 1');
      expect(routers.values.last.name, 'Router 2');
    });
  });

  group('SimScreenState Connection Creation', () {
    test('createConnection should not create when wire mode is off', () {
      state.createConnection(simObjectId: 'testId1');
      state.createConnection(simObjectId: 'testId2');
      
      final connections = container.read(connectionProvider);
      expect(connections.length, 0);
    });

    test('createConnection should create when wire mode id on', () {
      state.toggleWireMode();

      state.createConnection(simObjectId: 'testId1');
      state.createConnection(simObjectId: 'testId2');
      
      final connections = container.read(connectionProvider);
      expect(connections.length, 1);
    });

    test('createConnection should create connection between two devices', () {
      state.toggleWireMode();
      
      state.createDevice(
        type: SimObjectType.host,
        posX: 100,
        posY: 200,
      );
      state.createDevice(
        type: SimObjectType.router,
        posX: 300,
        posY: 400,
      );

      final hosts = container.read(hostProvider);
      final routers = container.read(routerProvider);

      expect(hosts.length, 1);
      expect(routers.length, 1);

      expect(hosts.values.first.name, 'Host 1');
      expect(routers.values.first.name, 'Router 1');

      state.createConnection(simObjectId: hosts.values.first.id);
      state.createConnection(simObjectId: routers.values.first.id);

      final connections = container.read(connectionProvider);
      expect(connections.length, 1);
    });

    test('createConnection should prevent duplicate connections', () {
      state.toggleWireMode();
      
      const hostId = 'host1';
      const routerId = 'router1';

      state.createConnection(simObjectId: hostId);
      state.createConnection(simObjectId: routerId);
      state.toggleWireMode();
      state.createConnection(simObjectId: hostId);
      state.createConnection(simObjectId: routerId);

      final connections = container.read(connectionProvider);
      expect(connections.length, 1);
    });
  });

  group('SimScreenState Export/Import', () {
    test('exportSimulation should create correct map structure', () {
      state.createDevice(
        type: SimObjectType.host,
        posX: 100,
        posY: 200,
      );

      final exportData = state.exportSimulation();

      expect(exportData.containsKey('typeCounters'), true);
      expect(exportData.containsKey('hosts'), true);
      expect(exportData.containsKey('routers'), true);
      expect(exportData.containsKey('switches'), true);
      expect(exportData.containsKey('connections'), true);
    });

    test('importSimulation should restore state correctly', () async {
      state.createDevice(
        type: SimObjectType.host,
        posX: 100,
        posY: 200,
      );

      final exportData = state.exportSimulation();

      await state.importSimulation(<String, dynamic>{
        'typeCounters': <String, dynamic>{},
        'hosts': <Map<String, dynamic>>[],
        'routers': <Map<String, dynamic>>[],
        'switches': <Map<String, dynamic>>[],
        'connections': <Map<String, dynamic>>[],
      });

      expect(container.read(hostProvider).isEmpty, true);

      await state.importSimulation(exportData);

      expect(container.read(hostProvider).length, 1);
    });
  });

  group('SimScreenState Wire Mode', () {
    test('toggleWireMode should toggle state correctly', () {
      expect(container.read(wireModeProvider), false);
      
      state.toggleWireMode();
      expect(container.read(wireModeProvider), true);
      
      state.toggleWireMode();
      expect(container.read(wireModeProvider), false);
    });

    test('toggleWireMode should clear selected devices', () {
      state.toggleWireMode();
      state.createConnection(simObjectId: 'testId');
      state.toggleWireMode();
      
      state.createConnection(simObjectId: 'testId');
      final connections = container.read(connectionProvider);
      expect(connections.isEmpty, true);
    });
  });

  group('SimScreenState Clear State', () {
    test('_clearAllState should reset all state', () async {
      state.createDevice(
        type: SimObjectType.host,
        posX: 100,
        posY: 200,
      );
      state.toggleWireMode();

      await state.importSimulation(<String, dynamic>{
        'typeCounters': <String, dynamic>{},
        'hosts': <Map<String, dynamic>>[],
        'routers': <Map<String, dynamic>>[],
        'switches': <Map<String, dynamic>>[],
        'connections': <Map<String, dynamic>>[],
      });

      expect(container.read(hostProvider).isEmpty, true);
      expect(container.read(wireModeProvider), false);
      expect(container.read(routerProvider).isEmpty, true);
      expect(container.read(switchProvider).isEmpty, true);
      expect(container.read(connectionProvider).isEmpty, true);
    });
  });
}