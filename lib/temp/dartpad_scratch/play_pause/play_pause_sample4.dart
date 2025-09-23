import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Clock Timer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ClockScreen(),
    );
  }
}

// Custom Clock State
class ClockState {
  final double currentTime; // in seconds
  final bool isRunning;
  final double speed; // playback speed multiplier

  const ClockState({
    required this.currentTime,
    required this.isRunning,
    required this.speed,
  });

  ClockState copyWith({double? currentTime, bool? isRunning, double? speed}) {
    return ClockState(
      currentTime: currentTime ?? this.currentTime,
      isRunning: isRunning ?? this.isRunning,
      speed: speed ?? this.speed,
    );
  }
}

// Animation Data Class
class AnimatedObjectState {
  final String id;
  final Offset startPosition;
  final Offset endPosition;
  final double speed; // pixels per second
  final Color color;
  final double size;
  final double startTime; // when this animation started
  final bool isActive; // whether this animation is currently active

  const AnimatedObjectState({
    required this.id,
    required this.startPosition,
    required this.endPosition,
    required this.speed,
    required this.color,
    this.size = 30.0,
    this.startTime = 0.0,
    this.isActive = true,
  });

  AnimatedObjectState copyWith({
    String? id,
    Offset? startPosition,
    Offset? endPosition,
    double? speed,
    Color? color,
    double? size,
    double? startTime,
    bool? isActive,
  }) {
    return AnimatedObjectState(
      id: id ?? this.id,
      startPosition: startPosition ?? this.startPosition,
      endPosition: endPosition ?? this.endPosition,
      speed: speed ?? this.speed,
      color: color ?? this.color,
      size: size ?? this.size,
      startTime: startTime ?? this.startTime,
      isActive: isActive ?? this.isActive,
    );
  }

  // Calculate distance between start and end points
  double get distance {
    final dx = endPosition.dx - startPosition.dx;
    final dy = endPosition.dy - startPosition.dy;
    return sqrt(dx * dx + dy * dy);
  }

  // Calculate duration based on distance and speed
  double get duration {
    if (speed <= 0) return double.infinity;
    return distance / speed;
  }

  Offset getPositionAtTime(double globalTime) {
    if (!isActive) return endPosition;

    double animationTime = globalTime - startTime;
    if (animationTime < 0) return startPosition;

    double progress = (animationTime / duration).clamp(0.0, 1.0);

    return Offset(
      startPosition.dx + (endPosition.dx - startPosition.dx) * progress,
      startPosition.dy + (endPosition.dy - startPosition.dy) * progress,
    );
  }

  bool isCompleted(double globalTime) {
    if (!isActive) return true;
    return (globalTime - startTime) >= duration;
  }

  double getProgress(double globalTime) {
    if (!isActive) return 1.0;
    double animationTime = globalTime - startTime;
    return (animationTime / duration).clamp(0.0, 1.0);
  }
}

// Clock Controller
class ClockController extends StateNotifier<ClockState> {
  ClockController()
    : super(const ClockState(currentTime: 0, isRunning: false, speed: 1.0));

  void play() {
    state = state.copyWith(isRunning: true);
  }

  void pause() {
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    state = const ClockState(currentTime: 0, isRunning: false, speed: 1.0);
  }

  void setSpeed(double speed) {
    state = state.copyWith(speed: speed);
  }

  void seekTo(double time) {
    state = state.copyWith(currentTime: time);
  }

  void tick(double deltaTime) {
    if (state.isRunning) {
      state = state.copyWith(
        currentTime: state.currentTime + (deltaTime * state.speed),
      );
    }
  }
}

// Individual Animated Object Controller
class AnimatedObjectController extends StateNotifier<AnimatedObjectState> {
  AnimatedObjectController(super.initialState);

  void updateDestination(
    Offset newStart,
    Offset newEnd,
    double speed, {
    double? startTime,
  }) {
    state = state.copyWith(
      startPosition: newStart,
      endPosition: newEnd,
      speed: speed,
      startTime: startTime ?? state.startTime,
      isActive: true,
    );
  }

