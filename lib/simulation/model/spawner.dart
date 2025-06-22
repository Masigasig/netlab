import 'package:flutter/material.dart';

import 'package:netlab/core/constants/app_image.dart';

class Spawner {
  static Column buildSpawner(String type, String imagePath, String label) {
    const double size = 65.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Draggable<String>(
          data: type,
          dragAnchorStrategy: pointerDragAnchorStrategy,
          feedback: Transform.translate(
            offset: Offset(-(size + 35) / 2, -(size + 35) / 2),
            child: SizedBox(
              width: size + 35,
              height: size + 35,
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
          ),
          child: SizedBox(
            width: size,
            height: size,
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
        ),
        Text(label),
      ],
    );
  }

  static final List<Widget> allSpawners = [
    buildSpawner('router', AppImage.router, 'Router'),
    buildSpawner('laptop', AppImage.laptop, 'Laptop'),
    buildSpawner('pc', AppImage.pc, 'PC'),
    buildSpawner('server', AppImage.server, 'Server'),
    buildSpawner('switch', AppImage.switch_, 'Switch'),
  ];
}
