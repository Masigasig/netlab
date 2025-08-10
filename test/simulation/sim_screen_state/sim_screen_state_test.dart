import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/simulation/sim_screen_state.dart';

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

  group('SimObject/SimObjectWidget Creation', () {
    test('createDevice should create host correctly', () {
      state.createDevice(type: SimObjectType.host, posX: 100, posY: 200);

      final hosts = container.read(hostMapProvider);
      expect(hosts.length, 1);
      expect(hosts.values.first.name, equals('Host 1'));
      expect(hosts.values.first.posX, equals(100));
      expect(hosts.values.first.posY, equals(200));
    });

    test('createDevice should increment counter correctly', () {
      state.createDevice(type: SimObjectType.router, posX: 100, posY: 200);
      state.createDevice(type: SimObjectType.router, posX: 300, posY: 400);

      final routers = container.read(routerMapProvider);
      expect(routers.length, equals(2));
      expect(routers.values.first.name, equals('Router 1'));
      expect(routers.values.last.name, equals('Router 2'));
    });

    test('createConnection should not create when wire mode is off', () {
      state.createConnection(simObjectId: 'testId1');
      state.createConnection(simObjectId: 'testId2');

      final connections = container.read(connectionMapProvider);
      expect(connections.length, equals(0));
    });

    test('createConnection should create when wire mode id on', () {
      state.toggleWireMode();

      state.createConnection(simObjectId: 'testId1');
      state.createConnection(simObjectId: 'testId2');

      final connections = container.read(connectionMapProvider);
      expect(connections.length, equals(1));
    });

    test('createConnection should create connection between two devices', () {
      state.toggleWireMode();

      state.createDevice(type: SimObjectType.host, posX: 100, posY: 200);
      state.createDevice(type: SimObjectType.router, posX: 300, posY: 400);

      final hosts = container.read(hostMapProvider);
      final routers = container.read(routerMapProvider);

      expect(hosts.length, equals(1));
      expect(routers.length, equals(1));

      expect(hosts.values.first.name, equals('Host 1'));
      expect(routers.values.first.name, equals('Router 1'));

      state.createConnection(simObjectId: hosts.values.first.id);
      state.createConnection(simObjectId: routers.values.first.id);

      final connections = container.read(connectionMapProvider);
      expect(connections.length, equals(1));
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

      final connections = container.read(connectionMapProvider);
      expect(connections.length, equals(1));
    });
  });

  group('SimScreenState Export/Import', () {
    test('exportSimulation should create correct map structure', () {
      state.createDevice(type: SimObjectType.host, posX: 100, posY: 200);

      final exportData = state.exportSimulation();

      expect(exportData.containsKey('typeCounters'), isTrue);
      expect(exportData.containsKey('hosts'), isTrue);
      expect(exportData.containsKey('routers'), isTrue);
      expect(exportData.containsKey('switches'), isTrue);
      expect(exportData.containsKey('connections'), isTrue);

      state.importSimulation(<String, dynamic>{
        'typeCounters': <String, dynamic>{},
        'hosts': <Map<String, dynamic>>[],
        'routers': <Map<String, dynamic>>[],
        'switches': <Map<String, dynamic>>[],
        'connections': <Map<String, dynamic>>[],
      });

      expect(container.read(hostMapProvider).isEmpty, isTrue);

      state.importSimulation(exportData);

      expect(container.read(hostMapProvider).length, equals(1));
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
      final connections = container.read(connectionMapProvider);
      expect(connections.isEmpty, true);
    });
  });

  group('SimScreenState Clear State', () {
    test('_clearAllState should reset all state', () async {
      state.createDevice(type: SimObjectType.host, posX: 100, posY: 200);
      state.toggleWireMode();

      state.importSimulation(<String, dynamic>{
        'typeCounters': <String, dynamic>{},
        'hosts': <Map<String, dynamic>>[],
        'routers': <Map<String, dynamic>>[],
        'switches': <Map<String, dynamic>>[],
        'connections': <Map<String, dynamic>>[],
      });

      expect(container.read(hostMapProvider).isEmpty, true);
      expect(container.read(wireModeProvider), false);
      expect(container.read(routerMapProvider).isEmpty, true);
      expect(container.read(switchMapProvider).isEmpty, true);
      expect(container.read(connectionMapProvider).isEmpty, true);
    });
  });
}
