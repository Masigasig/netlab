import 'dart:math' show Random;

class MacAddressManager {
  static final Set<String> _macStorage = {};

  static const broadcastMacAddress = 'FF:FF:FF:FF:FF:FF';
  static const unknownMacAddress = '00:00:00:00:00:00';

  static bool removeMac(String mac) => _macStorage.remove(mac);

  static String generateMacAddress() {
    final rng = Random();
    String mac;

    do {
      mac = List.generate(6, (_) {
        int byte = rng.nextInt(256);
        return byte.toRadixString(16).padLeft(2, '0');
      }).join(':').toUpperCase();
    } while (_macStorage.contains(mac) ||
        mac == broadcastMacAddress ||
        mac == unknownMacAddress ||
        !_isValid(mac));

    _macStorage.add(mac);
    return mac;
  }

  static bool _isValid(String mac) {
    final regex = RegExp(r'^([0-9A-F]{2}:){5}[0-9A-F]{2}$');
    return regex.hasMatch(mac);
  }

  static void clearStorage() {
    _macStorage.clear();
  }

  static Map<String, dynamic> exportStorage() {
    return {'macAddresses': _macStorage.toList()};
  }

  static void importStorage(Map<String, dynamic> data) {
    final macList = data['macAddresses'];
    if (macList is List) {
      _macStorage
        ..clear()
        ..addAll(macList.whereType<String>());
    }
  }
}
