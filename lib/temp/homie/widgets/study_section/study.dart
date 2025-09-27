// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'models/study_topic.dart';
import 'widgets/topic_card.dart';
import 'topics/network_fundamentals_content.dart';
import 'topics/routing_switching_content.dart';
import 'topics/network_devices.dart';
import 'widgets/default_topic_content.dart';
import 'topics/arp.dart';
import 'package:netlab/core/components/app_theme.dart';
import 'services/progress_service.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  Future<int> _getCompletedTopicsCount() async {
    int completedCount = 0;
    
    for (var topic in topics) {
      final completedChapters = await ProgressService.getCompletedChaptersByTopic(topic.id);
      if (completedChapters.length >= topic.lessonCount) {
        completedCount++;
      }
    }
    
    return completedCount;
  }
  final List<StudyTopic> topics = [
    StudyTopic(
      id: 'network_fundamentals',
      title: 'Network Fundamentals',
      subtitle:
          'Learn the basics of computer networking and how devices communicate',
      description:
          'Master the essential concepts of network topology, addressing, and protocols that form the backbone of modern communications.',
      cardColor: const Color(0xFF6366F1),
      lessonCount: 7,
      readTime: '12 min read',
      isCompleted: false,
      progress: 0,
    ),
    StudyTopic(
      id: 'switching_routing',
      title: 'Switching and Routing',
      subtitle:
          'Understanding how data moves through networks and switching concepts',
      description:
          'Step-by-step walkthrough of routing protocols, switch configuration, and network path determination.',
      cardColor: const Color(0xFF10B981),
      lessonCount: 9,
      readTime: '15 min read',
      isCompleted: false,
      progress: 0,
    ),
    StudyTopic(
      id: 'network_devices',
      title: 'Network Devices',
      subtitle:
          'Learn about different types of network devices and their functions',
      description:
          'Comprehensive guide to routers, switches, hubs, and other networking equipment used in modern infrastructure.',
      cardColor: const Color(0xFFF59E0B),
      lessonCount: 5,
      readTime: '10 min read',
      isCompleted: false,
      progress: 0,
    ),
    StudyTopic(
      id: 'arp',
      title: 'Address Resolution Protocol',
      subtitle: 'Understanding ARP and network address mapping',
      description:
          'Deep dive into how ARP works, ARP tables, and troubleshooting address resolution issues.',
      cardColor: const Color(0xFF8B5CF6),
      lessonCount: 3,
      readTime: '8 min read',
      isCompleted: false,
      progress: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Hero Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Learn Networking\nFundamentals',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                        height: 1.2,
                        letterSpacing: -1.0,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Text(
                        'Master the essentials of networking with clear, practical explanations designed to build a strong foundation without the unnecessary complexity.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: cs.onSurface.withOpacity(0.7),
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildQuickStats(context),
                  ],
                ),
              ),

              // Topics List
              ...topics.map(
                (topic) => TopicCard(
                  topic: topic,
                  onTap: () => _navigateToTopicContent(context, topic),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    int totalTopics = topics.length;

    return FutureBuilder<Map<String, int>>(
      future: Future.wait([
        _getCompletedTopicsCount(),
        ProgressService.getTotalStudyTime(),
      ]).then((values) => {
        'completedTopics': values[0],
        'studyTime': values[1],
      }),
      builder: (context, snapshot) {
        final completedTopics = snapshot.data?['completedTopics'] ?? 0;
        final studyTime = snapshot.data?['studyTime'] ?? 0;
        
        return Row(
          children: [
            // Progress Card
            Expanded(
              child: AppStyles.statsCard(
                context: context,
                title: 'Progress',
                value: '$completedTopics of $totalTopics',
                subtitle: 'topics completed',
                isPrimary: true,
              ),
            ),

            const SizedBox(width: 16),

            // Study Time Card
            Expanded(
              child: AppStyles.statsCard(
                context: context,
                title: 'Study Time',
                value: '$studyTime min',
                subtitle: 'time spent learning',
                isPrimary: false,
              ),
            ),
          ],
        );
      },
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