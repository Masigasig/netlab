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
        description: 'Basic concepts of network routing and how routers forward packets between networks',
        icon: Icons.alt_route,
        duration: 20,
        type: ContentType.video,
      ),
      ContentModule(
        id: 'rs_static_dynamic',
        title: 'Static vs Dynamic Routing',
        description: 'Compare different routing approaches and when to use each method',
        icon: Icons.compare_arrows,
        duration: 25,
        type: ContentType.reading,
      ),
      ContentModule(
        id: 'rs_protocols',
        title: 'Routing Protocols',
        description: 'Learn about RIP, OSPF, EIGRP, and BGP routing protocols',
        icon: Icons.route,
        duration: 35,
        type: ContentType.interactive,
      ),
      ContentModule(
        id: 'rs_switching',
        title: 'Switching Fundamentals',
        description: 'How network switches operate and manage MAC address tables',
        icon: Icons.switch_left,
        duration: 30,
        type: ContentType.video,
      ),
      ContentModule(
        id: 'rs_vlans',
        title: 'VLANs Configuration',
        description: 'Virtual LAN setup, trunking, and inter-VLAN routing',
        icon: Icons.lan,
        duration: 40,
        type: ContentType.lab,
      ),
      ContentModule(
        id: 'rs_stp',
        title: 'Spanning Tree Protocol',
        description: 'Understanding STP and preventing network loops',
        icon: Icons.account_tree,
        duration: 25,
        type: ContentType.reading,
      ),
      ContentModule(
        id: 'rs_quiz',
        title: 'Routing & Switching Quiz',
        description: 'Test your understanding of routing and switching concepts',
        icon: Icons.quiz,
        duration: 15,
        type: ContentType.quiz,
      ),
    ];
  }

  @override
  void onModuleTap(BuildContext context, ContentModule module) {
    switch (module.type) {
      case ContentType.video:
        _showModuleMessage(context, 'Loading video tutorial: ${module.title}');
        break;
      case ContentType.reading:
        _showModuleMessage(context, 'Opening study guide: ${module.title}');
        break;
      case ContentType.quiz:
        _showModuleMessage(context, 'Preparing quiz: ${module.title}');
        break;
      case ContentType.lab:
        _showModuleMessage(context, 'Initializing lab environment: ${module.title}');
        break;
      case ContentType.interactive:
        _showModuleMessage(context, 'Starting interactive demo: ${module.title}');
        break;
    }
  }

  void _showModuleMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: topic.cardColor.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}