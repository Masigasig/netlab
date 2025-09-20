import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MaterialApp(home: SimulationDemo())));
}

// Simple Simulation Clock
class SimulationClock {
  Duration _elapsed = Duration.zero;
  DateTime? _lastStartTime;
  bool _isRunning = false;

  Duration get now {
    if (_isRunning && _lastStartTime != null) {
      return _elapsed + DateTime.now().difference(_lastStartTime!);
    }
    return _elapsed;
  }

  void start() {
    if (!_isRunning) {
      _lastStartTime = DateTime.now();
      _isRunning = true;
    }
  }

  void pause() {
    if (_isRunning && _lastStartTime != null) {
      _elapsed = _elapsed + DateTime.now().difference(_lastStartTime!);
      _isRunning = false;
      _lastStartTime = null;
    }
  }

  void reset() {
    _elapsed = Duration.zero;
    _lastStartTime = null;
    _isRunning = false;
  }

  bool get isRunning => _isRunning;
}

// Simple Message
class Message {
  final String id;
  final Duration startTime;
  final Duration duration;

  Message(this.id, this.startTime, this.duration);

  double getProgress(Duration currentTime) {
    if (currentTime < startTime) return 0.0;
    final elapsed = currentTime - startTime;
    if (elapsed >= duration) return 1.0;
    return elapsed.inMilliseconds / duration.inMilliseconds;
  }

  bool isCompleted(Duration currentTime) {
    return getProgress(currentTime) >= 1.0;
  }
}

class SimulationDemo extends StatefulWidget {
  const SimulationDemo({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SimulationDemoState createState() => _SimulationDemoState();
}

class _SimulationDemoState extends State<SimulationDemo>
    with TickerProviderStateMixin {
  final SimulationClock clock = SimulationClock();
  late AnimationController _refreshController;
  final List<Message> messages = [];
  int _messageCounter = 0;

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    );
    _refreshController.repeat();
    _refreshController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = Message(
      'msg_${++_messageCounter}',
      clock.now,
      const Duration(seconds: 3),
    );

    setState(() {
      messages.add(message);
    });
  }

  void _clearMessages() {
    setState(() {
      messages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simulation Clock Demo')),
      body: Column(
        children: [
          // Controls
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Time: ${clock.now.toString().substring(0, 7)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: clock.isRunning ? null : clock.start,
                      child: const Text('Start'),
                    ),
                    ElevatedButton(
                      onPressed: !clock.isRunning ? null : clock.pause,
                      child: const Text('Pause'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        clock.reset();
                        setState(() => messages.clear());
                      },
                      child: const Text('Reset'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _sendMessage,
                      child: const Text('Send Message'),
                    ),
                    ElevatedButton(
                      onPressed: messages.isEmpty ? null : _clearMessages,
                      child: const Text('Clear Messages'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Simulation Area
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey[100],
              child: Stack(
                children: [
                  // Host A
                  Positioned(
                    left: 50,
                    top: 100,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'A',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Host B
                  Positioned(
                    right: 50,
                    top: 100,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'B',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Messages
                  ...messages.map((message) {
                    final progress = message.getProgress(clock.now);
                    final x =
                        50 +
                        (MediaQuery.of(context).size.width - 150) * progress;
                    final isCompleted = message.isCompleted(clock.now);

                    return Positioned(
                      left: x - 15,
                      top: 85,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: isCompleted ? Colors.grey : Colors.orange,
                          shape: BoxShape.circle,
                          border: isCompleted
                              ? Border.all(color: Colors.green, width: 2)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            message.id.split('_').last,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

                  // Info
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status: ${clock.isRunning ? "Running" : "Paused"}',
                          style: TextStyle(
                            fontSize: 16,
                            color: clock.isRunning ? Colors.green : Colors.red,
                          ),
                        ),
                        Text('Messages: ${messages.length}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
