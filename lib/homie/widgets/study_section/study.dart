// ===== MAIN STUDY SCREEN =====
// study_screen.dart
import 'package:flutter/material.dart';
import 'package:netlab/core/constants/app_colors.dart';

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

// ===== MODELS =====
// models/study_topic.dart
class StudyTopic {
  final String id;
  final String title;
  final String description;
  final Color cardColor;
  final IconData icon;

  StudyTopic({
    required this.id,
    required this.title,
    required this.description,
    required this.cardColor,
    required this.icon,
  });
}

class ContentModule {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final int duration; // in minutes
  final ContentType type;

  ContentModule({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.duration,
    required this.type,
  });
}

enum ContentType {
  video,
  reading,
  quiz,
  interactive,
  lab
}

// ===== BASE CONTENT SCREEN =====
// widgets/base_topic_content.dart
abstract class BaseTopicContent extends StatelessWidget {
  final StudyTopic topic;

  const BaseTopicContent({
    super.key,
    required this.topic,
  });

  List<ContentModule> getContentModules();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    topic.cardColor,
                    topic.cardColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    topic.icon,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topic.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          topic.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Content Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Course Content',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${getContentModules().length} modules',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Content modules
                    Expanded(
                      child: ListView.builder(
                        itemCount: getContentModules().length,
                        itemBuilder: (context, index) {
                          return ContentModuleItem(
                            module: getContentModules()[index],
                            onTap: () => onModuleTap(context, getContentModules()[index]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onModuleTap(BuildContext context, ContentModule module) {
    // Override this method in subclasses for custom behavior
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening: ${module.title}'),
        backgroundColor: Colors.white.withOpacity(0.2),
      ),
    );
  }
}

// ===== INDIVIDUAL CONTENT SCREENS =====

// screens/topics/network_fundamentals_content.dart
class NetworkFundamentalsContent extends BaseTopicContent {
  const NetworkFundamentalsContent({
    super.key,
    required super.topic,
  });

  @override
  List<ContentModule> getContentModules() {
    return [
      ContentModule(
        id: 'nf_intro',
        title: 'Introduction to Networking',
        description: 'Overview of computer networks and their importance',
        icon: Icons.school,
        duration: 15,
        type: ContentType.video,
      ),
      ContentModule(
        id: 'nf_osi',
        title: 'OSI Model',
        description: 'Understanding the 7-layer OSI reference model',
        icon: Icons.layers,
        duration: 25,
        type: ContentType.reading,
      ),
      ContentModule(
        id: 'nf_tcpip',
        title: 'TCP/IP Protocol Suite',
        description: 'Deep dive into TCP/IP protocols',
        icon: Icons.hub,
        duration: 30,
        type: ContentType.interactive,
      ),
      ContentModule(
        id: 'nf_addressing',
        title: 'IP Addressing',
        description: 'IPv4 and IPv6 addressing schemes',
        icon: Icons.location_on,
        duration: 20,
        type: ContentType.video,
      ),
      ContentModule(
        id: 'nf_subnetting',
        title: 'Subnetting',
        description: 'Learn how to divide networks into subnets',
        icon: Icons.network_check,
        duration: 35,
        type: ContentType.lab,
      ),
      ContentModule(
        id: 'nf_quiz',
        title: 'Network Fundamentals Quiz',
        description: 'Test your knowledge of networking basics',
        icon: Icons.quiz,
        duration: 10,
        type: ContentType.quiz,
      ),
    ];
  }

  @override
  void onModuleTap(BuildContext context, ContentModule module) {
    // Custom navigation for network fundamentals modules
    switch (module.type) {
      case ContentType.video:
        // Navigate to video player
        break;
      case ContentType.reading:
        // Navigate to reading material
        break;
      case ContentType.quiz:
        // Navigate to quiz screen
        break;
      case ContentType.lab:
        // Navigate to lab environment
        break;
      case ContentType.interactive:
        // Navigate to interactive content
        break;
    }
    
    // For now, show a snackbar
    super.onModuleTap(context, module);
  }
}

// screens/topics/routing_switching_content.dart
class RoutingSwitchingContent extends BaseTopicContent {
  const RoutingSwitchingContent({
    super.key,
    required super.topic,
  });

  @override
  List<ContentModule> getContentModules() {
    return [
      ContentModule(
        id: 'rs_intro',
        title: 'Introduction to Routing',
        description: 'Basic concepts of network routing',
        icon: Icons.alt_route,
        duration: 20,
        type: ContentType.video,
      ),
      ContentModule(
        id: 'rs_static_dynamic',
        title: 'Static vs Dynamic Routing',
        description: 'Compare different routing approaches',
        icon: Icons.compare_arrows,
        duration: 25,
        type: ContentType.reading,
      ),
      ContentModule(
        id: 'rs_switching',
        title: 'Switching Fundamentals',
        description: 'How network switches operate',
        icon: Icons.switch_left,
        duration: 30,
        type: ContentType.interactive,
      ),
      ContentModule(
        id: 'rs_vlans',
        title: 'VLANs Configuration',
        description: 'Virtual LAN setup and management',
        icon: Icons.lan,
        duration: 40,
        type: ContentType.lab,
      ),
    ];
  }
}

// screens/topics/network_security_content.dart
class NetworkSecurityContent extends BaseTopicContent {
  const NetworkSecurityContent({
    super.key,
    required super.topic,
  });

  @override
  List<ContentModule> getContentModules() {
    return [
      ContentModule(
        id: 'ns_fundamentals',
        title: 'Security Fundamentals',
        description: 'Core principles of network security',
        icon: Icons.security,
        duration: 18,
        type: ContentType.video,
      ),
      ContentModule(
        id: 'ns_firewalls',
        title: 'Firewalls',
        description: 'Types and configuration of firewalls',
        icon: Icons.fireplace,
        duration: 28,
        type: ContentType.reading,
      ),
      ContentModule(
        id: 'ns_vpn',
        title: 'VPN Technologies',
        description: 'Virtual Private Network implementation',
        icon: Icons.vpn_lock,
        duration: 35,
        type: ContentType.interactive,
      ),
      ContentModule(
        id: 'ns_encryption',
        title: 'Encryption Methods',
        description: 'Cryptography in network security',
        icon: Icons.enhanced_encryption,
        duration: 25,
        type: ContentType.reading,
      ),
    ];
  }
}

// ===== REUSABLE WIDGETS =====

// Default fallback content screen
class DefaultTopicContent extends BaseTopicContent {
  const DefaultTopicContent({
    super.key,
    required super.topic,
  });

  @override
  List<ContentModule> getContentModules() {
    return [
      ContentModule(
        id: 'coming_soon',
        title: 'Coming Soon',
        description: 'This content is under development',
        icon: Icons.construction,
        duration: 0,
        type: ContentType.reading,
      ),
    ];
  }
}

class TopicCard extends StatelessWidget {
  final StudyTopic topic;
  final VoidCallback onTap;

  const TopicCard({
    super.key,
    required this.topic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              topic.cardColor,
              topic.cardColor.withOpacity(0.8),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: topic.cardColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon in a circular background
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    child: Icon(
                      topic.icon,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Title
                  Text(
                    topic.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Description
                  Text(
                    topic.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ContentModuleItem extends StatelessWidget {
  final ContentModule module;
  final VoidCallback onTap;

  const ContentModuleItem({
    super.key,
    required this.module,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getTypeColor(),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            module.icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          module.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          '${module.description} • ${module.duration} min',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getTypeColor(),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _getTypeLabel(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Color _getTypeColor() {
    switch (module.type) {
      case ContentType.video:
        return Colors.red.withOpacity(0.7);
      case ContentType.reading:
        return Colors.blue.withOpacity(0.7);
      case ContentType.quiz:
        return Colors.orange.withOpacity(0.7);
      case ContentType.interactive:
        return Colors.purple.withOpacity(0.7);
      case ContentType.lab:
        return Colors.green.withOpacity(0.7);
    }
  }

  String _getTypeLabel() {
    switch (module.type) {
      case ContentType.video:
        return 'VIDEO';
      case ContentType.reading:
        return 'READ';
      case ContentType.quiz:
        return 'QUIZ';
      case ContentType.interactive:
        return 'INTERACTIVE';
      case ContentType.lab:
        return 'LAB';
    }
  }
}