import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Terminal Log Viewer',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const MainScreen(),
    );
  }
}

// Log entry model
class LogEntry {
  final String message;
  final DateTime timestamp;
  final LogType type;

  LogEntry({
    required this.message,
    required this.timestamp,
    required this.type,
  });
}

enum LogType { main, device }

// State classes
class TerminalState {
  final bool isOpen;
  final int selectedTabIndex;
  final List<LogEntry> mainLogs;
  final List<LogEntry> deviceLogs;

  TerminalState({
    required this.isOpen,
    required this.selectedTabIndex,
    required this.mainLogs,
    required this.deviceLogs,
  });

  TerminalState copyWith({
    bool? isOpen,
    int? selectedTabIndex,
    List<LogEntry>? mainLogs,
    List<LogEntry>? deviceLogs,
  }) {
    return TerminalState(
      isOpen: isOpen ?? this.isOpen,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      mainLogs: mainLogs ?? this.mainLogs,
      deviceLogs: deviceLogs ?? this.deviceLogs,
    );
  }
}

// Riverpod 3.0 Notifier
class TerminalNotifier extends Notifier<TerminalState> {
  @override
  TerminalState build() {
    return TerminalState(
      isOpen: false,
      selectedTabIndex: 0,
      mainLogs: [],
      deviceLogs: [],
    );
  }

  void toggleTerminal() {
    state = state.copyWith(isOpen: !state.isOpen);
  }

  void setTabIndex(int index) {
    state = state.copyWith(selectedTabIndex: index);
  }

  void addMainLog(String message) {
    final newLog = LogEntry(
      message: message,
      timestamp: DateTime.now(),
      type: LogType.main,
    );
    state = state.copyWith(mainLogs: [...state.mainLogs, newLog]);
  }

  void addDeviceLog(String message) {
    final newLog = LogEntry(
      message: message,
      timestamp: DateTime.now(),
      type: LogType.device,
    );
    state = state.copyWith(deviceLogs: [...state.deviceLogs, newLog]);
  }

  void clearMainLogs() {
    state = state.copyWith(mainLogs: []);
  }

  void clearDeviceLogs() {
    state = state.copyWith(deviceLogs: []);
  }

  void clearCurrentTabLogs() {
    if (state.selectedTabIndex == 0) {
      clearMainLogs();
    } else {
      clearDeviceLogs();
    }
  }
}

final terminalProvider = NotifierProvider<TerminalNotifier, TerminalState>(
  TerminalNotifier.new,
);

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Terminal Log Viewer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Stack(
        children: [
          // Main content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Demo App',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    ref.read(terminalProvider.notifier).toggleTerminal();
                  },
                  child: const Text('Toggle Terminal'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(terminalProvider.notifier)
                        .addMainLog(
                          'Main log entry: ${DateTime.now().millisecondsSinceEpoch}',
                        );
                  },
                  child: const Text('Add Main Log'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(terminalProvider.notifier)
                        .addDeviceLog(
                          'Device log entry: ${DateTime.now().millisecondsSinceEpoch}',
                        );
                  },
                  child: const Text('Add Device Log'),
                ),
              ],
            ),
          ),
          // Terminal overlay
          const MiniTerminal(),
        ],
      ),
    );
  }
}

class MiniTerminal extends ConsumerWidget {
  const MiniTerminal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final terminalState = ref.watch(terminalProvider);

    if (!terminalState.isOpen) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 20,
      right: 0,
      left: 0,
      child: DefaultTabController(
        length: 2,
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: 400,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // Terminal header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Terminal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          ref.read(terminalProvider.notifier).toggleTerminal();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
                // Tab bar
                Container(
                  color: Colors.grey[850],
                  child: TabBar(
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey[400],
                    indicatorColor: Theme.of(context).primaryColor,
                    tabs: const [
                      Tab(text: 'Main'),
                      Tab(text: 'Device'),
                    ],
                  ),
                ),
                // Terminal content with TabBarView
                Expanded(
                  child: Container(
                    color: Colors.black,
                    child: Column(
                      children: [
                        // Clear button
                        Container(
                          padding: const EdgeInsets.all(8),
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ref
                                  .read(terminalProvider.notifier)
                                  .clearCurrentTabLogs();
                            },
                            icon: const Icon(Icons.clear, size: 16),
                            label: const Text('Clear'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[700],
                              foregroundColor: Colors.white,
                              minimumSize: const Size(80, 30),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                            ),
                          ),
                        ),
                        // TabBarView for log content
                        Expanded(
                          child: TabBarView(
                            children: [
                              // Main logs tab
                              _buildLogView(terminalState.mainLogs),
                              // Device logs tab
                              _buildLogView(terminalState.deviceLogs),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogView(List<LogEntry> logs) {
    return SingleChildScrollView(
      reverse: true,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: logs.map((log) {
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
        }).toList(),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:'
        '${time.second.toString().padLeft(2, '0')}';
  }
}
