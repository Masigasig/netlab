import 'package:flutter/material.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final List<TutorialSection> sections = [
    TutorialSection(
      title: 'Getting Started',
      description: 'Learn the basics of the Netlab simulator',
      lessons: [
        TutorialLesson(
          title: 'Interface Overview',
          description: 'Familiarize yourself with the simulator interface',
          duration: '5 min',
          thumbnail: 'assets/images/interface.png',
          topics: [
            'Toolbar navigation',
            'Device palette',
            'Workspace area',
            'Properties panel',
          ],
        ),
        TutorialLesson(
          title: 'Creating Your First Network',
          description: 'Build a simple network with basic devices',
          duration: '10 min',
          thumbnail: 'assets/images/first_network.png',
          topics: [
            'Adding devices',
            'Connecting devices',
            'Basic configuration',
            'Testing connectivity',
          ],
        ),
      ],
    ),
    TutorialSection(
      title: 'Network Devices',
      description: 'Master working with different network devices',
      lessons: [
        TutorialLesson(
          title: 'Router Configuration',
          description: 'Learn how to configure and manage routers',
          duration: '15 min',
          thumbnail: 'assets/images/router.png',
          topics: [
            'Basic router setup',
            'Interface configuration',
            'Routing protocols',
            'Security settings',
          ],
        ),
        TutorialLesson(
          title: 'Switch Operations',
          description: 'Understanding switch functionality and configuration',
          duration: '12 min',
          thumbnail: 'assets/images/switch.png',
          topics: [
            'VLAN configuration',
            'Port settings',
            'Spanning tree',
            'Link aggregation',
          ],
        ),
      ],
    ),
    TutorialSection(
      title: 'Advanced Features',
      description: 'Explore advanced networking concepts',
      lessons: [
        TutorialLesson(
          title: 'Network Troubleshooting',
          description: 'Learn to identify and resolve network issues',
          duration: '20 min',
          thumbnail: 'assets/images/troubleshoot.png',
          topics: [
            'Using diagnostic tools',
            'Reading logs',
            'Common problems',
            'Best practices',
          ],
        ),
        TutorialLesson(
          title: 'Network Security',
          description: 'Implement security measures in your network',
          duration: '18 min',
          thumbnail: 'assets/images/security.png',
          topics: [
            'Access control lists',
            'Port security',
            'Authentication',
            'Encryption',
          ],
        ),
      ],
    ),
  ];

  int selectedSectionIndex = 0;

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
              // Header
              const Text(
                'Tutorials',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Learn how to use the Netlab simulator effectively',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 24),

              // Content
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sections sidebar
                    Container(
                      width: 240,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: sections.length,
                        itemBuilder: (context, index) {
                          return SectionItem(
                            section: sections[index],
                            isSelected: selectedSectionIndex == index,
                            onTap: () => setState(() => selectedSectionIndex = index),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 24),

                    // Lessons grid
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sections[selectedSectionIndex].title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            sections[selectedSectionIndex].description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: GridView.builder(
                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 300,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 1.2,
                              ),
                              itemCount: sections[selectedSectionIndex].lessons.length,
                              itemBuilder: (context, index) {
                                return LessonCard(
                                  lesson: sections[selectedSectionIndex].lessons[index],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TutorialSection {
  final String title;
  final String description;
  final List<TutorialLesson> lessons;

  TutorialSection({
    required this.title,
    required this.description,
    required this.lessons,
  });
}

class TutorialLesson {
  final String title;
  final String description;
  final String duration;
  final String thumbnail;
  final List<String> topics;

  TutorialLesson({
    required this.title,
    required this.description,
    required this.duration,
    required this.thumbnail,
    required this.topics,
  });
}

class SectionItem extends StatelessWidget {
  final TutorialSection section;
  final bool isSelected;
  final VoidCallback onTap;

  const SectionItem({
    super.key,
    required this.section,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              section.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.blue : Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              section.description,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.blue.withOpacity(0.7) : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LessonCard extends StatelessWidget {
  final TutorialLesson lesson;

  const LessonCard({
    super.key,
    required this.lesson,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                image: DecorationImage(
                  image: AssetImage(lesson.thumbnail),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lesson.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          lesson.duration,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lesson.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  const Spacer(),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: lesson.topics
                        .take(3)
                        .map(
                          (topic) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              topic,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
