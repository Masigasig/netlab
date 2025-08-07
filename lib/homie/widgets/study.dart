import 'package:flutter/material.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  final List<StudyTopic> topics = [
    StudyTopic(
      title: 'Network Fundamentals',
      description: 'Learn the basics of computer networking',
      progress: 0.3,
      modules: [
        'Introduction to Networks',
        'OSI Model',
        'TCP/IP Protocol Suite',
        'Network Devices',
      ],
    ),
    StudyTopic(
      title: 'Routing and Switching',
      description: 'Understanding network routing and switching concepts',
      progress: 0.0,
      modules: [
        'Router Fundamentals',
        'Switching Basics',
        'VLANs',
        'Routing Protocols',
      ],
    ),
    StudyTopic(
      title: 'Network Security',
      description: 'Learn about network security principles',
      progress: 0.0,
      modules: [
        'Security Basics',
        'Firewalls',
        'Encryption',
        'Network Threats',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
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
                    return TopicCard(topic: topics[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudyTopic {
  final String title;
  final String description;
  final double progress;
  final List<String> modules;

  StudyTopic({
    required this.title,
    required this.description,
    required this.progress,
    required this.modules,
  });
}

class TopicCard extends StatelessWidget {
  final StudyTopic topic;

  const TopicCard({
    super.key,
    required this.topic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            topic.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            topic.description,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white70,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${topic.modules.length} Modules',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
              Text(
                '${(topic.progress * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: topic.progress,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}
