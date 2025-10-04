import 'package:flutter/material.dart';
import 'package:netlab/temp/homie/widgets/study_section/widgets/base_topic_content.dart';
import 'package:netlab/temp/homie/widgets/study_section/core/models/content_module.dart';

class NetworkDevicesContent extends BaseTopicContent {
  const NetworkDevicesContent({super.key, required super.topic});

  @override
  List<ContentModule> getContentModules() {
    return [
      ContentModule(
        id: 'nd_repeater',
        title: 'Repeater',
        description: 'Understanding network repeaters and their functions',
        icon: Icons.repeat, // HugeIcons.strokeRoundedRepeat,
        duration: 18,
        type: ContentType.video,
      ),
      ContentModule(
        id: 'nd_hub',
        title: 'Hub',
        description: 'Learning about network hubs and their limitations',
        icon: Icons.hub, // HugeIcons.strokeRoundedArrowAllDirection,
        duration: 22,
        type: ContentType.reading,
      ),
      ContentModule(
        id: 'nd_bridge',
        title: 'Bridge',
        description:
            'Exploring how bridges connect and filter traffic between networks',
        icon: Icons.link, // HugeIcons.strokeRoundedLink03,
        duration: 28,
        type: ContentType.interactive,
      ),
      ContentModule(
        id: 'nd_switch',
        title: 'Switch',
        description: 'Studying switches and their role in modern networks',
        icon: Icons
            .switch_access_shortcut, // HugeIcons.strokeRoundedCurvyLeftRightDirection,
        duration: 35,
        type: ContentType.lab,
      ),
      ContentModule(
        id: 'nd_router',
        title: 'Router',
        description:
            'Understanding how routers forward packets between networks',
        icon: Icons.router, // HugeIcons.strokeRoundedRouter02,
        duration: 25,
        type: ContentType.reading,
      ),
      ContentModule(
        id: 'nd_quiz',
        title: 'Quiz: Network Devices',
        description: 'Test your knowledge on network devices',
        icon: Icons.quiz, // HugeIcons.strokeRoundedQuiz,
        duration: 10,
        type: ContentType.quiz,
      ),
    ];
  }
}
