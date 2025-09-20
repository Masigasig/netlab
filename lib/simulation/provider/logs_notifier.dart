import 'package:flutter_riverpod/flutter_riverpod.dart';

final simObjectLogProvider =
    NotifierProvider.family<SimObjectLogNotifier, List<String>, String>(
      SimObjectLogNotifier.new,
    );

final systemLogProvider = NotifierProvider<SystemLogNotifier, List<String>>(
  SystemLogNotifier.new,
);

class SimObjectLogNotifier extends Notifier<List<String>> {
  final String simObjId;
  SimObjectLogNotifier(this.simObjId);

  final List<String> _logs = [];

  @override
  List<String> build() {
    ref.onDispose(() {
      _logs.clear();
    });
    return const [];
  }

  void addLog(String message) {
    _logs.add(message);
    state = List.unmodifiable(_logs);
  }

  void clearLogs() {
    _logs.clear();
    state = const [];
  }
}

class SystemLogNotifier extends Notifier<List<String>> {
  final List<String> _logs = [];

  @override
  List<String> build() {
    ref.onDispose(() {
      _logs.clear();
    });
    return const [];
  }

  void addLog(String message) {
    _logs.add(message);
    state = List.unmodifiable(_logs);
  }

  void clearLogs() {
    _logs.clear();
    state = const [];
  }
}
