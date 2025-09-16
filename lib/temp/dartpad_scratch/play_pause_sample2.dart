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

// Network Device (Host, Router, etc.)
class NetworkDevice {
  final String id;
  final String name;
  final Offset position;
  final Color color;
  final IconData icon;

  NetworkDevice({
    required this.id,
    required this.name,
    required this.position,
    required this.color,
    this.icon = Icons.computer,
  });
}

// Message with start/end positions
class Message {
  final String id;
  final Duration startTime;
  final Duration duration;
  final Offset startPosition;
  final Offset endPosition;

  Message({
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

  // Network topology - you can easily modify these positions
  late List<NetworkDevice> devices;

  @override
  void initState() {
    super.initState();

    // Define your network topology here
    devices = [
      NetworkDevice(
        id: 'hostA',
        name: 'Host A',
        position: const Offset(100, 50),
        color: Colors.blue,
        icon: Icons.computer,
      ),
      NetworkDevice(
        id: 'router',
        name: 'Router',
        position: const Offset(200, 200),
        color: Colors.red,
        icon: Icons.router,
      ),
      NetworkDevice(
        id: 'hostB',
        name: 'Host B',
        position: const Offset(350, 100),
        color: Colors.green,
        icon: Icons.computer,
      ),
      NetworkDevice(
        id: 'hostC',
        name: 'Host C',
        position: const Offset(300, 300),
        color: Colors.purple,
        icon: Icons.computer,
      ),
    ];

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

  void _sendMessage(String fromId, String toId) {
    final fromDevice = devices.firstWhere((d) => d.id == fromId);
    final toDevice = devices.firstWhere((d) => d.id == toId);

    final message = Message(
      id: 'msg_${++_messageCounter}',
      startTime: clock.now,
      duration: const Duration(seconds: 3),
      startPosition: fromDevice.position,
      endPosition: toDevice.position,
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
      appBar: AppBar(title: const Text('Network Simulation')),
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
                // Message sending buttons
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
                      onPressed: messages.isEmpty ? null : _clearMessages,
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
                  // Draw connections (optional - shows network topology)
                  CustomPaint(
                    size: Size.infinite,
                    painter: NetworkConnectionsPainter(devices),
                  ),

                  // Network Devices
                  ...devices.map(
                    (device) => Positioned(
                      left: device.position.dx - 25,
                      top: device.position.dy - 25,
                      child: GestureDetector(
                        // ignore: avoid_print
                        onTap: () => print('Tapped ${device.name}'),
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
                  ),

                  // Messages
                  ...messages.map((message) {
                    final currentPos = message.getCurrentPosition(clock.now);
                    final isCompleted = message.isCompleted(clock.now);

                    return Positioned(
                      left: currentPos.dx - 15,
                      top: currentPos.dy - 15,
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

// Custom painter to draw network connections
class NetworkConnectionsPainter extends CustomPainter {
  final List<NetworkDevice> devices;

  NetworkConnectionsPainter(this.devices);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black26
      ..strokeWidth = 2;

    // Draw connections between router and hosts
    final router = devices.firstWhere((d) => d.id == 'router');
    final hosts = devices.where((d) => d.id != 'router').toList();

    for (final host in hosts) {
      canvas.drawLine(router.position, host.position, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
