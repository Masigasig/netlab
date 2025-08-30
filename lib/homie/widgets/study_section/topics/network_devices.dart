import 'package:flutter/material.dart';
import '../widgets/base_topic_content.dart';
import '../models/content_module.dart';

class NetworkDevicesContent extends BaseTopicContent {
  const NetworkDevicesContent({
    super.key,
    required super.topic,
  });

  @override
  List<ContentModule> getContentModules() {
    return [
      ContentModule(
        id: 'nd_repeater',
        title: 'Repeater',
        description: '',
        icon: Icons.security,
        duration: 18,
        type: ContentType.video,
      ),
      ContentModule(
        id: 'nd_hub',
        title: 'Hub',
        description: '',
        icon: Icons.warning,
        duration: 22,
        type: ContentType.reading,
      ),
      ContentModule(
        id: 'nd_bridge',
        title: 'Bridge',
        description: '',
        icon: Icons.fireplace,
        duration: 28,
        type: ContentType.interactive,
      ),
      ContentModule(
        id: 'nd_switch',
        title: 'Switch',
        description: '',
        icon: Icons.vpn_lock,
        duration: 35,
        type: ContentType.lab,
      ),
      ContentModule(
        id: 'nd_router',
        title: 'Router',
        description: '',
        icon: Icons.enhanced_encryption,
        duration: 25,
        type: ContentType.reading,
      ),
    ];
  }
}