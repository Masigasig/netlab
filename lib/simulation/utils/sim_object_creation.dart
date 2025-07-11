import 'package:flutter/material.dart' hide Router, Switch;


import 'package:netlab/core/constants/app_image.dart';
import 'package:netlab/core/constants/app_constants.dart';

import 'package:netlab/simulation/model/sim_object/sim_object.dart';

const List<Widget> allSpawners = [
  _DeviceSpawner(type: SimObjectType.host, imagePath: AppImage.host),
  _DeviceSpawner(type: SimObjectType.router, imagePath: AppImage.router),
  _DeviceSpawner(type: SimObjectType.switch_, imagePath: AppImage.switch_),
];

class _DeviceSpawner extends StatelessWidget {
  final SimObjectType type;
  final String imagePath;

  const _DeviceSpawner({
    required this.type,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    const double size = AppConstants.deviceSize;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Draggable<SimObjectType>(
          data: type,
          dragAnchorStrategy: pointerDragAnchorStrategy,
          feedback: Transform.translate(
            offset: const Offset(-size / 2, -size / 2),
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
        Text(type.label),
      ],
    );
  }
}


SimObject createSimObject({
  required SimObjectType type,
  required String simObjectId,
  double posX = 0,
  double posY = 0,
  String conA = '',
  String conB = '',
}) {
  switch (type) {
    case SimObjectType.router:
      return Router(id: simObjectId, posX: posX, posY: posY);
    case SimObjectType.switch_:
      return Switch(id: simObjectId, posX: posX, posY: posY);
    case SimObjectType.host:
      return Host(id: simObjectId, posX: posX, posY: posY);
    case SimObjectType.connection:
      return Connection(id: simObjectId, conA: conA, conB: conB);
  }
}