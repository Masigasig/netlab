import 'package:flutter_test/flutter_test.dart';
import 'package:netlab/simulation/sim_screen_state/network_utils.dart';

void main() {
  group('MAC Address Generation', () {
    test('generateUniqueMacAddress returns valid MAC', () {
      final mac = generateUniqueMacAddress();
      final macRegex = RegExp(r'^([0-9A-F]{2}:){5}[0-9A-F]{2}$');
      expect(macRegex.hasMatch(mac), isTrue);
      expect(mac, isNot('FF:FF:FF:FF:FF:FF'));
      expect(mac, isNot('00:00:00:00:00:00'));
    });

    test('generateUniqueMacAddress generates unique addresses', () {
      final macs = <String>{};
      for (int i = 0; i < 10; i++) {
        macs.add(generateUniqueMacAddress());
      }
      expect(macs.length, 10);
    });
  });

  group('IP and Subnet Validation', () {
    test('isValidIp returns true for valid IPs', () {
      expect(isValidIp('192.168.1.1'), isTrue);
      expect(isValidIp('192.168.255.3'), isTrue);
      expect(isValidIp('0.0.0.0'), isTrue);
      expect(isValidIp('255.255.255.255'), isTrue);
    });

    test('isValidIp returns false for invalid IPs', () {
      expect(isValidIp('256.0.0.1'), isFalse);
      expect(isValidIp('asdfads'), isFalse);
      expect(isValidIp('192.168.256.6'), isFalse);
      expect(isValidIp('192.168.0.6.6'), isFalse);
      expect(isValidIp('192.168.1'), isFalse);
      expect(isValidIp('abc.def.ghi.jkl'), isFalse);
      expect(isValidIp('RE.sfe.ger.eeq'), isFalse);
    });

    test('isValidSubnet returns true for valid subnets', () {
      expect(isValidSubnet('/24'), isTrue);
      expect(isValidSubnet('/0'), isTrue);
      expect(isValidSubnet('/16'), isTrue);
      expect(isValidSubnet('/32'), isTrue);
      expect(isValidSubnet('0.0.0.0'), isTrue);
      expect(isValidSubnet('255.255.128.0'), isTrue);
      expect(isValidSubnet('255.255.255.0'), isTrue);
      expect(isValidSubnet('255.255.255.255'), isTrue);
    });

    test('isValidSubnet returns false for invalid subnets', () {
      expect(isValidSubnet('/33'), isFalse);
      expect(isValidSubnet('255.255.0.1'), isFalse);
      expect(isValidSubnet('/-1'), isFalse);
      expect(isValidSubnet('/'), isFalse);
      expect(isValidSubnet('/abc'), isFalse);
      expect(isValidSubnet('-1.0.0.0'), isFalse);
      expect(isValidSubnet('256.255.255.255'), isFalse);
      expect(isValidSubnet('255.255.255.250'), isFalse);
      expect(isValidSubnet('255.0.255.0'), isFalse);
      expect(isValidSubnet('adfasdf'), isFalse);
      expect(isValidSubnet('192.168.0.2'), isFalse);
    });
  });

  group('Network and Broadcast Address Calculation', () {
    test('getNetworkAddress returns correct network address', () {
      expect(getNetworkAddress('192.168.1.10', '/24'), '192.168.1.0');
      expect(getNetworkAddress('10.0.0.5', '255.0.0.0'), '10.0.0.0');
      expect(getNetworkAddress('10.0.15.67', '/8'), '10.0.0.0');

      expect(getNetworkAddress('192.168.1.10', '255.255.255.0'), '192.168.1.0');
      expect(
        getNetworkAddress('172.16.5.123', '255.255.255.192'),
        '172.16.5.64',
      );

      expect(getNetworkAddress('192.0.2.200', '/32'), '192.0.2.200');
      expect(getNetworkAddress('203.0.113.55', '/0'), '0.0.0.0');
      expect(getNetworkAddress('8.8.8.8', '0.0.0.0'), '0.0.0.0');
    });

    test('getBroadcastAddress returns correct broadcast address', () {
      expect(getBroadcastAddress('192.168.1.10', '/24'), '192.168.1.255');
      expect(getBroadcastAddress('10.0.0.5', '255.0.0.0'), '10.255.255.255');

      expect(
        getBroadcastAddress('192.168.1.10', '255.255.255.0'),
        '192.168.1.255',
      );
      expect(getBroadcastAddress('10.0.15.67', '/8'), '10.255.255.255');
      expect(
        getBroadcastAddress('172.16.5.123', '255.255.255.192'),
        '172.16.5.127',
      );
      expect(
        getBroadcastAddress('192.0.2.200', '/32'),
        '192.0.2.200',
      ); // Only one host
      expect(
        getBroadcastAddress('203.0.113.55', '/0'),
        '255.255.255.255',
      ); // All addresses
      expect(
        getBroadcastAddress('8.8.8.8', '0.0.0.0'),
        '255.255.255.255',
      ); // Explicit full mask
    });

    test('getNetworkAddress returns error for invalid input', () {
      expect(
        getNetworkAddress('999.999.999.999', '/24'),
        'Not Valid IP address',
      );
      expect(getNetworkAddress('192.168.1.1', '/33'), 'Not Valid Subnetmask');
      expect(getNetworkAddress('10.0.15.256', '/8'), 'Not Valid IP address');
      expect(getNetworkAddress('10.0.15.253', '/33'), 'Not Valid Subnetmask');
    });

    test('getBroadcastAddress returns error for invalid input', () {
      expect(
        getBroadcastAddress('999.999.999.999', '/24'),
        'Not Valid IP address',
      );
      expect(getBroadcastAddress('192.168.1.1', '/33'), 'Not Valid Subnetmask');

      expect(
        getBroadcastAddress('300.168.1.1', '255.255.255.0'),
        'Not Valid IP address',
      );
      expect(
        getBroadcastAddress('abcd', '255.255.255.0'),
        'Not Valid IP address',
      );

      expect(
        getBroadcastAddress('192.168.1.10', '255.0.255.0'),
        'Not Valid Subnetmask',
      );
      expect(
        getBroadcastAddress('192.168.1.10', '/33'),
        'Not Valid Subnetmask',
      );
      expect(getBroadcastAddress('192.168.1.10', '/'), 'Not Valid Subnetmask');
    });
  });

  group('isValidIpForSubnet', () {
    test('returns false for network and broadcast addresses', () {
      expect(isValidIpForSubnet('192.168.1.0', '/24'), isFalse);
      expect(isValidIpForSubnet('192.168.1.255', '/24'), isFalse);
      expect(
        isValidIpForSubnet('192.168.1.0', '255.255.255.0'),
        isFalse,
      ); // network address
      expect(
        isValidIpForSubnet('192.168.1.255', '255.255.255.0'),
        isFalse,
      ); // broadcast address
      expect(isValidIpForSubnet('10.0.0.0', '/8'), isFalse); // network
      expect(isValidIpForSubnet('10.255.255.255', '/8'), isFalse); // broadcast

      expect(
        isValidIpForSubnet('999.999.999.999', '255.255.255.0'),
        isFalse,
      ); // invalid IP
      expect(
        isValidIpForSubnet('192.168.1.10', '255.255.0.255'),
        isFalse,
      ); // invalid subnet
      expect(
        isValidIpForSubnet('abc.def.gha.jkl', '255.255.255.0'),
        isFalse,
      ); // junk IP
    });

    test('returns true for valid host address', () {
      expect(isValidIpForSubnet('192.168.1.10', '/24'), isTrue);
      expect(
        isValidIpForSubnet('192.168.1.10', '255.255.255.0'),
        isTrue,
      ); // host in range
      expect(isValidIpForSubnet('10.0.0.1', '/8'), isTrue); // valid host
      expect(
        isValidIpForSubnet('172.16.5.62', '255.255.255.192'),
        isTrue,
      ); // last usable host
    });
  });
}
