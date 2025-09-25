import 'package:flutter_test/flutter_test.dart';
import 'package:netlab/temp/simulation/network_utils.dart';

void main() {
  group('MacAddressManager', () {
    test('generateUniqueMacAddress returns a valid and unique MAC', () {
      final mac = MacAddressManager.generateUniqueMacAddress();

      expect(MacAddressManager.isValid(mac), isTrue);
      expect(mac, isNot(equals(MacAddressManager.broadcastMacAddress)));
      expect(mac, isNot(equals(MacAddressManager.unknownMacAddress)));
      expect(MacAddressManager.macStorage.contains(mac), isTrue);
    });

    test('remove returns true when MAC is removed', () {
      final mac = MacAddressManager.generateUniqueMacAddress();
      final result = MacAddressManager.remove(mac);

      expect(result, isTrue);
      expect(MacAddressManager.macStorage.contains(mac), isFalse);
    });

    test('remove returns false when MAC does not exist', () {
      final result = MacAddressManager.remove('AA:BB:CC:DD:EE:FF');
      expect(result, isFalse);
    });

    test('isValid returns false for malformed MAC', () {
      expect(MacAddressManager.isValid('ZZ:ZZ:ZZ:ZZ:ZZ:ZZ'), isFalse);
      expect(MacAddressManager.isValid('123456'), isFalse);
      expect(MacAddressManager.isValid('00:00:00:00:00'), isFalse);
    });

    test('isValid returns true for correct MAC format', () {
      expect(MacAddressManager.isValid('AA:BB:CC:DD:EE:FF'), isTrue);
    });
  });

  group('IPv4AddressManager', () {
    test('isValidIp returns true for valid IPs', () {
      expect(IPv4AddressManager.isValidIp('192.168.1.1'), isTrue);
      expect(IPv4AddressManager.isValidIp('0.0.0.0'), isTrue);
      expect(IPv4AddressManager.isValidIp('255.255.255.255'), isTrue);
      expect(IPv4AddressManager.isValidIp('192.168.255.3'), isTrue);
    });

    test('isValidIp returns false for invalid IPs', () {
      expect(IPv4AddressManager.isValidIp('256.256.256.256'), isFalse);
      expect(IPv4AddressManager.isValidIp('abc.def.ghi.jkl'), isFalse);
      expect(IPv4AddressManager.isValidIp('192.168.1'), isFalse);
      expect(IPv4AddressManager.isValidIp('256.0.0.1'), isFalse);
      expect(IPv4AddressManager.isValidIp('asdfads'), isFalse);
      expect(IPv4AddressManager.isValidIp('192.168.256.6'), isFalse);
      expect(IPv4AddressManager.isValidIp('192.168.0.6.6'), isFalse);
      expect(IPv4AddressManager.isValidIp('RE.sfe.ger.eeq'), isFalse);
    });

    test('isValidSubnet accepts CIDR and dotted masks', () {
      expect(IPv4AddressManager.isValidSubnet('/0'), isTrue);
      expect(IPv4AddressManager.isValidSubnet('/16'), isTrue);
      expect(IPv4AddressManager.isValidSubnet('/24'), isTrue);
      expect(IPv4AddressManager.isValidSubnet('/32'), isTrue);
      expect(IPv4AddressManager.isValidSubnet('0.0.0.0'), isTrue);
      expect(IPv4AddressManager.isValidSubnet('255.255.128.0'), isTrue);
      expect(IPv4AddressManager.isValidSubnet('255.255.255.0'), isTrue);
      expect(IPv4AddressManager.isValidSubnet('255.255.255.255'), isTrue);
    });

    test('isValidSubnet rejects invalid formats', () {
      expect(IPv4AddressManager.isValidSubnet('/'), isFalse);
      expect(IPv4AddressManager.isValidSubnet('/-1'), isFalse);
      expect(IPv4AddressManager.isValidSubnet('/33'), isFalse);
      expect(IPv4AddressManager.isValidSubnet('/abc'), isFalse);
      expect(IPv4AddressManager.isValidSubnet('invalid'), isFalse);
      expect(IPv4AddressManager.isValidSubnet('adfasdf'), isFalse);
      expect(IPv4AddressManager.isValidSubnet('-1.0.0.0'), isFalse);
      expect(IPv4AddressManager.isValidSubnet('192.168.0.2'), isFalse);
      expect(IPv4AddressManager.isValidSubnet('255.0.255.0'), isFalse);
      expect(IPv4AddressManager.isValidSubnet('255.255.0.1'), isFalse);
      expect(IPv4AddressManager.isValidSubnet('255.255.0.255'), isFalse);
      expect(IPv4AddressManager.isValidSubnet('255.255.255.250'), isFalse);
      expect(IPv4AddressManager.isValidSubnet('256.255.255.255'), isFalse);
    });

    /* To test this make the method public
    test('normalizeSubnet converts CIDR to dotted mask', () {
      final expectedMasks = {
        0: '0.0.0.0',
        1: '128.0.0.0',
        2: '192.0.0.0',
        3: '224.0.0.0',
        4: '240.0.0.0',
        5: '248.0.0.0',
        6: '252.0.0.0',
        7: '254.0.0.0',
        8: '255.0.0.0',
        9: '255.128.0.0',
        10: '255.192.0.0',
        11: '255.224.0.0',
        12: '255.240.0.0',
        13: '255.248.0.0',
        14: '255.252.0.0',
        15: '255.254.0.0',
        16: '255.255.0.0',
        17: '255.255.128.0',
        18: '255.255.192.0',
        19: '255.255.224.0',
        20: '255.255.240.0',
        21: '255.255.248.0',
        22: '255.255.252.0',
        23: '255.255.254.0',
        24: '255.255.255.0',
        25: '255.255.255.128',
        26: '255.255.255.192',
        27: '255.255.255.224',
        28: '255.255.255.240',
        29: '255.255.255.248',
        30: '255.255.255.252',
        31: '255.255.255.254',
        32: '255.255.255.255',
      };

      expectedMasks.forEach((cidr, mask) {
        expect(
          IPv4AddressManager.normalizeSubnet('/$cidr'),
          equals(mask),
          reason: 'CIDR /$cidr should map to $mask',
        );
      });
    });
    */

    test('subnetToCidr converts dotted mask to CIDR', () {
      final testCases = {
        '128.0.0.0': '/1',
        '192.0.0.0': '/2',
        '224.0.0.0': '/3',
        '240.0.0.0': '/4',
        '248.0.0.0': '/5',
        '252.0.0.0': '/6',
        '254.0.0.0': '/7',
        '255.0.0.0': '/8',
        '255.128.0.0': '/9',
        '255.192.0.0': '/10',
        '255.224.0.0': '/11',
        '255.240.0.0': '/12',
        '255.248.0.0': '/13',
        '255.252.0.0': '/14',
        '255.254.0.0': '/15',
        '255.255.0.0': '/16',
        '255.255.128.0': '/17',
        '255.255.192.0': '/18',
        '255.255.224.0': '/19',
        '255.255.240.0': '/20',
        '255.255.248.0': '/21',
        '255.255.252.0': '/22',
        '255.255.254.0': '/23',
        '255.255.255.0': '/24',
        '255.255.255.128': '/25',
        '255.255.255.192': '/26',
        '255.255.255.224': '/27',
        '255.255.255.240': '/28',
        '255.255.255.248': '/29',
        '255.255.255.252': '/30',
        '255.255.255.254': '/31',
        '255.255.255.255': '/32',
      };

      for (final entry in testCases.entries) {
        expect(
          IPv4AddressManager.subnetToCidr(entry.key),
          equals(entry.value),
          reason: 'Failed for ${entry.key}',
        );
      }
    });

    test('getNetworkAddress returns correct network address', () {
      expect(
        IPv4AddressManager.getNetworkAddress('203.0.113.55', '/0'),
        equals('0.0.0.0'),
      );
      expect(
        IPv4AddressManager.getNetworkAddress('10.0.15.67', '/8'),
        equals('10.0.0.0'),
      );
      expect(
        IPv4AddressManager.getNetworkAddress('192.168.1.10', '/24'),
        equals('192.168.1.0'),
      );
      expect(
        IPv4AddressManager.getNetworkAddress('192.0.2.200', '/32'),
        equals('192.0.2.200'),
      );
      expect(
        IPv4AddressManager.getNetworkAddress('8.8.8.8', '0.0.0.0'),
        equals('0.0.0.0'),
      );
      expect(
        IPv4AddressManager.getNetworkAddress('10.0.0.5', '255.0.0.0'),
        equals('10.0.0.0'),
      );
      expect(
        IPv4AddressManager.getNetworkAddress('192.168.1.10', '255.255.255.0'),
        equals('192.168.1.0'),
      );
      expect(
        IPv4AddressManager.getNetworkAddress('172.16.5.123', '255.255.255.192'),
        equals('172.16.5.64'),
      );
    });

    test('getBroadcastAddress returns correct broadcast address', () {
      expect(
        IPv4AddressManager.getBroadcastAddress('203.0.113.55', '/0'),
        equals('255.255.255.255'),
      );
      expect(
        IPv4AddressManager.getBroadcastAddress('10.0.15.67', '/8'),
        equals('10.255.255.255'),
      );
      expect(
        IPv4AddressManager.getBroadcastAddress('192.168.1.10', '/24'),
        equals('192.168.1.255'),
      );
      expect(
        IPv4AddressManager.getBroadcastAddress('192.0.2.200', '/32'),
        equals('192.0.2.200'),
      );
      expect(
        IPv4AddressManager.getBroadcastAddress('8.8.8.8', '0.0.0.0'),
        equals('255.255.255.255'),
      );
      expect(
        IPv4AddressManager.getBroadcastAddress('10.0.0.5', '255.0.0.0'),
        equals('10.255.255.255'),
      );
      expect(
        IPv4AddressManager.getBroadcastAddress('192.168.1.10', '255.255.255.0'),
        equals('192.168.1.255'),
      );
      expect(
        IPv4AddressManager.getBroadcastAddress(
          '172.16.5.123',
          '255.255.255.192',
        ),
        equals('172.16.5.127'),
      );
    });

    test('isValidIpForSubnet returns false for network/broadcast IPs', () {
      expect(IPv4AddressManager.isValidIpForSubnet('10.0.0.0', '/8'), isFalse);
      expect(
        IPv4AddressManager.isValidIpForSubnet('192.168.1.0', '/24'),
        isFalse,
      );
      expect(
        IPv4AddressManager.isValidIpForSubnet('192.168.1.255', '/24'),
        isFalse,
      );
      expect(
        IPv4AddressManager.isValidIpForSubnet('10.255.255.255', '/8'),
        isFalse,
      );
      expect(
        IPv4AddressManager.isValidIpForSubnet('192.168.1.0', '255.255.255.0'),
        isFalse,
      );
      expect(
        IPv4AddressManager.isValidIpForSubnet('192.168.1.10', '255.255.0.255'),
        isFalse,
      );
      expect(
        IPv4AddressManager.isValidIpForSubnet('192.168.1.255', '255.255.255.0'),
        isFalse,
      );
      expect(
        IPv4AddressManager.isValidIpForSubnet(
          '999.999.999.999',
          '255.255.255.0',
        ),
        isFalse,
      );
      expect(
        IPv4AddressManager.isValidIpForSubnet(
          'abc.def.gha.jkl',
          '255.255.255.0',
        ),
        isFalse,
      );
    });

    test('isValidIpForSubnet returns true for usable IPs', () {
      expect(IPv4AddressManager.isValidIpForSubnet('10.0.0.1', '/8'), isTrue);
      expect(
        IPv4AddressManager.isValidIpForSubnet('192.168.1.10', '/24'),
        isTrue,
      );
      expect(
        IPv4AddressManager.isValidIpForSubnet('192.168.1.10', '/24'),
        isTrue,
      );
      expect(
        IPv4AddressManager.isValidIpForSubnet('192.168.1.10', '255.255.255.0'),
        isTrue,
      );
      expect(
        IPv4AddressManager.isValidIpForSubnet('172.16.5.62', '255.255.255.192'),
        isTrue,
      );
    });

    test('isInSameNetwork returns true for IPs in same subnet', () {
      expect(
        IPv4AddressManager.isInSameNetwork('10.0.0.1', '/8', '10.0.255.255'),
        isTrue,
      );
      expect(
        IPv4AddressManager.isInSameNetwork('172.16.5.4', '/16', '172.16.200.1'),
        isTrue,
      );
      expect(
        IPv4AddressManager.isInSameNetwork(
          '192.168.1.10',
          '/24',
          '192.168.1.20',
        ),
        isTrue,
      );
      expect(
        IPv4AddressManager.isInSameNetwork(
          '10.0.0.1',
          '255.0.0.0',
          '10.0.255.255',
        ),
        isTrue,
      );
      expect(
        IPv4AddressManager.isInSameNetwork(
          '172.16.5.4',
          '255.255.0.0',
          '172.16.200.1',
        ),
        isTrue,
      );
      expect(
        IPv4AddressManager.isInSameNetwork(
          '192.168.1.2',
          '255.255.255.0',
          '192.168.1.254',
        ),
        isTrue,
      );
      expect(
        IPv4AddressManager.isInSameNetwork(
          '192.168.1.10',
          '255.255.255.0',
          '192.168.1.20',
        ),
        isTrue,
      );
    });

    test('isInSameNetwork returns false for IPs in different subnets', () {
      expect(
        IPv4AddressManager.isInSameNetwork(
          '192.168.1.10',
          '/24',
          '192.168.2.10',
        ),
        isFalse,
      );
      expect(
        IPv4AddressManager.isInSameNetwork('10.0.0.1', '255.0.0.0', '11.0.0.1'),
        isFalse,
      );
      expect(
        IPv4AddressManager.isInSameNetwork(
          '172.16.5.4',
          '255.255.0.0',
          '172.17.5.4',
        ),
        isFalse,
      );
      expect(
        IPv4AddressManager.isInSameNetwork(
          '192.168.1.10',
          '255.255.0',
          '192.168.1.20',
        ),
        isFalse,
      );
      expect(
        IPv4AddressManager.isInSameNetwork(
          '192.168.1.0',
          '255.255.255.0',
          '192.168.1.254',
        ),
        isFalse,
      );
      expect(
        IPv4AddressManager.isInSameNetwork(
          '192.168.1.2',
          '255.255.255.0',
          '192.168.1.255',
        ),
        isFalse,
      );
      expect(
        IPv4AddressManager.isInSameNetwork(
          '192.168.1.10',
          '255.255.255.0',
          '192.168.2.20',
        ),
        isFalse,
      );
      expect(
        IPv4AddressManager.isInSameNetwork(
          '192.168.1.10',
          '255.255.255.0',
          'abc.def.ghi.jkl',
        ),
        isFalse,
      );
      expect(
        IPv4AddressManager.isInSameNetwork(
          '999.999.999.999',
          '255.255.255.0',
          '192.168.1.20',
        ),
        isFalse,
      );
    });

    test('getNetworkAddress returns error for invalid input', () {
      expect(
        IPv4AddressManager.getNetworkAddress('10.0.15.256', '/8'),
        equals('Not Valid IP address'),
      );
      expect(
        IPv4AddressManager.getNetworkAddress('999.999.999.999', '/24'),
        equals('Not Valid IP address'),
      );

      expect(
        IPv4AddressManager.getNetworkAddress('192.168.1.1', '/33'),
        equals('Not Valid Subnetmask'),
      );
      expect(
        IPv4AddressManager.getNetworkAddress('10.0.15.253', '/33'),
        equals('Not Valid Subnetmask'),
      );
      expect(
        IPv4AddressManager.getNetworkAddress('192.168.1.1', 'invalid'),
        equals('Not Valid Subnetmask'),
      );
    });

    test('getBroadcastAddress returns error for invalid input', () {
      expect(
        IPv4AddressManager.getBroadcastAddress('abcd', '255.255.255.0'),
        equals('Not Valid IP address'),
      );
      expect(
        IPv4AddressManager.getBroadcastAddress('999.999.999.999', '/24'),
        equals('Not Valid IP address'),
      );
      expect(
        IPv4AddressManager.getBroadcastAddress('300.168.1.1', '255.255.255.0'),
        equals('Not Valid IP address'),
      );

      expect(
        IPv4AddressManager.getBroadcastAddress('192.168.1.10', '/'),
        equals('Not Valid Subnetmask'),
      );
      expect(
        IPv4AddressManager.getBroadcastAddress('192.168.1.1', '/33'),
        equals('Not Valid Subnetmask'),
      );
      expect(
        IPv4AddressManager.getBroadcastAddress('192.168.1.10', '/33'),
        equals('Not Valid Subnetmask'),
      );
      expect(
        IPv4AddressManager.getBroadcastAddress('192.168.1.1', 'invalid'),
        equals('Not Valid Subnetmask'),
      );
      expect(
        IPv4AddressManager.getBroadcastAddress('192.168.1.10', '255.0.255.0'),
        equals('Not Valid Subnetmask'),
      );
    });
  });
}
