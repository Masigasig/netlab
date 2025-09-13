import 'package:flutter/material.dart';

import '../widgets/base_topic_content.dart';
import '../models/content_module.dart';
// import 'package:hugeicons/hugeicons.dart';

class NetworkDevicesContent extends BaseTopicContent {
  const NetworkDevicesContent({super.key, required super.topic});

  @override
  List<ContentModule> getContentModules() {
    return [
      ContentModule(
        id: 'nd_repeater',
        title: 'Repeater',
        description: '',
        icon: Icons.repeat, // HugeIcons.strokeRoundedRepeat,
        duration: 18,
        type: ContentType.video,
      ),
      ContentModule(
        id: 'nd_hub',
        title: 'Hub',
        description: '',
        icon: Icons.hub, // HugeIcons.strokeRoundedArrowAllDirection,
        duration: 22,
        type: ContentType.reading,
      ),
      ContentModule(
        id: 'nd_bridge',
        title: 'Bridge',
        description: '',
        icon: Icons.link, // HugeIcons.strokeRoundedLink03,
        duration: 28,
        type: ContentType.interactive,
      ),
      ContentModule(
        id: 'nd_switch',
        title: 'Switch',
        description: '',
        icon: Icons
            .switch_access_shortcut, // HugeIcons.strokeRoundedCurvyLeftRightDirection,
        duration: 35,
        type: ContentType.lab,
      ),
      ContentModule(
        id: 'nd_router',
        title: 'Router',
        description: '',
        icon: Icons.router, // HugeIcons.strokeRoundedRouter02,
        duration: 25,
        type: ContentType.reading,
      ),
    ];
  }
}
