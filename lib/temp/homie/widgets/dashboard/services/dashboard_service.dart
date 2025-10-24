import '../models/dashboard_stats.dart';
import '../models/recent_activity.dart';
import '../models/activity_type.dart';
import '../../study_section/core/services/progress_service.dart';

typedef VoidCallback = void Function();

class DashboardService {
  static final Map<String, List<String>> _topicModules = {
    'network_fundamentals': [
      'nf_intro',
      'nf_host',
      'nf_internet',
      'nf_network',
      'nf_ip',
      'nf_osi',
      'nf_quiz',
      'nf_host_quiz',
      'nf_internet_quiz',
      'nf_network_ip_quiz',
      'nf_network_quiz',
      'nf_osi_model_quiz',
      'nf_topic_quiz',
    ],
    'switching_routing': [
      'sr_intro_switching',
      'sr_mac_table',
      'sr_operations',
      'sr_frame_types',
      'sr_intro',
      'sr_host_vs_router',
      'sr_network_connections',
      'sr_routing_table',
      'sr_routing_types',
      'sr_quiz',
      'sr_intro_switching_quiz',
      'sr_introduction_to_routing_quiz',
      'sr_mac_address_table_quiz',
      'sr_router_network_connections_quiz',
      'sr_router_vs_host_quiz',
      'sr_routing_table_quiz',
      'sr_routing_types_quiz',
      'sr_switch_operations_quiz',
      'sr_topic_quiz',
    ],
    'network_devices': [
      'nd_repeater',
      'nd_hub',
      'nd_bridge',
      'nd_switch',
      'nd_router',
      'nd_quiz',
      'nd_bridge_quiz',
      'nd_switch_quiz',
      'nd_router_quiz',
      'nd_hub_quiz',
      'nd_repeater_quiz',
      'nd_topic_quiz',
    ],
    'host_to_host': [
      'h2h_overview',
      'h2h_host_overview_quiz',
      'h2h_preparing',
      'h2h_preparing_quiz',
      'h2h_arp',
      'h2h_arp_quiz',
      'h2h_packet_flow',
      'h2h_packet_transmission_quiz',
      'h2h_efficiency',
      'h2h_subsequent_communication_quiz',
      'h2h_summary',
      'h2h_topic_quiz',
    ],
    'subnetting': [
      'sub_intro',
      'sub_attributes',
      'sub_cidr',
      'sub_example',
      'sub_practice',
      'sub_quiz',
    ],
  };

  /// Get aggregated dashboard statistics
  static Future<DashboardStats> getDashboardStats() async {
    final topicIds = _topicModules.keys.toList();

    int totalChapterQuizzes = 0;
    int completedChapterQuizzes = 0;
    int totalTopicQuizzes = 0;
    int completedTopicQuizzes = 0;
    int totalStudyTime = 0;
    double totalQuizTime = 0;
    int quizTimeCount = 0;

    int correctAnswers = 0;
    int wrongAnswers = 0;
    int undiscoveredQuestions = 0;

    // Iterate through all topics and their modules
    for (final topicId in topicIds) {
      final moduleIds = _topicModules[topicId]!;

      for (final moduleId in moduleIds) {
        // Get study time
        final moduleTime = await ProgressService.getStudyTime(
          topicId,
          moduleId,
        );
        totalStudyTime += moduleTime;

        // Get quiz stats if module is a quiz
        if (moduleId.contains('quiz')) {
          if (moduleId.contains('topic_quiz')) {
            totalTopicQuizzes++;
          } else {
            totalChapterQuizzes++;
          }

          final quizStats = await ProgressService.getModuleQuizStats(
            topicId,
            moduleId,
          );

          if (quizStats['total'] > 0) {
            final correct = quizStats['correct'] as int;
            final total = quizStats['total'] as int;
            final wrong = total - correct;

            correctAnswers += correct;
            wrongAnswers += wrong;

            // Check if quiz is completed (passed threshold of 60%)
            final percentage = quizStats['percentage'] as int;
            if (percentage >= 60) {
              if (moduleId.contains('topic_quiz')) {
                completedTopicQuizzes++;
              } else {
                completedChapterQuizzes++;
              }
            }

            // Calculate quiz time (assuming avg 30 seconds per question if completed)
            if (moduleTime > 0) {
              final avgTimePerQuestion =
                  (moduleTime * 60) / total; // Convert minutes to seconds
              totalQuizTime += avgTimePerQuestion;
              quizTimeCount++;
            }
          } else {
            // Quiz not attempted - all questions are undiscovered
            // Estimate 5 questions per quiz if not attempted
            undiscoveredQuestions += 5;
          }
        }
      }
    }

    // Calculate average quiz time per question
    final averageQuizTime = quizTimeCount > 0
        ? totalQuizTime / quizTimeCount
        : 0.0;

    return DashboardStats(
      totalChapterQuizzes: totalChapterQuizzes,
      completedChapterQuizzes: completedChapterQuizzes,
      totalTopicQuizzes: totalTopicQuizzes,
      completedTopicQuizzes: completedTopicQuizzes,
      averageQuizTimeSeconds: averageQuizTime,
      totalStudyTimeMinutes: totalStudyTime,
      correctAnswers: correctAnswers,
      wrongAnswers: wrongAnswers,
      undiscoveredQuestions: undiscoveredQuestions,
    );
  }

