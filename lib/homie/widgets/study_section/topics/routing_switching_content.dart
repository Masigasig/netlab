// homie/widgets/study_section/topics/routing_switching_content.dart
import 'package:flutter/material.dart';
import '../widgets/base_topic_content.dart';
import '../models/content_module.dart';

class RoutingSwitchingContent extends BaseTopicContent {
  const RoutingSwitchingContent({
    super.key,
    required super.topic,
  });

  @override
  List<ContentModule> getContentModules() {
    return [
      ContentModule(
        id: 'rs_intro',
        title: 'Introduction to Routing',
        description: 'Basic concepts of network routing',
        icon: Icons.alt_route,
        duration: 20,
        type: ContentType.video,
      ),
      ContentModule(
        id: 'rs_static_dynamic',
        title: 'Static vs Dynamic Routing',
        description: 'Compare different routing approaches',
        icon: Icons.compare_arrows,
        duration: 25,
        type: ContentType.reading,
      ),
      ContentModule(
        id: 'rs_switching',
        title: 'Switching Fundamentals',
        description: 'How network switches operate',
        icon: Icons.switch_left,
        duration: 30,
        type: ContentType.interactive,
      ),
      ContentModule(
        id: 'rs_vlans',
        title: 'VLANs Configuration',
        description: 'Virtual LAN setup and management',
        icon: Icons.lan,
        duration: 40,
        type: ContentType.lab,
      ),
    ];
  }
}