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
      state.createDevice(type: SimObjectType.host, posX: 100, posY: 200);

      final hosts = container.read(hostProvider);
      expect(hosts.length, 1);
      expect(hosts.values.first.name, 'Host 1');
      expect(hosts.values.first.posX, 100);
      expect(hosts.values.first.posY, 200);
    });

    test('createDevice should increment counter correctly', () {
      state.createDevice(type: SimObjectType.router, posX: 100, posY: 200);
      state.createDevice(type: SimObjectType.router, posX: 300, posY: 400);

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

      state.createDevice(type: SimObjectType.host, posX: 100, posY: 200);
      state.createDevice(type: SimObjectType.router, posX: 300, posY: 400);

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
      state.createDevice(type: SimObjectType.host, posX: 100, posY: 200);

      final exportData = state.exportSimulation();

      expect(exportData.containsKey('typeCounters'), true);
      expect(exportData.containsKey('hosts'), true);
      expect(exportData.containsKey('routers'), true);
      expect(exportData.containsKey('switches'), true);
      expect(exportData.containsKey('connections'), true);
    });

    test('importSimulation should restore state correctly', () async {
      state.createDevice(type: SimObjectType.host, posX: 100, posY: 200);

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
      state.createDevice(type: SimObjectType.host, posX: 100, posY: 200);
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

  group('SimScreenState MAC Address Generation', () {
    test(
      'generateUniqueMacAddress should generate valid MAC address format',
      () {
        final mac = state.generateUniqueMacAddress();

        // Test MAC address format (XX:XX:XX:XX:XX:XX)
        expect(
          RegExp(r'^([0-9A-F]{2}:){5}[0-9A-F]{2}$').hasMatch(mac),
          true,
          reason: 'MAC address should be in format XX:XX:XX:XX:XX:XX',
        );
      },
    );
  });

  group('IP/Subnet/broadcast/network address Validation', () {
    test('isValidIp should validate IP addresses correctly', () {
      expect(state.isValidIp('asdfads'), false);
      expect(state.isValidIp('192.168.256.6'), false);
      expect(state.isValidIp('192.168.0.6.6'), false);
      expect(state.isValidIp('RE.sfe.ger.eeq'), false);

      expect(state.isValidIp('192.168.255.3'), true);
      expect(state.isValidIp('0.0.0.0'), true);
      expect(state.isValidIp('255.255.255.255'), true);
    });

    test('isValidSubnet should validate SubnetMask correctly', () {
      expect(state.isValidSubnet('/0'), true);
      expect(state.isValidSubnet('/16'), true);
      expect(state.isValidSubnet('/32'), true);
      expect(state.isValidSubnet('0.0.0.0'), true);
      expect(state.isValidSubnet('255.255.128.0'), true);
      expect(state.isValidSubnet('255.255.255.255'), true);

      expect(state.isValidSubnet('/-1'), false);
      expect(state.isValidSubnet('/33'), false);
      expect(state.isValidSubnet('/'), false);
      expect(state.isValidSubnet('/abc'), false);
      expect(state.isValidSubnet('-1.0.0.0'), false);
      expect(state.isValidSubnet('256.255.255.255'), false);
      expect(state.isValidSubnet('255.255.255.250'), false);
      expect(state.isValidSubnet('255.0.255.0'), false);
      expect(state.isValidSubnet('adfasdf'), false);
      expect(state.isValidSubnet('192.168.0.2'), false);
    });

    test('getNetworkAddress should compute network correctly', () {
      expect(
        state.getNetworkAddress('10.0.15.256', '/8'),
        'Not Valid IP address',
      );
      expect(
        state.getNetworkAddress('10.0.15.253', '/33'),
        'Not Valid Subnetmask',
      );

      expect(state.getNetworkAddress('10.0.15.67', '/8'), '10.0.0.0');
      expect(state.getNetworkAddress('192.168.1.10', '/24'), '192.168.1.0');
      expect(
        state.getNetworkAddress('192.168.1.10', '255.255.255.0'),
        '192.168.1.0',
      );
      expect(
        state.getNetworkAddress('172.16.5.123', '255.255.255.192'),
        '172.16.5.64',
      );

      expect(state.getNetworkAddress('192.0.2.200', '/32'), '192.0.2.200');
      expect(state.getNetworkAddress('203.0.113.55', '/0'), '0.0.0.0');
      expect(state.getNetworkAddress('8.8.8.8', '0.0.0.0'), '0.0.0.0');
    });

    test('getBroadcastAddress should compute broadcast address correctly', () {
      expect(
        state.getBroadcastAddress('192.168.1.10', '255.255.255.0'),
        '192.168.1.255',
      );
      expect(state.getBroadcastAddress('10.0.15.67', '/8'), '10.255.255.255');
      expect(
        state.getBroadcastAddress('172.16.5.123', '255.255.255.192'),
        '172.16.5.127',
      );
      expect(
        state.getBroadcastAddress('192.0.2.200', '/32'),
        '192.0.2.200',
      ); // Only one host
      expect(
        state.getBroadcastAddress('203.0.113.55', '/0'),
        '255.255.255.255',
      ); // All addresses
      expect(
        state.getBroadcastAddress('8.8.8.8', '0.0.0.0'),
        '255.255.255.255',
      ); // Explicit full mask

      expect(
        state.getBroadcastAddress('300.168.1.1', '255.255.255.0'),
        'Not Valid IP address',
      );
      expect(
        state.getBroadcastAddress('abcd', '255.255.255.0'),
        'Not Valid IP address',
      );

      expect(
        state.getBroadcastAddress('192.168.1.10', '255.0.255.0'),
        'Not Valid Subnetmask',
      );
      expect(
        state.getBroadcastAddress('192.168.1.10', '/33'),
        'Not Valid Subnetmask',
      );
      expect(
        state.getBroadcastAddress('192.168.1.10', '/'),
        'Not Valid Subnetmask',
      );
    });

    group('isValidIPForSubnet should valid IP address correctly', () {
      test('isValidIpForSubnet returns true for valid host IPs', () {
        expect(
          state.isValidIpForSubnet('192.168.1.10', '255.255.255.0'),
          true,
        ); // host in range
        expect(state.isValidIpForSubnet('10.0.0.1', '/8'), true); // valid host
        expect(
          state.isValidIpForSubnet('172.16.5.62', '255.255.255.192'),
          true,
        ); // last usable host
      });

      test(
        'isValidIpForSubnet returns false for network and broadcast addresses',
        () {
          expect(
            state.isValidIpForSubnet('192.168.1.0', '255.255.255.0'),
            false,
          ); // network address
          expect(
            state.isValidIpForSubnet('192.168.1.255', '255.255.255.0'),
            false,
          ); // broadcast address
          expect(state.isValidIpForSubnet('10.0.0.0', '/8'), false); // network
          expect(
            state.isValidIpForSubnet('10.255.255.255', '/8'),
            false,
          ); // broadcast
        },
      );

      test('isValidIpForSubnet returns false for invalid IP or subnet', () {
        expect(
          state.isValidIpForSubnet('999.999.999.999', '255.255.255.0'),
          false,
        ); // invalid IP
        expect(
          state.isValidIpForSubnet('192.168.1.10', '255.255.0.255'),
          false,
        ); // invalid subnet
        expect(
          state.isValidIpForSubnet('abc.def.gha.jkl', '255.255.255.0'),
          false,
        ); // junk IP
      });
    });
  });
}
