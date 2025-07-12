import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vector_math/vector_math_64.dart' show Vector4;

import 'package:netlab/core/constants/app_constants.dart';

import 'package:netlab/simulation/widgets/device_drawer.dart';
import 'package:netlab/simulation/widgets/grid_painter.dart';

import 'package:netlab/simulation/providers/sim_screen_state.dart';

class SimulationScreen extends ConsumerStatefulWidget {
  final double canvasSize = AppConstants.canvasSize;
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
    return Scaffold(
      body: Stack(
        children: [
          DragTarget<SimObjectType>(
            builder: (context, candidateData, rejectedData) {
              return InteractiveViewer(
                transformationController: _transformationController,
                constrained: false,
                minScale: 0.2,
                child: Stack(
                  children: [
                    CustomPaint(
                      painter: GridPainter(),
                      size: Size(widget.canvasSize, widget.canvasSize),
                    ),
                    const _ConnectionWidgetStack(),
                    const _DeviceWidgetStack(),
                  ],
                ),
              );
            },
            onAcceptWithDetails: (details) => _createDevice(details),
          ),

          const DeviceDrawer(),

          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton.small(
                    onPressed: _centerViewAnimated,
                    heroTag: 'center',
                    child: const Icon(Icons.center_focus_strong),
                  ),
                  const SizedBox(width: 10),
                  FloatingActionButton.small(
                    onPressed: () => {/*TODO: save button*/},
                    heroTag: 'save',
                    child: const Icon(Icons.save),
                  ),
                  const SizedBox(width: 10),
                  FloatingActionButton.small(
                    onPressed: () => {/*TODO: load button*/},
                    heroTag: 'load',
                    child: const Icon(Icons.folder_open),
                  ),
                ],
              ),
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
      ..translate(-widget.canvasSize / 2, -widget.canvasSize / 2);
  }
}

class _DeviceWidgetStack extends ConsumerWidget {
  const _DeviceWidgetStack();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceWidgets = ref.watch(deviceWidgetProvider);

    return SizedBox(
      width: AppConstants.canvasSize,
      height: AppConstants.canvasSize,
      child: Stack(children: [...deviceWidgets.values]),
    );
  }
}

class _ConnectionWidgetStack extends ConsumerWidget {
  const _ConnectionWidgetStack();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionWidgets = ref.watch(connectionWidgetProvider);

    return SizedBox(
      width: AppConstants.canvasSize,
      height: AppConstants.canvasSize,
      child: Stack(children: [...connectionWidgets.values]),
    );
  }
}