  /// Get recent activity from progress data
  static Future<List<RecentActivity>> getRecentActivity({int limit = 5}) async {
    final activities = <RecentActivity>[];
    final topicIds = _topicModules.keys.toList();

    final topicNames = {
      'network_fundamentals': 'Network Fundamentals',
      'switching_routing': 'Switching and Routing',
      'network_devices': 'Network Devices',
      'subnetting': 'Subnetting',
      'host_to_host': 'Host-to-Host Communication',
    };

    for (final topicId in topicIds) {
      final moduleIds = _topicModules[topicId]!;

      for (final moduleId in moduleIds) {
        final completionTime = await ProgressService.getCompletionTimestamp(
          topicId,
          moduleId,
        );

        if (completionTime != null) {
          final moduleName = _getModuleName(moduleId);

          activities.add(
            RecentActivity(
              id: '${topicId}_$moduleId',
              type: ActivityType.moduleCompleted,
              title: moduleName,
              subtitle: topicNames[topicId] ?? topicId,
              timestamp: completionTime,
            ),
          );
        }
      }
    }

    activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return activities.take(limit).toList();
  }

  static String _getModuleName(String moduleId) {
    final moduleNames = {
      // network fundamentals
      'nf_intro': 'Network Introduction',
      'nf_host': 'Host Concepts',
      'nf_internet': 'Internet Basics',
      'nf_network': 'Network Concepts',
      'nf_ip': 'IP Addressing',
      'nf_osi': 'OSI Model',
      'nf_quiz': 'Fundamentals Quiz',
      'nf_host_quiz': 'Host Quiz',
      'nf_internet_quiz': 'Internet Quiz',
      'nf_network_ip_quiz': 'Network & IP Quiz',
      'nf_network_quiz': 'Network Quiz',
      'nf_osi_model_quiz': 'OSI Model Quiz',
      'nf_topic_quiz': 'Fundamentals Topic Quiz',

      // switching routing
      'sr_intro_switching': 'Switching Introduction',
      'sr_mac_table': 'MAC Address Table',
      'sr_operations': 'Switch Operations',
      'sr_frame_types': 'Frame Types',
      'sr_intro': 'Routing Introduction',
      'sr_host_vs_router': 'Host vs Router',
      'sr_network_connections': 'Network Connections',
      'sr_routing_table': 'Routing Table',
      'sr_routing_types': 'Routing Types',
      'sr_quiz': 'Switching & Routing Quiz',
      'sr_intro_switching_quiz': 'Introduction to Switching Quiz',
      'sr_introduction_to_routing_quiz': 'Introduction to Routing Quiz',
      'sr_mac_address_table_quiz': 'MAC Address Table Quiz',
      'sr_router_network_connections_quiz': 'Router Network Connections Quiz',
      'sr_router_vs_host_quiz': 'Router vs Host Quiz',
      'sr_routing_table_quiz': 'Routing Table Quiz',
      'sr_routing_types_quiz': 'Routing Types Quiz',
      'sr_switch_operations_quiz': 'Switch Operations Quiz',
      'sr_topic_quiz': 'Switching & Routing Topic Quiz',

      // network devices
      'nd_repeater': 'Repeater',
      'nd_hub': 'Hub',
      'nd_bridge': 'Bridge',
      'nd_switch': 'Switch',
      'nd_router': 'Router',
      // 'nd_quiz': 'Network Devices Quiz',
      'nd_bridge_quiz': 'Bridge Quiz',
      'nd_switch_quiz': 'Switch Quiz',
      'nd_router_quiz': 'Router Quiz',
      'nd_hub_quiz': 'Hub Quiz',
      'nd_repeater_quiz': 'Repeater Quiz',
      'nd_topic_quiz': 'Network Devices Topic Quiz',

      // host to host
      'h2h_overview': 'Host-to-Host Communication',
      'h2h_host_overview_quiz': 'Host-to-Host Communication Quiz',
      'h2h_preparing': 'Preparing to Send Data',
      'h2h_preparing_quiz': 'Preparing to Send Data Quiz',
      'h2h_arp': 'Address Resolution Protocol (ARP)',
      'h2h_arp_quiz': 'Address Resolution Protocol (ARP) Quiz',
      'h2h_packet_flow': 'Packet Flow',
      'h2h_packet_transmission_quiz': 'Packet Transmission and Reception Quiz',
      'h2h_efficiency': 'Communication Efficiency',
      'h2h_subsequent_communication_quiz': 'Subsequent Communication Quiz',
      'h2h_summary': 'Host-to-Host Communication Summary',
      'h2h_topic_quiz': 'Host-to-Host Communication Topic Quiz',

      // subnetting
      'sub_intro': 'Introduction to Subnetting',
      'sub_attributes': 'Subnet Attributes',
      'sub_cidr': 'CIDR and Subnet Mask',
      'sub_example': 'Subnetting Example',
      'sub_practice': 'Subnetting Practice',
      'sub_quiz': 'Subnetting Quiz',
    };

    return moduleNames[moduleId] ?? moduleId;
  }

  static Future<int> getCurrentStreak() async {
    return await ProgressService.getStreak();
  }
}
