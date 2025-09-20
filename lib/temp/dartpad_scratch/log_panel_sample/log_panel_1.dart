import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

class LogEntry {
  final DateTime timestamp;
  final String message;
  final LogType type;

  LogEntry(this.message, {this.type = LogType.main})
    : timestamp = DateTime.now();
}

enum LogType { main, secondary }

class LogNotifier extends Notifier<List<LogEntry>> {
  final List<LogEntry> _logs = [];

  @override
  List<LogEntry> build() => const [];

  void addLog(String message) {
    _logs.add(
      LogEntry(
        message,
        type: _logs.length % 2 == 0 ? LogType.main : LogType.secondary,
      ),
    );
    state = List.unmodifiable(_logs);
  }

  void clearLogs() {
    _logs.clear();
    state = const [];
  }
}

final logProvider = NotifierProvider<LogNotifier, List<LogEntry>>(
  LogNotifier.new,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: LogScreen());
  }
}

class LogScreen extends ConsumerStatefulWidget {
  const LogScreen({super.key});

  @override
  ConsumerState<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends ConsumerState<LogScreen> {
  final ScrollController _scrollController = ScrollController();

  bool _isAtBottom() {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return (maxScroll - currentScroll) < 50;
  }

  void _scrollIfNeeded() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && _isAtBottom()) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _addLog() {
    ref.read(logProvider.notifier).addLog('Log message');
    _scrollIfNeeded();
  }

  void _clearLogs() {
    ref.read(logProvider.notifier).clearLogs();
  }

  String _formatTime(DateTime time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final logs = ref.watch(logProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Terminal Logs'),
        actions: [
          IconButton(icon: const Icon(Icons.delete), onPressed: _clearLogs),
        ],
      ),
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(8),
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '[${_formatTime(log.timestamp)}] ${log.message}',
              style: TextStyle(
                color: log.type == LogType.main
                    ? Colors.green[400]
                    : Colors.cyan[400],
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addLog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
