import 'package:flutter/material.dart';
import 'package:netlab/temp/core/constants/app_colors.dart';
import 'package:netlab/temp/core/constants/app_text.dart';
import 'package:netlab/temp/core/components/animations.dart';
import 'models/study_topic.dart';
import 'widgets/topic_card.dart';
import 'topics/network_fundamentals_content.dart';
import 'topics/routing_switching_content.dart';
import 'topics/network_devices.dart';
import 'widgets/default_topic_content.dart';
import 'topics/arp.dart';
import 'package:hugeicons/hugeicons.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  final List<StudyTopic> topics = [
    StudyTopic(
      id: 'network_fundamentals',
      title: 'Network Fundamentals',
      description:
          'Learn the basics of computer networking and how devices communicate',
      cardColor: const Color(0xFF6366F1),
      icon: HugeIcons.strokeRoundedWifi01,
    ),
    StudyTopic(
      id: 'switching_routing',
      title: 'Switching and Routing',
      description:
          'Understanding how data moves through networks and switching concepts',
      cardColor: const Color(0xFF10B981),
      icon: HugeIcons.strokeRoundedRouter,
    ),
    StudyTopic(
      id: 'network_devices',
      title: 'Network Devices',
      description:
          'Learn about different types of network devices and their functions',
      cardColor: const Color(0xFFF59E0B),
      icon: HugeIcons.strokeRoundedComputerPhoneSync,
    ),
    StudyTopic(
      id: 'arp',
      title: 'ARP',
      description: 'this is arp btw',
      cardColor: const Color(0xFF6366F1),
      icon: Icons.network_wifi,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimationPresets.titleFadeIn(
                          child: Text(
                            'Study Materials',
                            style: AppTextStyles.headerLarge.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          delay: 0,
                          duration: const Duration(milliseconds: 600),
                        ),

                        const SizedBox(height: 3),

                        AnimationPresets.textFadeIn(
                          child: Text(
                            'Choose a topic to start learning',
                            style: AppTextStyles.subtitleMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          delay: 200,
                          duration: const Duration(milliseconds: 500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: topics.length,
                  itemBuilder: (context, index) {
                    return AnimationPresets.cardEntrance(
                      child: TopicCard(
                        topic: topics[index],
                        onTap: () =>
                            _navigateToTopicContent(context, topics[index]),
                      ),
                      delay: 400 + (index * 150),
                      duration: const Duration(milliseconds: 700),
                      scaleFrom: 0.8,
                      rotationAmount: 0.02,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToTopicContent(BuildContext context, StudyTopic topic) {
    Widget contentScreen;

    switch (topic.id) {
      case 'network_fundamentals':
        contentScreen = NetworkFundamentalsContent(topic: topic);
        break;
      case 'switching_routing':
        contentScreen = RoutingSwitchingContent(topic: topic);
        break;
      case 'network_devices':
        contentScreen = NetworkDevicesContent(topic: topic);
        break;
      case 'arp':
        contentScreen = ArpContent(topic: topic);
        break;
      default:
        contentScreen = DefaultTopicContent(topic: topic);
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => contentScreen),
    );
  }
}
