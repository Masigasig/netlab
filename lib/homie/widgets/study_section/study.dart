import 'package:flutter/material.dart';
import 'package:netlab/core/constants/app_colors.dart';
import 'models/study_topic.dart';
import 'widgets/topic_card.dart';
import 'topics/network_fundamentals_content.dart';
import 'topics/routing_switching_content.dart';
import 'topics/network_security_content.dart';
import 'widgets/default_topic_content.dart';

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
      icon: Icons.network_wifi,
    ),
    StudyTopic(
      id: 'routing_switching',
      title: 'Routing and Switching',
      description: 'Understanding how data moves through networks and switching concepts',
      cardColor: const Color(0xFF10B981),
      icon: Icons.router,
    ),
    StudyTopic(
      id: 'network_security',
      title: 'Network Security',
      description: 'Protect networks from threats and learn security best practices',
      cardColor: const Color(0xFFF59E0B),
      icon: Icons.security,
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
              // Header row with search
              Row(
                children: [
                  // Title and subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Study Materials',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Choose a topic to start learning',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Search Bar
                  SizedBox(
                    width: 300,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search topics...',
                        hintStyle: const TextStyle(color: Colors.white54),
                        prefixIcon: const Icon(Icons.search, color: Colors.white54),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Topics Grid
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
                    return TopicCard(
                      topic: topics[index],
                      onTap: () => _navigateToTopicContent(context, topics[index]),
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
      case 'routing_switching':
        contentScreen = RoutingSwitchingContent(topic: topic);
        break;
      case 'network_security':
        contentScreen = NetworkSecurityContent(topic: topic);
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