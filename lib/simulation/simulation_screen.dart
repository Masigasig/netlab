import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/core/constants/app_constants.dart';
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

  @override
  void initState() {
    super.initState();

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
        ],
      ),
    );
  }
}
