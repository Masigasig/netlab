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
        title: 'Getting Started with Networking',
        description: '',
        icon: Icons.school,
        duration: 15,
        type: ContentType.reading,
      ),
      ContentModule(
        id: 'nf_host',
        title: 'Host',
        description: '',
        icon: Icons.layers,
        duration: 25,
        type: ContentType.reading,
      ),
      ContentModule(
        id: 'nf_internet',
        title: 'Internet',
        description: '',
        icon: Icons.layers,
        duration: 25,
        type: ContentType.reading,
      ),
      ContentModule(
        id: 'nf_network',
        title: 'Network',
        description: '',
        icon: Icons.hub,
        duration: 30,
        type: ContentType.interactive,
      ),
      ContentModule(
        id: 'nf_ip',
        title: 'IP Address',
        description: '',
        icon: Icons.location_on,
        duration: 20,
        type: ContentType.video,
      ),
      ContentModule(
        id: 'nf_osi',
        title: 'OSI Model',
        description: '',
        icon: Icons.network_check,
        duration: 35,
        type: ContentType.lab,
      ),
      ContentModule(
        id: 'nf_quiz',
        title: 'Network Fundamentals Quiz',
        description: '',
        icon: Icons.quiz,
        duration: 10,
        type: ContentType.quiz,
      ),
    ];
  }
}