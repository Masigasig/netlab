import 'package:flutter_test/flutter_test.dart';
import 'package:netlab/home/simulation/core/mac_address_manager.dart';

void main() {
  test('generateUniqueMacAddress returns a valid and unique MAC', () {
    final mac = MacAddressManager.generateMacAddress();

    expect(MacAddressManager.isValid(mac), isTrue);
    expect(mac, isNot(equals(MacAddressManager.broadcastMacAddress)));
    expect(mac, isNot(equals(MacAddressManager.unknownMacAddress)));
    expect(MacAddressManager.macStorage.contains(mac), isTrue);
  });

  test('remove returns true when MAC is removed', () {
    final mac = MacAddressManager.generateMacAddress();
    final result = MacAddressManager.removeMac(mac);

    expect(result, isTrue);
    expect(MacAddressManager.macStorage.contains(mac), isFalse);
  });

  test('remove returns false when MAC does not exist', () {
    final result = MacAddressManager.removeMac('AA:BB:CC:DD:EE:FF');
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
}
