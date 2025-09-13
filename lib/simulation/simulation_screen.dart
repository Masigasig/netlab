import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:netlab/core/routing/router.dart' show routeObserver;
import 'package:vector_math/vector_math_64.dart' show Vector4, Vector3;

import 'package:netlab/core/constants/app_image.dart';
import 'package:netlab/core/utils/file_service.dart';
import 'package:netlab/simulation/sim_screen_state.dart';

part 'widgets/conn_choice_list.dart';
part 'widgets/device_drawer.dart';
part 'widgets/widget_stack.dart';
part 'widgets/grid_painter.dart';
part 'widgets/info_drawer.dart';
part 'widgets/simulation_logs.dart';

class SimulationScreen extends ConsumerStatefulWidget {
  static const canvasSize = 100_000.0;
  const SimulationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SimulationScreenState();
}

class _SimulationScreenState extends ConsumerState<SimulationScreen>
    with SingleTickerProviderStateMixin, RouteAware {
  final _transformationController = TransformationController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _transformationController.value = _getCenteredMatrix(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPushNext() {
    _cleanupSimulation();
    super.didPushNext();
  }

  @override
  void didPop() {
    _cleanupSimulation();
    super.didPop();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('SimulationScreen Widget Rebuilt');
    return Scaffold(
      body: Stack(
        children: [
          DragTarget<SimObjectType>(
            builder: (context, candidateData, rejectedData) {
              return InteractiveViewer(
                transformationController: _transformationController,
                constrained: false,
                minScale: 0.2,
                child: const Stack(
                  children: [
                    CustomPaint(
                      painter: _GridPainter(),
                      size: Size(
                        SimulationScreen.canvasSize,
                        SimulationScreen.canvasSize,
                      ),
                    ),

                    _DeviceWidgetStack(type: SimObjectType.connection),
                    _DeviceWidgetStack(type: SimObjectType.host),
                    _DeviceWidgetStack(type: SimObjectType.switch_),
                    _DeviceWidgetStack(type: SimObjectType.router),
                    _DeviceWidgetStack(type: SimObjectType.message),

                    ConnChoiceList(),
                  ],
                ),
              );
            },
            onAcceptWithDetails: (details) => _createDevice(details),
          ),

          const LoopAnimator(),
          const DeviceDrawer(),
          const SimulationLogs(),
          const InfoDrawer(),

          Positioned(
            top: 0,
            bottom: 0,
            right: 10,
            child: Center(
              child: _SimulationControls(
                onCenter: _centerViewAnimated,
                onPlay: _playSimulation,
                onStop: _stopSimulation,
                onSave: _saveSimulation,
                onLoad: _loadSimulation,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cleanupSimulation();
    routeObserver.unsubscribe(this);
    _animationController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _cleanupSimulation() {
    final isPlaying = ref.read(playingModeProvider);
    if (isPlaying) {
      // Using addPostFrameCallback to avoid state modifications during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _stopSimulation();
      });
    }
  }

  void _playSimulation() {
    final data = ref.read(simScreenState.notifier).exportSimulation();
    ref.read(temporaryMapProvider.notifier).setMap(data);
    ref.read(simScreenState.notifier).startSimulation();
  }

  void _stopSimulation() {
    final data = ref.read(temporaryMapProvider);
    ref.read(simScreenState.notifier).clearAllState();
    ref.read(simScreenState.notifier).importSimulation(data);
    ref.read(temporaryMapProvider.notifier).clearMap();
    ref.read(simScreenState.notifier).stopSimulation();
  }

  void _createDevice(DragTargetDetails details) {
    final Matrix4 inverse = Matrix4.copy(_transformationController.value)
      ..invert();
    final Vector4 pos = inverse.transform(
      Vector4(details.offset.dx, details.offset.dy, 0, 1),
    );

    ref
        .read(simScreenState.notifier)
        .createDevice(type: details.data, posX: pos.x, posY: pos.y);
  }

  void _centerViewAnimated() {
    final animation =
        Matrix4Tween(
          begin: _transformationController.value,
          end: _getCenteredMatrix(),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    _animationController
      ..addListener(() => _transformationController.value = animation.value)
      ..forward(from: 0);
  }

  Matrix4 _getCenteredMatrix() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    return Matrix4.identity()
      ..translateByVector3(Vector3(size.width / 2, size.height / 2, 0.0))
      ..translateByVector3(
        Vector3(
          -SimulationScreen.canvasSize / 2,
          -SimulationScreen.canvasSize / 2,
          0.0,
        ),
      );
  }

  Future<void> _saveSimulation() async {
    final data = ref.read(simScreenState.notifier).exportSimulation();
    await FileService.saveFile(data);
  }

  Future<void> _loadSimulation() async {
    final data = await FileService.loadFile();
    if (data != null) {
      ref.read(simScreenState.notifier).clearAllState();
      ref.read(simScreenState.notifier).importSimulation(data);
    }
  }
}

class _SimulationControls extends ConsumerWidget {
  final VoidCallback onCenter;
  final VoidCallback onPlay;
  final VoidCallback onStop;
  final VoidCallback onSave;
  final VoidCallback onLoad;

  const _SimulationControls({
    required this.onCenter,
    required this.onPlay,
    required this.onStop,
    required this.onSave,
    required this.onLoad,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlaying = ref.watch(playingModeProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Simulation Logs button
        // FloatingActionButton.small(
        //   onPressed: () {
        //     // find the SimulationLogsState and toggle it
        //     // This is a bit hacky but works for now
        //     final state = context.findAncestorStateOfType<_SimulationLogsState>();
        //     state?._toggleDrawer();
        //   },
        //   heroTag: 'logs',
        //   child: const Icon(HugeIcons.strokeRoundedComputer),
        // ),

        // Center button (always enabled)
        FloatingActionButton.small(
          onPressed: onCenter,
          heroTag: 'center',
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedKeyframeAlignCenter,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),

        const SizedBox(height: 10),

        // Play / Stop button
        FloatingActionButton.small(
          onPressed: isPlaying ? onStop : onPlay,
          heroTag: isPlaying ? 'stop' : 'play',
          child: HugeIcon(
            icon: isPlaying
                ? HugeIcons.strokeRoundedStop
                : HugeIcons.strokeRoundedPlay,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),

        const SizedBox(height: 10),

        // Save button (disabled when playing)
        FloatingActionButton.small(
          onPressed: isPlaying ? null : onSave,
          heroTag: 'save',
          backgroundColor: isPlaying ? Colors.grey.shade400 : null,
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedFileDownload,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),

        const SizedBox(height: 10),

        // Load button (disabled when playing)
        FloatingActionButton.small(
          onPressed: isPlaying ? null : onLoad,
          heroTag: 'load',
          backgroundColor: isPlaying ? Colors.grey.shade400 : null,
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedFileUpload,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }
}

//* Solution to the bug where animation is not rendering continuously when
//* the app is built due to flutter optimization
class LoopAnimator extends ConsumerStatefulWidget {
  const LoopAnimator({super.key});

  @override
  ConsumerState<LoopAnimator> createState() => _LoopAnimatorState();
}

class _LoopAnimatorState extends ConsumerState<LoopAnimator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = ref.watch(playingModeProvider);

    if (isPlaying && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!isPlaying && _controller.isAnimating) {
      _controller.stop();
    }

    // invisible, just keeps the ticker alive
    return RotationTransition(
      turns: _controller,
      child: const SizedBox(width: 0, height: 0),
    );
  }
}
