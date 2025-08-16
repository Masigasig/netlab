import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vector_math/vector_math_64.dart' show Vector4;

import 'package:netlab/core/constants/app_image.dart';
import 'package:netlab/core/utils/file_service.dart';
import 'package:netlab/simulation/sim_screen_state.dart';

part 'widgets/conn_choice_list.dart';
part 'widgets/device_drawer.dart';
part 'widgets/widget_stack.dart';
part 'widgets/grid_painter.dart';
part 'widgets/info_drawer.dart';

const double canvasSize = 100_000.0; // put it here for optimazation

class SimulationScreen extends ConsumerStatefulWidget {
  const SimulationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SimulationScreenState();
}

class _SimulationScreenState extends ConsumerState<SimulationScreen>
    with SingleTickerProviderStateMixin {
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
                      size: Size(canvasSize, canvasSize),
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

          const DeviceDrawer(),
          const InfoDrawer(),

          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Center(
              child: _SimulationControls(
                onCenter: _centerViewAnimated,
                onPlay: _playSimulation,
                onSave: _saveSimulation,
                onLoad: _loadSimulation,
              ),

              // Row(
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //     FloatingActionButton.small(
              //       onPressed: _playSimulation,
              //       heroTag: 'play',
              //       child: const Icon(Icons.play_arrow),
              //     ),
              //     const SizedBox(width: 10),
              //     FloatingActionButton.small(
              //       onPressed: _centerViewAnimated,
              //       heroTag: 'center',
              //       child: const Icon(Icons.center_focus_strong),
              //     ),
              //     const SizedBox(width: 10),
              //     FloatingActionButton.small(
              //       onPressed: _saveSimulation,
              //       heroTag: 'save',
              //       child: const Icon(Icons.save),
              //     ),
              //     const SizedBox(width: 10),
              //     FloatingActionButton.small(
              //       onPressed: _loadSimulation,
              //       heroTag: 'load',
              //       child: const Icon(Icons.folder_open),
              //     ),
              //   ],
              // ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _playSimulation() {}

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
      ..translate(size.width / 2, size.height / 2)
      ..translate(-canvasSize / 2, -canvasSize / 2);
  }

  Future<void> _saveSimulation() async {
    final data = ref.read(simScreenState.notifier).exportSimulation();
    await FileService.saveFile(data);
  }

  Future<void> _loadSimulation() async {
    final data = await FileService.loadFile();
    if (data != null) {
      ref.read(simScreenState.notifier).clearAllState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(simScreenState.notifier).invalidateProviders();
        ref.read(simScreenState.notifier).importSimulation(data);
      });
    }
  }
}

class _SimulationControls extends ConsumerWidget {
  final VoidCallback onCenter;
  final VoidCallback onPlay;
  final VoidCallback onSave;
  final VoidCallback onLoad;

  const _SimulationControls({
    required this.onCenter,
    required this.onPlay,
    required this.onSave,
    required this.onLoad,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.small(
          onPressed: onPlay,
          heroTag: 'play',
          child: const Icon(Icons.play_arrow),
        ),
        const SizedBox(width: 10),
        FloatingActionButton.small(
          onPressed: onCenter,
          heroTag: 'center',
          child: const Icon(Icons.center_focus_strong),
        ),
        const SizedBox(width: 10),
        FloatingActionButton.small(
          onPressed: onSave,
          heroTag: 'save',
          child: const Icon(Icons.save),
        ),
        const SizedBox(width: 10),
        FloatingActionButton.small(
          onPressed: onLoad,
          heroTag: 'load',
          child: const Icon(Icons.folder_open),
        ),
      ],
    );
  }
}
