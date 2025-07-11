import 'package:flutter_riverpod/flutter_riverpod.dart';

final wireModeProvider = StateNotifierProvider<WireModeNotifier, bool>(
  (ref) => WireModeNotifier(),
);

class WireModeNotifier extends StateNotifier<bool> {
  WireModeNotifier() : super(false);

  final List<String> _selectedDevices = [];

  bool get isWireModeEnabled => state;
  List<String> get selectedDevices => List.unmodifiable(_selectedDevices);

  void toggle() => state = !state;

  void addDevice(String deviceId) {
    if (!_selectedDevices.contains(deviceId) && _selectedDevices.length < 2) {
      _selectedDevices.add(deviceId);
    }
  }

  void clearDevices() {
    _selectedDevices.clear();
  }
}