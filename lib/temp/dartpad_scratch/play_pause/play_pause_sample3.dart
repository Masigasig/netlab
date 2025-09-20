import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'dart:math';

void main() {
  runApp(const ProviderScope(child: MaterialApp(home: SimulationDemo())));
}

// Simulation Clock
class SimulationClock {
  final Duration elapsed;
  final DateTime? lastStartTime;
  final bool isRunning;

  const SimulationClock({
    this.elapsed = Duration.zero,
    this.lastStartTime,
    this.isRunning = false,
  });

  Duration get now {
    if (isRunning && lastStartTime != null) {
      return elapsed + DateTime.now().difference(lastStartTime!);
    }
    return elapsed;
  }

  SimulationClock start() {
    if (!isRunning) {
      return SimulationClock(
        elapsed: elapsed,
        lastStartTime: DateTime.now(),
        isRunning: true,
      );
    }
    return this;
  }

  SimulationClock pause() {
    if (isRunning && lastStartTime != null) {
      return SimulationClock(
        elapsed: elapsed + DateTime.now().difference(lastStartTime!),
        lastStartTime: null,
        isRunning: false,
      );
    }
    return this;
  }

  SimulationClock reset() {
    return const SimulationClock();
  }
}

// Riverpod 3.0 Notifier classes
class SimulationClockNotifier extends Notifier<SimulationClock> {
  @override
  SimulationClock build() => const SimulationClock();

  void start() => state = state.start();
  void pause() => state = state.pause();
  void reset() => state = state.reset();
}

class MessagesNotifier extends Notifier<List<MessageData>> {
  @override
  List<MessageData> build() => [];

  void addMessage(MessageData message) {
    state = [...state, message];
  }

  void removeMessage(String messageId) {
    state = state.where((m) => m.id != messageId).toList();
  }

  void clear() {
    state = [];
  }
}

// Providers using Riverpod 3.0 syntax
final simulationClockProvider =
    NotifierProvider<SimulationClockNotifier, SimulationClock>(
      () => SimulationClockNotifier(),
    );

final messagesProvider = NotifierProvider<MessagesNotifier, List<MessageData>>(
  () => MessagesNotifier(),
);

final networkDevicesProvider = Provider<List<NetworkDevice>>((ref) {
  return const [
    NetworkDevice(
      id: 'hostA',
      name: 'Host A',
      position: Offset(100, 50),
      color: Colors.blue,
      icon: Icons.computer,
    ),
    NetworkDevice(
      id: 'router',
      name: 'Router',
      position: Offset(200, 200),
      color: Colors.red,
      icon: Icons.router,
    ),
    NetworkDevice(
      id: 'hostB',
      name: 'Host B',
      position: Offset(350, 100),
      color: Colors.green,
      icon: Icons.computer,
    ),
    NetworkDevice(
      id: 'hostC',
      name: 'Host C',
      position: Offset(300, 300),
      color: Colors.purple,
      icon: Icons.computer,
    ),
  ];
});

// Network Device
class NetworkDevice {
  final String id;
  final String name;
  final Offset position;
  final Color color;
  final IconData icon;

  const NetworkDevice({
    required this.id,
    required this.name,
    required this.position,
    required this.color,
    this.icon = Icons.computer,
  });
}

// Message Data Model
class MessageData {
  final String id;
  final Duration startTime;
  final Duration duration;
  final Offset startPosition;
  final Offset endPosition;

  const MessageData({
    required this.id,
    required this.startTime,
    required this.duration,
    required this.startPosition,
    required this.endPosition,
  });

  double getProgress(Duration currentTime) {
    if (currentTime < startTime) return 0.0;
    final elapsed = currentTime - startTime;
    if (elapsed >= duration) return 1.0;
    return elapsed.inMilliseconds / duration.inMilliseconds;
  }

  Offset getCurrentPosition(Duration currentTime) {
    final progress = getProgress(currentTime);
    return Offset.lerp(startPosition, endPosition, progress)!;
  }

  bool isCompleted(Duration currentTime) {
    return getProgress(currentTime) >= 1.0;
  }
}

// Individual Message Widget with its own AnimationController
class MessageWidget extends ConsumerStatefulWidget {
  final MessageData messageData;

  const MessageWidget({super.key, required this.messageData});

