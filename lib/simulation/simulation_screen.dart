import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

import 'package:netlab/core/constants/app_constants.dart';
import 'package:netlab/simulation/model/device.dart';
import 'package:netlab/simulation/model/spawner.dart';
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

              final device = ref
                  .read(deviceMapProvider.notifier)
                  .createAndAddDevice(
                    type: details.data.toLowerCase(),
                    posX: pos.x,
                    posY: pos.y,
                  );
              final widget = Spawner.createDeviceWidget(device);
              ref
                  .read(deviceStackProvider.notifier)
                  .addDevice(device.id, widget);
            },
          ),

          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton.small(
                    onPressed: _centerView,
                    heroTag: 'center',
                    child: const Icon(Icons.center_focus_strong),
                  ),
                  const SizedBox(width: 10),
                  FloatingActionButton.small(
                    onPressed: _saveDeviceMap,
                    heroTag: 'save',
                    child: const Icon(Icons.save),
                  ),
                  const SizedBox(width: 10),
                  FloatingActionButton.small(
                    onPressed: _loadDeviceMap,
                    heroTag: 'load',
                    child: const Icon(Icons.folder_open),
                  ),
                ],
              ),
            ),
          ),

          DeviceDrawer(),
        ],
      ),
    );
  }

  Future<void> _saveDeviceMap() async {
    final jsonString = jsonEncode(
      ref.read(deviceMapProvider).values.map((d) => d.toMap()).toList(),
    );
    final bytes = utf8.encode(jsonString);
    await FilePicker.platform.saveFile(
      dialogTitle: 'Save your device map',
      fileName: 'devices.netlab.json',
      allowedExtensions: ['json'],
      type: FileType.custom,
      bytes: bytes,
    );
  }

  Future<void> _loadDeviceMap() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      final jsonString = await File(path).readAsString();
      final List<dynamic> jsonList = jsonDecode(jsonString);
      final devices = {
        for (var d in jsonList)
          (d['id'] as String): Device.fromMap(d as Map<String, dynamic>),
      };

      ref.read(deviceStackProvider.notifier).clear();
      ref.read(deviceMapProvider.notifier).setDevices(devices);

      devices.forEach((id, device) {
        final widget = Spawner.createDeviceWidget(device);
        ref.read(deviceStackProvider.notifier).addDevice(id, widget);
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _transformationController.dispose();
    super.dispose();
  }
}
