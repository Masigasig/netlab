import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:netlab/temp/homie/widgets/study_section/core/models/study_topic.dart';

class StudyTopicsService {
  static final Map<String, StudyTopic> _topicsMap = {
    'network_fundamentals': StudyTopic(
      id: 'network_fundamentals',
      title: 'Network Fundamentals',
      subtitle:
          'Learn the basics of computer networking and how devices communicate',
      description:
          'Master the essential concepts of network topology, addressing, and protocols that form the backbone of modern communications.',
      cardColor: const Color(0xFF6366F1),
      readTime: '12 min read',
      isCompleted: false,
      progress: 0,
    ),
    'switching_routing': StudyTopic(
      id: 'switching_routing',
      title: 'Switching and Routing',
      subtitle:
          'Understanding how data moves through networks and switching concepts',
      description:
          'Step-by-step walkthrough of routing protocols, switch configuration, and network path determination.',
      cardColor: const Color(0xFF10B981),
      readTime: '15 min read',
      isCompleted: false,
      progress: 0,
    ),
    'network_devices': StudyTopic(
      id: 'network_devices',
      title: 'Network Devices',
      subtitle:
          'Learn about different types of network devices and their functions',
      description:
          'Comprehensive guide to routers, switches, hubs, and other networking equipment used in modern infrastructure.',
      cardColor: const Color(0xFFF59E0B),
      readTime: '10 min read',
      isCompleted: false,
      progress: 0,
    ),
    'host_to_host': StudyTopic(
      id: 'host_to_host',
      title: 'Host-to-Host Communication',
      subtitle: 'How devices communicate over a network',
      description:
          'Covers IP and MAC addressing, subnetting, the ARP process, packet delivery, and caching for efficient host-to-host communication.',
      cardColor: const Color(0xFF3B82F6),
      readTime: '10 min read',
      isCompleted: false,
      progress: 0,
    ),
    'subnetting': StudyTopic(
      id: 'subnetting',
      title: 'Subnetting',
      subtitle: 'Master IP subnetting and network segmentation',
      description:
          'Learn how to divide networks into subnets and calculate subnet masks efficiently.',
      cardColor: const Color(0xFF8B5CF6),
      readTime: '14 min read',
      isCompleted: false,
      progress: 0,
    ),
  };

  /// Get a topic by ID, returns null if not found
  static StudyTopic? getTopicById(String id) {
    return _topicsMap[id];
  }

  /// Get all topics
  static Map<String, StudyTopic> getAllTopics() {
    return Map.unmodifiable(_topicsMap);
  }

  /// Get a topic by ID, returns a default topic if not found
  static StudyTopic getTopicByIdWithFallback(String id) {
    final topic = _topicsMap[id];
    if (topic != null) return topic;

    return StudyTopic(
      id: id,
      title: 'Topic',
      subtitle: '',
      description: '',
      cardColor: const Color(0xFF6366F1),
      readTime: '0 min read',
      isCompleted: false,
      progress: 0,
    );
  }

  /// Extract topic data from GoRouter state with fallback
  static (StudyTopic, String?) extractTopicData(
    GoRouterState state,
    String topicId,
  ) {
    final extra = state.extra as Map<String, dynamic>?;
    final topic =
        extra?['topic'] as StudyTopic? ?? getTopicByIdWithFallback(topicId);
    final initialModuleId = extra?['initialModuleId'] as String?;

    return (topic, initialModuleId);
  }
}
