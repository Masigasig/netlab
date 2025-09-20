import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final simObjectLogProvider =
    NotifierProvider.family<SimObjectLogNotifier, List<String>, String>(
      SimObjectLogNotifier.new,
    );

class SimObjectLogNotifier extends Notifier<List<String>> {
  final String simId;
  SimObjectLogNotifier(this.simId);

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
    if (_logs.isNotEmpty) {
      _logs.clear();
      state = const [];
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Sim Log Test', home: SimManagerScreen());
  }
}

/// Screen to manage multiple simIds
class SimManagerScreen extends ConsumerStatefulWidget {
  const SimManagerScreen({super.key});

  @override
  ConsumerState<SimManagerScreen> createState() => _SimManagerScreenState();
}

class _SimManagerScreenState extends ConsumerState<SimManagerScreen> {
  final List<String> simIds = ['sim123'];

  void _spawnNewSim() {
    final newId = 'sim${DateTime.now().millisecondsSinceEpoch}';
    setState(() {
      simIds.add(newId);
    });
  }

  void _invalidateSim(String simId) {
    ref.invalidate(simObjectLogProvider(simId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sim Manager"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Invalidate ALL",
            onPressed: () {
              ref.invalidate(
                simObjectLogProvider,
              ); // clears ALL family instances
            },
          ),
        ],
      ),

      body: ListView.builder(
        itemCount: simIds.length,
        itemBuilder: (context, index) {
          final simId = simIds[index];
          return ListTile(
            title: Text("Sim ID: $simId"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.open_in_new),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SimLogScreen(simId: simId),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () => _invalidateSim(simId),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _spawnNewSim,
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Individual log screen
class SimLogScreen extends ConsumerWidget {
  final String simId;
  const SimLogScreen({super.key, required this.simId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(simObjectLogProvider(simId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Logs for $simId'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ref.read(simObjectLogProvider(simId).notifier).clearLogs();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: logs.length,
        itemBuilder: (context, index) => ListTile(title: Text(logs[index])),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final timestamp = DateTime.now().toIso8601String();
          ref
              .read(simObjectLogProvider(simId).notifier)
              .addLog('Log at $timestamp');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
