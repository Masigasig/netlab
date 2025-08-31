import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:netlab/core/constants/app_colors.dart';
import 'package:netlab/core/constants/app_text.dart';
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
      description: 'Learn the basics of computer networking and how devices communicate',
      cardColor: const Color(0xFF6366F1),
      icon: HugeIcons.strokeRoundedWifi01,
    ),
    StudyTopic(
      id: 'switching_routing',
      title: 'Switching and Routing',
      description: 'Understanding how data moves through networks and switching concepts',
      cardColor: const Color(0xFF10B981),
      icon: HugeIcons.strokeRoundedRouter,
    ),
    StudyTopic(
      id: 'network_devices',
      title: 'Network Devices',
      description: 'Learn about different types of network devices and their functions',
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
              // Header row with search - animated
              Row(
                children: [
                  // Title and subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Study Materials',
                          style: AppTextStyles.headerLarge.copyWith(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                        .blur(begin: const Offset(0, 4), duration: 600.ms, curve: Curves.easeOut)
                        .slideY(begin: 0.3, duration: 600.ms, curve: Curves.easeOutCubic),
                        
                        const SizedBox(height: 3),
                        
                        Text(
                          'Choose a topic to start learning',
                          style: AppTextStyles.subtitleMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 200.ms, curve: Curves.easeOut)
                        .blur(begin: const Offset(0, 2), duration: 500.ms, delay: 200.ms, curve: Curves.easeOut)
                        .slideY(begin: 0.2, duration: 500.ms, delay: 200.ms, curve: Curves.easeOut),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Topics Grid with staggered card animations
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
                    // Calculate staggered delay based on position
                    final baseDelay = 400 + (index * 150); // 150ms between each card
                    
                    return TopicCard(
                      topic: topics[index],
                      onTap: () => _navigateToTopicContent(context, topics[index]),
                    )
                    .animate()
                    .fadeIn(
                      duration: 700.ms,
                      delay: baseDelay.ms,
                      curve: Curves.easeOut,
                    )
                    .blur(
                      begin: const Offset(0, 3),
                      duration: 700.ms,
                      delay: baseDelay.ms,
                      curve: Curves.easeOut,
                    )
                    .scale(
                      begin: const Offset(0.8, 0.8),
                      duration: 700.ms,
                      delay: baseDelay.ms,
                      curve: Curves.easeOutBack,
                    )
                    .slideY(
                      begin: 0.3,
                      duration: 700.ms,
                      delay: baseDelay.ms,
                      curve: Curves.easeOutCubic,
                    )
                    // Add a subtle rotation for more dynamic feel
                    .rotate(
                      begin: 0.02, // Very subtle rotation
                      duration: 700.ms,
                      delay: baseDelay.ms,
                      curve: Curves.easeOut,
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