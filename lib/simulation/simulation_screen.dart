import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

import 'package:netlab/core/constants/app_constants.dart';
import 'package:netlab/simulation/model/device.dart';
import 'package:netlab/simulation/model/device_widget.dart';
import 'package:netlab/simulation/providers/device_map_provider.dart';
import 'package:netlab/simulation/providers/device_stack_provider.dart';
import 'package:netlab/simulation/widgets/device_drawer.dart';
import 'package:netlab/simulation/widgets/grid_painter.dart';
import 'package:netlab/simulation/widgets/device_stack.dart';

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

                    DeviceStack(),
                  ],
                ),
              );
            },
            onAcceptWithDetails: (details) {
              final Matrix4 inverse = Matrix4.copy(
                _transformationController.value,
              )..invert();

              final Vector4 pos = inverse.transform(
                Vector4(details.offset.dx, details.offset.dy, 0, 1),
              );

              final uniqueKey = DateTime.now().millisecondsSinceEpoch;
              final deviceType = details.data.toLowerCase();
              final counter = ref
                  .read(deviceMapProvider.notifier)
                  .getNextCounter(deviceType);

              final newDevice = Device(
                id: 'device_$uniqueKey',
                name: '${deviceType}_$counter',
                type: deviceType,
                posX: pos.x,
                posY: pos.y,
              );

              ref.read(deviceMapProvider.notifier).addDevice(newDevice);

              late DeviceWidget newDeviceWidget;

              switch (details.data) {
                case 'router':
                  newDeviceWidget = RouterDevice(device: newDevice);
                  break;
                case 'laptop':
                  newDeviceWidget = LaptopDevice(device: newDevice);
                  break;
                case 'server':
                  newDeviceWidget = ServerDevice(device: newDevice);
                  break;
                case 'pc':
                  newDeviceWidget = PCDevice(device: newDevice);
                  break;
                case 'switch':
                  newDeviceWidget = SwitchDevice(device: newDevice);
                default:
              }
              
              ref
                  .read(deviceStackProvider.notifier)
                  .addDevice(uniqueKey.toString(), newDeviceWidget);
            }
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
