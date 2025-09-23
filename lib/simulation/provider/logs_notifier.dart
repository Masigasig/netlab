import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netlab/simulation/model/log_entry.dart';

final simObjectLogProvider =
    NotifierProvider.family<SimObjectLogNotifier, List<LogEntry>, String>(
      SimObjectLogNotifier.new,
    );

final systemLogProvider = NotifierProvider<SystemLogNotifier, List<LogEntry>>(
  SystemLogNotifier.new,
);

class SimObjectLogNotifier extends Notifier<List<LogEntry>> {
  final String simObjId;
  SimObjectLogNotifier(this.simObjId);

  final List<String> _logs = [];

  @override
  List<LogEntry> build() {
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

class SystemLogNotifier extends Notifier<List<LogEntry>> {
  final List<String> _logs = [];

  @override
  List<LogEntry> build() {
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
