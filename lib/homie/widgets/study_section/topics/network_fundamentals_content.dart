import 'package:flutter/material.dart';
import '../widgets/base_topic_content.dart';
import '../models/content_module.dart';

class NetworkFundamentalsContent extends BaseTopicContent {
  const NetworkFundamentalsContent({
    super.key,
    required super.topic,
  });

  @override
  List<ContentModule> getContentModules() {
    return [
      ContentModule(
        id: 'nf_intro',
        title: 'Introduction to Networking',
        description: 'Overview of computer networks and their importance',
        icon: Icons.school,
        duration: 15,
        type: ContentType.video,
      ),
      ContentModule(
        id: 'nf_osi',
        title: 'Internet',
        description: 'Understanding the 7-layer OSI reference model',
        icon: Icons.layers,
        duration: 25,
        type: ContentType.reading,
      ),
      ContentModule(
        id: 'nf_tcpip',
        title: 'Network',
        description: 'this is network description',
        icon: Icons.hub,
        duration: 30,
        type: ContentType.interactive,
      ),
      ContentModule(
        id: 'nf_addressing',
        title: 'IP Address',
        description: 'IPv4 and IPv6 addressing schemes',
        icon: Icons.location_on,
        duration: 20,
        type: ContentType.video,
      ),
      ContentModule(
        id: 'nf_subnetting',
        title: 'OSI Model',
        description: 'Learn about the 7 layers of the OSI model',
        icon: Icons.network_check,
        duration: 35,
        type: ContentType.lab,
      ),
      ContentModule(
        id: 'nf_quiz',
        title: 'Network Fundamentals Quiz',
        description: 'Test your knowledge of networking basics',
        icon: Icons.quiz,
        duration: 10,
        type: ContentType.quiz,
      ),
    ];
  }

  @override
  void onModuleTap(BuildContext context, ContentModule module) {
    switch (module.type) {
      case ContentType.video:
        // Navigate to video player
        _showModuleMessage(context, 'Opening video player for: ${module.title}');
        break;
      case ContentType.reading:
        // Navigate to reading material
        _showModuleMessage(context, 'Opening reading material for: ${module.title}');
        break;
      case ContentType.quiz:
        // Navigate to quiz screen
        _showModuleMessage(context, 'Starting quiz: ${module.title}');
        break;
      case ContentType.lab:
        // Navigate to lab environment
        _showModuleMessage(context, 'Opening lab environment for: ${module.title}');
        break;
      case ContentType.interactive:
        // Navigate to interactive content
        _showModuleMessage(context, 'Starting interactive session: ${module.title}');
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