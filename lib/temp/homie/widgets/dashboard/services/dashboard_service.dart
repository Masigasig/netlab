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
    ],
    'network_devices': [
      'nd_repeater',
      'nd_hub',
      'nd_bridge',
      'nd_switch',
      'nd_router',
      'nd_quiz',
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

    int totalModules = 0;
    int completedModules = 0;
    int totalStudyTime = 0;
    int topicsInProgress = 0;
    double totalQuizScore = 0;
    int quizCount = 0;

    // Iterate through all topics and their modules
    for (final topicId in topicIds) {
      final moduleIds = _topicModules[topicId]!;
      bool hasCompletedModule = false;
      bool hasIncompleteModule = false;

      for (final moduleId in moduleIds) {
        totalModules++;

        // Check completion status
        final isCompleted = await ProgressService.isChapterCompleted(
          topicId,
          moduleId,
        );

        if (isCompleted) {
          completedModules++;
          hasCompletedModule = true;
        } else {
          hasIncompleteModule = true;
        }

        // Get study time
        final moduleTime = await ProgressService.getStudyTime(
          topicId,
          moduleId,
        );
        totalStudyTime += moduleTime;

        // Get quiz stats if available
        final quizStats = await ProgressService.getModuleQuizStats(
          topicId,
          moduleId,
        );

        if (quizStats['total'] > 0) {
          totalQuizScore += quizStats['percentage'];
          quizCount++;
        }
      }

      // A topic is in progress if it has at least one completed and one incomplete module
      if (hasCompletedModule && hasIncompleteModule) {
        topicsInProgress++;
      }
    }

    // Calculate average quiz score
    final averageQuizScore = quizCount > 0 ? totalQuizScore / quizCount : 0.0;

    // Calculate overall progress percentage
    final overallProgress = totalModules > 0
        ? (completedModules / totalModules) * 100
        : 0.0;

    return DashboardStats(
      completedModules: completedModules,
      totalModules: totalModules,
      averageQuizScore: averageQuizScore,
      totalStudyTimeMinutes: totalStudyTime,
      topicsInProgress: topicsInProgress,
      totalTopics: topicIds.length,
      overallProgressPercentage: overallProgress,
    );
  }

  /// Get recent activity from progress data
  static Future<List<RecentActivity>> getRecentActivity({int limit = 5}) async {
    final activities = <RecentActivity>[];
    final topicIds = _topicModules.keys.toList();

    // Topic names for display
    final topicNames = {
      'network_fundamentals': 'Network Fundamentals',
      'switching_routing': 'Switching and Routing',
      'network_devices': 'Network Devices',
      'host_to_host': 'Host-to-Host Communication',
    };

    // Collect all completion timestamps
    for (final topicId in topicIds) {
      final moduleIds = _topicModules[topicId]!;

      for (final moduleId in moduleIds) {
        final completionTime = await ProgressService.getCompletionTimestamp(
          topicId,
          moduleId,
        );

        if (completionTime != null) {
          // Get module name from ContentRegistry or use ID
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

    // Sort by most recent first
    activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    // Return limited results
    return activities.take(limit).toList();
  }

  /// Get module display name from ID
  static String _getModuleName(String moduleId) {
    // Map module IDs to readable names
    final moduleNames = {
      'nf_intro': 'Network Introduction',
      'nf_host': 'Host Concepts',
      'nf_internet': 'Internet Basics',
      'nf_network': 'Network Concepts',
      'nf_ip': 'IP Addressing',
      'nf_osi': 'OSI Model',
      'nf_quiz': 'Fundamentals Quiz',
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
      'nd_repeater': 'Repeater',
      'nd_hub': 'Hub',
      'nd_bridge': 'Bridge',
      'nd_switch': 'Switch',
      'nd_router': 'Router',
      'nd_quiz': 'Network Devices Quiz',
      'h2h_overview': 'H2H Overview',
      'h2h_preparing': 'Preparing Communication',
      'h2h_arp': 'ARP Process',
      'h2h_packet_flow': 'Packet Flow',
      'h2h_efficiency': 'Communication Efficiency',
      'h2h_summary': 'H2H Summary',
      'h2h_quiz': 'Host-to-Host Quiz',
      'sub_intro': 'Introduction to Subnetting',
      'sub_attributes': 'Subnet Attributes',
      'sub_cidr': 'CIDR and Subnet Mask',
      'sub_example': 'Subnetting Example',
      'sub_practice': 'Subnetting Practice',
      'sub_quiz': 'Subnetting Quiz',
    };

    return moduleNames[moduleId] ?? moduleId;
  }

  /// Get current study streak in days
  static Future<int> getCurrentStreak() async {
    return await ProgressService.getStreak();
  }
}