  @override
  ConsumerState<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends ConsumerState<MessageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: widget.messageData.duration,
      vsync: this,
    );

    _positionAnimation =
        Tween<Offset>(
          begin: widget.messageData.startPosition,
          end: widget.messageData.endPosition,
        ).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.linear),
        );

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clock = ref.watch(simulationClockProvider);

    // Control animation based on clock state
    if (clock.isRunning &&
        !_animationController.isAnimating &&
        _animationController.value < 1.0) {
      _animationController.forward();
    } else if (!clock.isRunning && _animationController.isAnimating) {
      _animationController.stop();
    }

    return AnimatedBuilder(
      animation: _positionAnimation,
      builder: (context, child) {
        final currentPos = _positionAnimation.value;
        final isCompleted = _animationController.isCompleted;

        return Positioned(
          left: currentPos.dx - 15,
          top: currentPos.dy - 15,
          child: GestureDetector(
            onTap: () {
              // print('Tapped message: ${widget.messageData.id}');
              // You can add message-specific logic here
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.grey : Colors.orange,
                shape: BoxShape.circle,
                border: isCompleted
                    ? Border.all(color: Colors.green, width: 2)
                    : null,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 2,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  widget.messageData.id.split('_').last,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Main Simulation Demo
class SimulationDemo extends ConsumerStatefulWidget {
  const SimulationDemo({super.key});

  @override
  ConsumerState<SimulationDemo> createState() => _SimulationDemoState();
}

class _SimulationDemoState extends ConsumerState<SimulationDemo> {
  int _messageCounter = 0;

  void _sendMessage(String fromId, String toId) {
    final devices = ref.read(networkDevicesProvider);
    final fromDevice = devices.firstWhere((d) => d.id == fromId);
    final toDevice = devices.firstWhere((d) => d.id == toId);
    final clock = ref.read(simulationClockProvider);

    final message = MessageData(
      id: 'msg_${++_messageCounter}',
      startTime: clock.now,
      duration: const Duration(seconds: 3),
      startPosition: fromDevice.position,
      endPosition: toDevice.position,
    );

    ref.read(messagesProvider.notifier).addMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    final clock = ref.watch(simulationClockProvider);
    final messages = ref.watch(messagesProvider);
    final devices = ref.watch(networkDevicesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Modular Network Simulation')),
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
                      onPressed: clock.isRunning
                          ? null
                          : () {
                              ref
                                  .read(simulationClockProvider.notifier)
                                  .start();
                            },
                      child: const Text('Start'),
                    ),
                    ElevatedButton(
                      onPressed: !clock.isRunning
                          ? null
                          : () {
                              ref
                                  .read(simulationClockProvider.notifier)
                                  .pause();
                            },
                      child: const Text('Pause'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(simulationClockProvider.notifier).reset();
                        ref.read(messagesProvider.notifier).clear();
                      },
                      child: const Text('Reset'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () => _sendMessage('hostA', 'router'),
                      child: const Text('A → Router'),
                    ),
                    ElevatedButton(
                      onPressed: () => _sendMessage('router', 'hostB'),
                      child: const Text('Router → B'),
                    ),
                    ElevatedButton(
                      onPressed: () => _sendMessage('hostA', 'hostB'),
                      child: const Text('A → B'),
                    ),
                    ElevatedButton(
                      onPressed: () => _sendMessage('router', 'hostC'),
                      child: const Text('Router → C'),
                    ),
                    ElevatedButton(
                      onPressed: messages.isEmpty
                          ? null
                          : () {
                              ref.read(messagesProvider.notifier).clear();
                            },
                      child: const Text('Clear'),
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
                  // Network connections
                  CustomPaint(
                    size: Size.infinite,
                    painter: NetworkConnectionsPainter(devices),
                  ),

                  // Network Devices
                  ...devices.map(
                    (device) => Positioned(
                      left: device.position.dx - 25,
                      top: device.position.dy - 25,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: device.color,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              device.icon,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            device.name,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Messages - each is its own widget!
                  ...messages.map(
                    (message) => MessageWidget(
                      key: ValueKey(message.id),
                      messageData: message,
                    ),
                  ),

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
                        Text('Devices: ${devices.length}'),
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

// Custom painter for network connections
class NetworkConnectionsPainter extends CustomPainter {
  final List<NetworkDevice> devices;

  NetworkConnectionsPainter(this.devices);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black26
      ..strokeWidth = 2;

    final router = devices.firstWhere((d) => d.id == 'router');
    final hosts = devices.where((d) => d.id != 'router').toList();

    for (final host in hosts) {
      canvas.drawLine(router.position, host.position, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
