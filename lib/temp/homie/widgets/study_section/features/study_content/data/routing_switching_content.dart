import 'package:flutter/material.dart';
import 'package:netlab/temp/homie/widgets/study_section/widgets/base_topic_content.dart';
import 'package:netlab/temp/homie/widgets/study_section/core/models/content_module.dart';

class RoutingSwitchingContent extends BaseTopicContent {
  const RoutingSwitchingContent({
    super.key,
    required super.topic,
    super.initialModuleId,
  });

  @override
  List<ContentModule> getContentModules() {
    return [
      ContentModule(
        id: 'sr_intro_switching',
        title: 'Introduction to Switching',
        description: '',
        icon: Icons.start, // HugeIcons.strokeRoundedStartUp02,
        duration: 20,
        type: ContentType.video,
      ),
      ContentModule(
        id: 'sr_intro_switching_quiz',
        title: 'Introduction to Switching Quiz',
        description: 'Test your knowledge on the basics of switching',
        icon: Icons.quiz, // HugeIcons.strokeRoundedQuiz,
        duration: 10,
        type: ContentType.quiz,
      ),
      ContentModule(
        id: 'sr_mac_table',
        title: 'MAC Address Table',
        description: '',
        icon: Icons.table_chart, // HugeIcons.strokeRoundedEditTable,
        duration: 25,
        type: ContentType.reading,
      ),
      ContentModule(
        id: 'sr_mac_address_table_quiz',
        title: 'MAC Address Table Quiz',
        description: 'Test your knowledge on MAC Address Table concepts',
        icon: Icons.quiz, // HugeIcons.strokeRoundedQuiz,
        duration: 10,
        type: ContentType.quiz,
      ),
      ContentModule(
        id: 'sr_operations',
        title: 'Switch Operations',
        description: '',
        icon: Icons.shuffle, // HugeIcons.strokeRoundedShuffle,
        duration: 35,
        type: ContentType.interactive,
      ),
      ContentModule(
        id: 'sr_switch_operations_quiz',
        title: 'Switch Operations Quiz',
        description: 'Test your knowledge on switch operations concepts',
        icon: Icons.quiz, // HugeIcons.strokeRoundedQuiz,
        duration: 10,
        type: ContentType.quiz,
      ),
      ContentModule(
        id: 'sr_frame_types',
        title: 'Switch Frame Types',
        description: '',
        icon: Icons.swap_horiz, // HugeIcons.strokeRoundedExchange01,
        duration: 30,
        type: ContentType.video,
      ),
      ContentModule(
        id: 'sr_intro',
        title: 'Introduction to Routing',
        description: '',
        icon: Icons.start, // HugeIcons.strokeRoundedStartUp02,
        duration: 40,
        type: ContentType.lab,
      ),
      ContentModule(
        id: 'sr_introduction_to_routing_quiz',
        title: 'Introduction to Routing Quiz',
        description: 'Test your knowledge on the basics of routing',
        icon: Icons.quiz, // HugeIcons.strokeRoundedQuiz,
        duration: 10,
        type: ContentType.quiz,
      ),
      ContentModule(
        id: 'sr_host_vs_router',
        title: 'Host vs Router',
        description: '',
        icon: Icons.compare_arrows, // HugeIcons.strokeRoundedGitCompare,
        duration: 15,
        type: ContentType.quiz,
      ),
      ContentModule(
        id: 'sr_router_vs_host_quiz',
        title: 'Router vs Host Quiz',
        description:
            'Test your knowledge on the differences between routers and hosts',
        icon: Icons.quiz, // HugeIcons.strokeRoundedQuiz,
        duration: 10,
        type: ContentType.quiz,
      ),
      ContentModule(
        id: 'sr_network_connections',
        title: 'Router Network Connections',
        description: '',
        icon: Icons.network_check, // HugeIcons.strokeRoundedFlowConnection,
        duration: 25,
        type: ContentType.reading,
      ),
      ContentModule(
        id: 'sr_router_network_connections_quiz',
        title: 'Router Network Connections Quiz',
        description:
            'Test your knowledge on router network connections concepts',
        icon: Icons.quiz, // HugeIcons.strokeRoundedQuiz,
        duration: 10,
        type: ContentType.quiz,
      ),
      ContentModule(
        id: 'sr_routing_table',
        title: 'Routing Table',
        description: '',
        icon: Icons.tablet_outlined, // HugeIcons.strokeRoundedLayoutTable01,
        duration: 25,
        type: ContentType.reading,
      ),
      ContentModule(
        id: 'sr_routing_table_quiz',
        title: 'Routing Table Quiz',
        description: 'Test your knowledge on routing table concepts',
        icon: Icons.quiz, // HugeIcons.strokeRoundedQuiz,
        duration: 10,
        type: ContentType.quiz,
      ),
      ContentModule(
        id: 'sr_routing_types',
        title: 'Routing Types',
        description: '',
        icon: Icons.route, // HugeIcons.strokeRoundedRoute01,
        duration: 25,
        type: ContentType.reading,
      ),
      ContentModule(
        id: 'sr_routing_types_quiz',
        title: 'Routing Types Quiz',
        description: 'Test your knowledge on routing types concepts',
        icon: Icons.quiz, // HugeIcons.strokeRoundedQuiz,
        duration: 10,
        type: ContentType.quiz,
      ),
      ContentModule(
        id: 'sr_topic_quiz',
        title: 'Switching and Routing Topic Quiz',
        description:
            'Final assessment covering all switching and routing concepts',
        icon: Icons.quiz, // HugeIcons.strokeRoundedQuiz,
        duration: 10,
        type: ContentType.quiz,
      ),
    ];
  }
}
