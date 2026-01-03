import 'dart:math' show Random;

class MacAddressManager {
  static final Set<String> macStorage = {};

  static const broadcastMacAddress = 'FF:FF:FF:FF:FF:FF';
  static const unknownMacAddress = '00:00:00:00:00:00';

  static bool removeMac(String mac) => macStorage.remove(mac);

  static String generateMacAddress() {
    final rng = Random();
    String mac;

    do {
      mac = List.generate(6, (_) {
        int byte = rng.nextInt(256);
        return byte.toRadixString(16).padLeft(2, '0');
      }).join(':').toUpperCase();
    } while (macStorage.contains(mac) ||
        mac == broadcastMacAddress ||
        mac == unknownMacAddress ||
        !isValid(mac));

    macStorage.add(mac);
    return mac;
  }

  static bool isValid(String mac) {
    final parts = mac.split(':');
    if (parts.length != 6) return false;
    for (final part in parts) {
      if (part.length != 2) return false;
      final value = int.tryParse(part, radix: 16);
      if (value == null) return false;
    }
    return true;
  }

  static void clearStorage() {
    macStorage.clear();
  }

  static Map<String, dynamic> exportStorage() {
    return {'macAddresses': macStorage.toList()};
  }

  static void importStorage(Map<String, dynamic> data) {
    final macList = data['macAddresses'];
    if (macList is List) {
      macStorage
        ..clear()
        ..addAll(macList.whereType<String>());
    }
  }
}
