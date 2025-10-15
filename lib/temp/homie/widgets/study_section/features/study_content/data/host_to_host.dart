import 'package:flutter/material.dart';
import 'package:netlab/temp/homie/widgets/study_section/widgets/base_topic_content.dart';
import 'package:netlab/temp/homie/widgets/study_section/core/models/content_module.dart';

class HostToHostContent extends BaseTopicContent {
  const HostToHostContent({super.key, required super.topic});

  @override
  List<ContentModule> getContentModules() {
    return [
      ContentModule(
        id: 'h2h_overview',
        title: 'Host-to-Host Communication',
        description: 'What hosts are, IP and MAC addresses, and subnet basics.',
        icon: Icons.device_hub,
        type: ContentType.reading,
        duration: 2,
      ),
      ContentModule(
        id: 'hh_host_overview_quiz',
        title: 'Host-to-Host Communication Quiz',
        description:
            'Test your knowledge on host-to-host communication concepts.',
        icon: Icons.quiz,
        type: ContentType.quiz,
        duration: 5,
      ),
      ContentModule(
        id: 'h2h_preparing',
        title: 'Preparing to Send Data',
        description:
            'How IP headers and MAC addresses work together for delivery.',
        icon: Icons.send,
        type: ContentType.reading,
        duration: 2,
      ),
      ContentModule(
        id: 'hh_preparing_quiz',
        title: 'Preparing to Send Data Quiz',
        description:
            'Test your knowledge on how IP headers and MAC addresses work together for delivery.',
        icon: Icons.quiz,
        type: ContentType.quiz,
        duration: 5,
      ),
      ContentModule(
        id: 'h2h_arp',
        title: 'Address Resolution Protocol (ARP)',
        description:
            'How ARP requests and replies map IP addresses to MAC addresses.',
        icon: Icons.swap_horiz,
        type: ContentType.reading,
        duration: 3,
      ),
      ContentModule(
        id: 'hh_arp_quiz',
        title: 'Address Resolution Protocol (ARP) Quiz',
        description:
            'Test your knowledge on how ARP maps IP addresses to MAC addresses.',
        icon: Icons.quiz,
        type: ContentType.quiz,
        duration: 5,
      ),
      ContentModule(
        id: 'h2h_packet_flow',
        title: 'Packet Transmission and Reception',
        description:
            'How packets are wrapped with headers and processed at the destination.',
        icon: Icons.all_inbox,
        type: ContentType.reading,
        duration: 3,
      ),
      ContentModule(
        id: 'hh_packet_transmission_quiz',
        title: 'Packet Transmission and Reception Quiz',
        description:
            'Test your knowledge on how packets are transmitted and received.',
        icon: Icons.quiz,
        type: ContentType.quiz,
        duration: 5,
      ),
      ContentModule(
        id: 'h2h_efficiency',
        title: 'Subsequent Communication',
        description: 'How ARP caching speeds up communication between hosts.',
        icon: Icons.flash_on,
        type: ContentType.reading,
        duration: 2,
      ),
      ContentModule(
        id: 'hh_subsequent_communication_quiz',
        title: 'Subsequent Communication Quiz',
        description:
            'Test your knowledge on how ARP caching speeds up communication between hosts.',
        icon: Icons.quiz,
        type: ContentType.quiz,
        duration: 5,
      ),
      ContentModule(
        id: 'h2h_summary',
        title: 'Key Takeaways',
        description:
            'Essential points about ARP, IP-to-MAC mapping, and efficient delivery.',
        icon: Icons.lightbulb_outline,
        type: ContentType.reading,
        duration: 2,
      ),
      ContentModule(
        id: 'h2h_quiz',
        title: 'Quiz: Host-to-Host Communication',
        description:
            'Test your knowledge on host-to-host communication concepts',
        icon: Icons.quiz, // HugeIcons.strokeRoundedQuiz,
        duration: 5,
        type: ContentType.quiz,
      ),
    ];
  }
}
