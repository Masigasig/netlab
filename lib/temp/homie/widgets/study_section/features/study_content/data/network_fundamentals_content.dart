import 'package:flutter/material.dart';
import 'package:netlab/temp/homie/widgets/study_section/widgets/base_topic_content.dart';
import 'package:netlab/temp/homie/widgets/study_section/core/models/content_module.dart';

class NetworkFundamentalsContent extends BaseTopicContent {
  const NetworkFundamentalsContent({super.key, required super.topic});

  @override
  List<ContentModule> getContentModules() {
    return [
      ContentModule(
        id: 'nf_intro',
        title: 'Getting to Networking',
        description: '',
        icon: Icons.start, // HugeIcons.strokeRoundedStartUp02,
        duration: 15,
        type: ContentType.reading,
      ),
      ContentModule(
        id: 'nf_quiz',
        title: 'Network Fundamentals Quiz',
        description: '',
        icon: Icons.quiz,
        duration: 10,
        type: ContentType.quiz,
      ),
      ContentModule(
        id: 'nf_host',
        title: 'Host',
        description: '',
        icon: Icons.computer, // HugeIcons.strokeRoundedComputerActivity,
        duration: 25,
        type: ContentType.reading,
      ),
      ContentModule(
        id: 'nf_host_quiz',
        title: 'Host Quiz',
        description: 'Test your understanding of network hosts',
        icon: Icons.quiz,
        duration: 10,
        type: ContentType.quiz,
      ),
      ContentModule(
        id: 'nf_internet',
        title: 'Internet',
        description: '',
        icon: Icons.public, // HugeIcons.strokeRoundedInternet,
        duration: 25,
        type: ContentType.reading,
      ),
      ContentModule(
        id: 'nf_internet_quiz',
        title: 'Internet Quiz',
        description: 'Test your understanding of internet concepts',
        icon: Icons.quiz,
        duration: 10,
        type: ContentType.quiz,
      ),
      ContentModule(
        id: 'nf_network',
        title: 'Network',
        description: '',
        icon: Icons.network_check, // HugeIcons.strokeRoundedNeuralNetwork,
        duration: 30,
        type: ContentType.interactive,
      ),
      ContentModule(
        id: 'nf_network_quiz',
        title: 'Network Quiz',
        description: 'Test your understanding of network concepts',
        icon: Icons.quiz,
        duration: 10,
        type: ContentType.quiz,
      ),
      ContentModule(
        id: 'nf_ip',
        title: 'IP Address',
        description: '',
        icon: Icons.location_on, // HugeIcons.strokeRoundedLocation01,
        duration: 20,
        type: ContentType.video,
      ),
      ContentModule(
        id: 'nf_network_ip_quiz',
        title: 'Network IP Quiz',
        description: 'Test your understanding of IP addressing concepts',
        icon: Icons.quiz,
        duration: 10,
        type: ContentType.quiz,
      ),
      ContentModule(
        id: 'nf_osi',
        title: 'OSI Model',
        description: '',
        icon: Icons.layers, // HugeIcons.strokeRoundedLayers02,
        duration: 35,
        type: ContentType.lab,
      ),
      ContentModule(
        id: 'nf_network_ip_quiz',
        title: 'Network IP Quiz',
        description: 'Test your understanding of IP addressing concepts',
        icon: Icons.quiz,
        duration: 10,
        type: ContentType.quiz,
      ),
      ContentModule(
        id: 'nf_topic_quiz',
        title: 'Network Fundamentals Topic Quiz',
        description:
            'Final assessment covering all network fundamentals concepts',
        icon: Icons.quiz,
        duration: 15,
        type: ContentType.quiz,
      ),
    ];
  }
}