  void updateSpeed(double newSpeed) {
    state = state.copyWith(speed: newSpeed);
  }

  void deactivate() {
    state = state.copyWith(isActive: false);
  }

  void activate() {
    state = state.copyWith(isActive: true);
  }
}

// Providers
final clockProvider = StateNotifierProvider<ClockController, ClockState>((ref) {
  return ClockController();
});

final animatedObjectProvider =
    StateNotifierProvider.family<
      AnimatedObjectController,
      AnimatedObjectState,
      String
    >((ref, id) {
      // Default object states - you can customize these or load from configuration
      final defaultObjects = {
        'circle1': const AnimatedObjectState(
          id: 'circle1',
          startPosition: Offset(50, 100),
          endPosition: Offset(300, 100),
          speed: 80.0, // pixels per second
          color: Colors.red,
          size: 25,
        ),
        'circle2': const AnimatedObjectState(
          id: 'circle2',
          startPosition: Offset(50, 200),
          endPosition: Offset(350, 300),
          speed: 60.0, // slower speed for longer distance
          color: Colors.blue,
          size: 35,
        ),
        'circle3': const AnimatedObjectState(
          id: 'circle3',
          startPosition: Offset(100, 300),
          endPosition: Offset(200, 150),
          speed: 120.0, // faster speed for shorter distance
          color: Colors.green,
          size: 20,
        ),
        'square1': const AnimatedObjectState(
          id: 'square1',
          startPosition: Offset(300, 400),
          endPosition: Offset(100, 250),
          speed: 40.0, // very slow speed
          color: Colors.purple,
          size: 40,
        ),
      };

      return AnimatedObjectController(defaultObjects[id]!);
    });

// Individual Animated Object Widget
class AnimatedObjectWidget extends ConsumerWidget {
  final String objectId;

