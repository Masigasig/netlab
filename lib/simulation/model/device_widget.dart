import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/core/constants/app_image.dart';
import 'package:netlab/core/constants/app_constants.dart';
import 'package:netlab/simulation/model/device.dart';
import 'package:netlab/simulation/providers/device_map_provider.dart';

abstract class DeviceWidget extends ConsumerStatefulWidget {
  final Device device;
  final String imagePath;
  final double size = AppConstants.deviceSize;

  const DeviceWidget({
    super.key,
    required this.device,
    required this.imagePath,
  });
}

abstract class DeviceWidgetState extends ConsumerState<DeviceWidget> {
  @override
  Widget build(BuildContext context) {
    final device = ref.watch(
      deviceMapProvider.select((map) => map[widget.device.id] ?? widget.device),
    );
    final notifier = ref.read(deviceMapProvider.notifier);

    return Positioned(
      top: device.posY - widget.size / 2,
      left: device.posX - widget.size / 2,
      child: Draggable(
        feedback: Transform.translate(
          offset: Offset(-widget.size / 2, -widget.size / 2),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Image.asset(widget.imagePath, fit: BoxFit.contain),
          ),
        ),
        dragAnchorStrategy: pointerDragAnchorStrategy,
        childWhenDragging: Container(),
        onDragEnd: (details) {
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          final Offset localPosition = renderBox.globalToLocal(details.offset);
          final newX = device.posX + localPosition.dx - widget.size / 2;
          final newY = device.posY + localPosition.dy - widget.size / 2;

          notifier.updatePosition(device.id, newX, newY);
        },
        child: SizedBox(
          width: widget.size,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: widget.size,
                height: widget.size,
                child: Image.asset(widget.imagePath, fit: BoxFit.contain),
              ),
              Text(
                device.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RouterDevice extends DeviceWidget {
  const RouterDevice({super.key, required super.device})
    : super(imagePath: AppImage.router);

  @override
  ConsumerState<DeviceWidget> createState() => RouterDeviceState();
}

class RouterDeviceState extends DeviceWidgetState {}

class LaptopDevice extends DeviceWidget {
  const LaptopDevice({super.key, required super.device})
    : super(imagePath: AppImage.laptop);

  @override
  ConsumerState<DeviceWidget> createState() => LaptopDeviceState();
}

class LaptopDeviceState extends DeviceWidgetState {}

class ServerDevice extends DeviceWidget {
  const ServerDevice({super.key, required super.device})
    : super(imagePath: AppImage.server);

  @override
  ConsumerState<DeviceWidget> createState() => ServerDeviceState();
}

class ServerDeviceState extends DeviceWidgetState {}

class PCDevice extends DeviceWidget {
  const PCDevice({super.key, required super.device})
    : super(imagePath: AppImage.pc);

  @override
  ConsumerState<DeviceWidget> createState() => PCDeviceState();
}

class PCDeviceState extends DeviceWidgetState {}

class SwitchDevice extends DeviceWidget {
  const SwitchDevice({super.key, required super.device})
    : super(imagePath: AppImage.switch_);

  @override
  ConsumerState<DeviceWidget> createState() => SwitchDeviceState();
}

class SwitchDeviceState extends DeviceWidgetState {}
