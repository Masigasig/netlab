import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/core/constants/app_constants.dart';
import 'package:netlab/simulation/widgets/device_drawer.dart';
import 'package:netlab/simulation/widgets/grid_painter.dart';

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
  late Animation<Matrix4> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final size = renderBox.size;

        final Matrix4 matrix =
            Matrix4.identity()
              ..translate(
                size.width / 2,
                size.height / 2,
              ) // Center of the screen
              ..translate(
                -widget.canvasSize / 2,
                -widget.canvasSize / 2,
              ); // Offset to center of canvas

        _transformationController.value = matrix;
      }
    });
  }

  void _centerView() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final Matrix4 targetMatrix =
        Matrix4.identity()
          ..translate(size.width / 2, size.height / 2)
          ..translate(-widget.canvasSize / 2, -widget.canvasSize / 2);

    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: targetMatrix,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController
      ..reset()
      ..addListener(() {
        _transformationController.value = _animation.value;
      })
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          DragTarget<String>(
            builder: (context, candidateData, rejectedData) {
              return InteractiveViewer(
                transformationController: _transformationController,
                constrained: false,
                minScale: 0.1,
                child: Stack(
                  children: [
                    CustomPaint(
                      painter: GridPainter(),
                      size: Size(widget.canvasSize, widget.canvasSize),
                    ),

                    // DeviceStack(),
                  ],
                ),
              );
            },
          ),

          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton.small(
                onPressed: _centerView,
                child: const Icon(Icons.center_focus_strong),
              ),
            ),
          ),

          DeviceDrawer(),
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
}
