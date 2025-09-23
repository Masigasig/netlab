import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

// 🧠 Stopwatch Notifier
class StopwatchNotifier extends StateNotifier<Duration> {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  Duration? _savedTime;

  StopwatchNotifier() : super(Duration.zero);

  void start() {
    if (_timer != null) return;
    _timer = Timer.periodic(const Duration(milliseconds: 10), (_) {
      _elapsed += const Duration(milliseconds: 10);
      state = _elapsed;
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void reset() {
    stop();
    _elapsed = Duration.zero;
    _savedTime = null;
    state = _elapsed;
  }

  void saveNow() {
    _savedTime = _elapsed;
  }

  Duration? get savedTime => _savedTime;
  Duration get elapsed => _elapsed;
}

// 📦 Riverpod Provider
final stopwatchProvider = StateNotifierProvider<StopwatchNotifier, Duration>((
  ref,
) {
  return StopwatchNotifier();
});

// 🖼 UI
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Stopwatch',
      home: Scaffold(
        appBar: AppBar(title: const Text('Riverpod Stopwatch')),
        body: const StopwatchView(),
      ),
    );
  }
}

class StopwatchView extends ConsumerWidget {
  const StopwatchView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final elapsed = ref.watch(stopwatchProvider);
    final stopwatch = ref.read(stopwatchProvider.notifier);
    final saved = stopwatch.savedTime;

    String format(Duration d) {
      final ms = (d.inMilliseconds % 1000).toString().padLeft(3, '0');
      final s = (d.inSeconds % 60).toString().padLeft(2, '0');
      final m = (d.inMinutes % 60).toString().padLeft(2, '0');
      final h = d.inHours.toString().padLeft(2, '0');
      return '$h:$m:$s.$ms';
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Elapsed: ${format(elapsed)}',
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 12),
          if (saved != null)
            Text(
              'Saved: ${format(saved)}',
              style: const TextStyle(fontSize: 20),
            ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: stopwatch.start,
            child: const Text('Start'),
          ),
          ElevatedButton(onPressed: stopwatch.stop, child: const Text('Stop')),
          ElevatedButton(
            onPressed: stopwatch.reset,
            child: const Text('Reset'),
          ),
          ElevatedButton(
            onPressed: stopwatch.saveNow,
            child: const Text('Save Time'),
          ),
          const SizedBox(height: 12),
          if (saved != null)
            Text(
              'Diff: ${format(elapsed - saved)}',
              style: const TextStyle(fontSize: 18, color: Colors.blue),
            ),
        ],
      ),
    );
  }
}
