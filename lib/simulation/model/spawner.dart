import 'package:flutter/material.dart';

import 'package:netlab/core/constants/app_image.dart';
import 'package:netlab/core/constants/app_constants.dart';
import 'package:netlab/simulation/model/device_widget.dart';
import 'package:netlab/simulation/model/device.dart';

class Spawner {
  static Column buildSpawner(String type, String imagePath, String label) {
    const double size = AppConstants.deviceSize;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Draggable<String>(
          data: type,
          dragAnchorStrategy: pointerDragAnchorStrategy,
          feedback: Transform.translate(
            offset: Offset(-size / 2, -size / 2),
            child: SizedBox(
              width: size,
              height: size,
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
          ),
          child: SizedBox(
            width: size - 35,
            height: size - 35,
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
        ),
        Text(label),
      ],
    );
  }

  static final List<Widget> allSpawners = [
    buildSpawner('router', AppImage.router, 'Router'),
    buildSpawner('switch', AppImage.switch_, 'Switch'),
  ];

  static DeviceWidget createDeviceWidget(Device device) {
    switch (device.type) {
      case 'router':
        return RouterDevice(device: device);
      case 'switch':
        return SwitchDevice(device: device);
      default:
        throw Exception('Unknown device type: ${device.type}');
    }
  }
}