  const AnimatedObjectWidget({super.key, required this.objectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final objectState = ref.watch(animatedObjectProvider(objectId));
    final clockState = ref.watch(clockProvider);

    if (!objectState.isActive) return const SizedBox.shrink();

    final position = objectState.getPositionAtTime(clockState.currentTime);
    final isCompleted = objectState.isCompleted(clockState.currentTime);

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 16),
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onTap: () {
          // You can add interaction here - like clicking to send to new destination
          // ignore: avoid_print
          print('Clicked on ${objectState.id}');
        },
        child: Container(
          width: objectState.size,
          height: objectState.size,
          decoration: BoxDecoration(
            color: isCompleted
                // ignore: deprecated_member_use
                ? objectState.color.withOpacity(0.6)
                : objectState.color,
            shape: objectState.id.contains('circle')
                ? BoxShape.circle
                : BoxShape.rectangle,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
            border: isCompleted
                ? Border.all(color: Colors.green, width: 2)
                : null,
          ),
          child: Center(
            child: isCompleted
                ? Icon(
                    Icons.check,
                    color: Colors.white,
                    size: objectState.size * 0.6,
                  )
                : Text(
                    objectState.id.substring(objectState.id.length - 1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// Object Status Widget
class ObjectStatusWidget extends ConsumerWidget {
  final String objectId;

  const ObjectStatusWidget({super.key, required this.objectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final objectState = ref.watch(animatedObjectProvider(objectId));
    final clockState = ref.watch(clockProvider);

    final progress = objectState.getProgress(clockState.currentTime);
    final isCompleted = objectState.isCompleted(clockState.currentTime);
    final distance = objectState.distance;
    final estimatedTime = objectState.duration;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: objectState.color,
                  shape: objectState.id.contains('circle')
                      ? BoxShape.circle
                      : BoxShape.rectangle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${objectState.id}: ${isCompleted ? "COMPLETED" : "${(progress * 100).toStringAsFixed(1)}%"}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Distance: ${distance.toStringAsFixed(1)}px | Speed: ${objectState.speed.toStringAsFixed(0)}px/s | ETA: ${estimatedTime.toStringAsFixed(2)}s',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              if (isCompleted)
                const Icon(Icons.check_circle, color: Colors.green, size: 16),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const SizedBox(width: 30),
              Expanded(
                child: Row(
                  children: [
                    const Text('Speed: ', style: TextStyle(fontSize: 12)),
                    Expanded(
                      child: Slider(
                        value: objectState.speed,
                        min: 10.0,
                        max: 200.0,
                        divisions: 38,
                        label: '${objectState.speed.toStringAsFixed(0)}px/s',
                        onChanged: (value) {
                          ref
                              .read(animatedObjectProvider(objectId).notifier)
                              .updateSpeed(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  // Example: Send to new random destination with current speed
                  final random = DateTime.now().millisecondsSinceEpoch;
                  final newDestination = Offset(
                    50 + (random % 300).toDouble(),
                    100 + (random % 200).toDouble(),
                  );
                  ref
                      .read(animatedObjectProvider(objectId).notifier)
                      .updateDestination(
                        objectState.getPositionAtTime(clockState.currentTime),
                        newDestination,
                        objectState.speed, // use current speed
                        startTime: clockState.currentTime,
                      );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  minimumSize: const Size(60, 30),
                ),
                child: const Text('Send', style: TextStyle(fontSize: 10)),
              ),
            ],
          ),
          const Divider(height: 8),
        ],
      ),
    );
  }
}

class ClockScreen extends ConsumerStatefulWidget {
  const ClockScreen({super.key});

  @override
  ConsumerState<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends ConsumerState<ClockScreen>
    with TickerProviderStateMixin {
  late AnimationController _tickController;

  final List<String> objectIds = ['circle1', 'circle2', 'circle3', 'square1'];

  @override
  void initState() {
    super.initState();
    _tickController = AnimationController(
      duration: const Duration(milliseconds: 16), // ~60fps
      vsync: this,
    )..repeat();

    _tickController.addListener(() {
      ref.read(clockProvider.notifier).tick(0.016); // ~16ms per frame
    });
  }

  @override
  void dispose() {
    _tickController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clockState = ref.watch(clockProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Clock Timer'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Timer Display
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Time: ${clockState.currentTime.toStringAsFixed(2)}s',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Speed: ${clockState.speed}x',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 10),
                Text(
                  clockState.isRunning ? 'RUNNING' : 'PAUSED',
                  style: TextStyle(
                    fontSize: 18,
                    color: clockState.isRunning ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Control Buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () => ref.read(clockProvider.notifier).play(),
                  child: const Icon(Icons.play_arrow),
                ),
                ElevatedButton(
                  onPressed: () => ref.read(clockProvider.notifier).pause(),
                  child: const Icon(Icons.pause),
                ),
                ElevatedButton(
                  onPressed: () => ref.read(clockProvider.notifier).reset(),
                  child: const Icon(Icons.stop),
                ),
                ElevatedButton(
                  onPressed: () =>
                      ref.read(clockProvider.notifier).setSpeed(0.5),
                  child: const Text('0.5x'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      ref.read(clockProvider.notifier).setSpeed(1.0),
                  child: const Text('1x'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      ref.read(clockProvider.notifier).setSpeed(2.0),
                  child: const Text('2x'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      ref.read(clockProvider.notifier).setSpeed(4.0),
                  child: const Text('4x'),
                ),
              ],
            ),
          ),

          // Time Scrubber
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text('Seek to time:'),
                Slider(
                  value: clockState.currentTime.clamp(0.0, 20.0),
                  min: 0.0,
                  max: 20.0,
                  divisions: 200,
                  label: '${clockState.currentTime.toStringAsFixed(1)}s',
                  onChanged: (value) {
                    ref.read(clockProvider.notifier).seekTo(value);
                  },
                ),
              ],
            ),
          ),

          // Animation Area
          Expanded(
            child: Container(
              width: double.infinity,
              height: 1000,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color: Colors.grey),
              ),
              child: Stack(
                children: objectIds
                    .map((id) => AnimatedObjectWidget(objectId: id))
                    .toList(),
              ),
            ),
          ),

          // Animation Info
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Animation Info:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                ...objectIds.map((id) => ObjectStatusWidget(objectId: id)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
