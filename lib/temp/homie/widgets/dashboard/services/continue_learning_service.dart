// features/dashboard/services/continue_learning_service.dart
import '../../study_section/core/services/progress_service.dart';

class ContinueLearningService {
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
    'host_to_host': [
      'h2h_overview',
      'h2h_preparing',
      'h2h_arp',
      'h2h_packet_flow',
      'h2h_efficiency',
      'h2h_summary',
      'h2h_quiz',
    ],
  };

  /// Get the destination for "Continue Learning" button
  static Future<ContinueLearningDestination>
  getContinueLearningDestination() async {
    // Strategy 1: Find the most recently accessed incomplete module
    final lastStudiedIncomplete = await _getLastStudiedIncompleteModule();
    if (lastStudiedIncomplete != null) {
      return lastStudiedIncomplete;
    }

    // Strategy 2: Find first incomplete module in the last studied topic
    final lastTopicNext = await _getNextInLastTopic();
    if (lastTopicNext != null) {
      return lastTopicNext;
    }

    // Strategy 3: Find first incomplete module across all topics
    final firstIncomplete = await _getFirstIncompleteModule();
    if (firstIncomplete != null) {
      return firstIncomplete;
    }

    // Strategy 4: Everything completed or nothing started - go to first module
    return _getFirstModule();
  }

  /// Strategy 1: Get last studied incomplete module
  static Future<ContinueLearningDestination?>
  _getLastStudiedIncompleteModule() async {
    final List<_ModuleWithTimestamp> modulesWithTimestamps = [];

    // Collect all modules with their last access time
    for (final topicId in _topicModules.keys) {
      for (final moduleId in _topicModules[topicId]!) {
        final isCompleted = await ProgressService.isChapterCompleted(
          topicId,
          moduleId,
        );

        if (!isCompleted) {
          // Check if module has any study time (means it was accessed)
          final studyTime = await ProgressService.getStudyTime(
            topicId,
            moduleId,
          );

          if (studyTime > 0) {
            // Get last study time from SharedPreferences
            // For now, we'll use a simple heuristic: modules with study time
            modulesWithTimestamps.add(
              _ModuleWithTimestamp(
                topicId: topicId,
                moduleId: moduleId,
                studyTime: studyTime,
              ),
            );
          }
        }
      }
    }

    // Sort by study time (modules with more time were likely accessed more recently)
    // This is a heuristic since we don't store "last access time"
    if (modulesWithTimestamps.isNotEmpty) {
      modulesWithTimestamps.sort((a, b) => b.studyTime.compareTo(a.studyTime));
      final mostRecent = modulesWithTimestamps.first;

      return ContinueLearningDestination(
        topicId: mostRecent.topicId,
        moduleId: mostRecent.moduleId,
        reason: 'Continue where you left off',
      );
    }

    return null;
  }

  /// Strategy 2: Get next incomplete module in last studied topic
  static Future<ContinueLearningDestination?> _getNextInLastTopic() async {
    // Find the last topic that has any completed modules
    String? lastStudiedTopic;
    DateTime? latestCompletionTime;

    for (final topicId in _topicModules.keys) {
      for (final moduleId in _topicModules[topicId]!) {
        final completionTime = await ProgressService.getCompletionTimestamp(
          topicId,
          moduleId,
        );

        if (completionTime != null) {
          if (latestCompletionTime == null ||
              completionTime.isAfter(latestCompletionTime)) {
            latestCompletionTime = completionTime;
            lastStudiedTopic = topicId;
          }
        }
      }
    }

    // If we found a last studied topic, find its first incomplete module
    if (lastStudiedTopic != null) {
      final moduleIds = _topicModules[lastStudiedTopic]!;

      for (final moduleId in moduleIds) {
        final isCompleted = await ProgressService.isChapterCompleted(
          lastStudiedTopic,
          moduleId,
        );

        if (!isCompleted) {
          return ContinueLearningDestination(
            topicId: lastStudiedTopic,
            moduleId: moduleId,
            reason: 'Continue your current topic',
          );
        }
      }
    }

    return null;
  }

  /// Strategy 3: Get first incomplete module across all topics
  static Future<ContinueLearningDestination?>
  _getFirstIncompleteModule() async {
    for (final topicId in _topicModules.keys) {
      for (final moduleId in _topicModules[topicId]!) {
        final isCompleted = await ProgressService.isChapterCompleted(
          topicId,
          moduleId,
        );

        if (!isCompleted) {
          return ContinueLearningDestination(
            topicId: topicId,
            moduleId: moduleId,
            reason: 'Start from the beginning',
          );
        }
      }
    }

    return null;
  }

  /// Strategy 4: Get first module (fallback)
  static ContinueLearningDestination _getFirstModule() {
    final firstTopicId = _topicModules.keys.first;
    final firstModuleId = _topicModules[firstTopicId]!.first;

    return ContinueLearningDestination(
      topicId: firstTopicId,
      moduleId: firstModuleId,
      reason: 'Start your learning journey',
    );
  }

  /// Get a motivational message based on progress
  static Future<String> getMotivationalMessage() async {
    final totalModules = _topicModules.values.fold<int>(
      0,
      (sum, modules) => sum + modules.length,
    );
    int completedCount = 0;

    for (final topicId in _topicModules.keys) {
      for (final moduleId in _topicModules[topicId]!) {
        final isCompleted = await ProgressService.isChapterCompleted(
          topicId,
          moduleId,
        );
        if (isCompleted) completedCount++;
      }
    }

    final percentage = (completedCount / totalModules * 100).round();

    if (percentage == 0) {
      return "Let's start your learning journey!";
    } else if (percentage < 25) {
      return "Great start! Keep going!";
    } else if (percentage < 50) {
      return "You're making progress!";
    } else if (percentage < 75) {
      return "Halfway there! Keep it up!";
    } else if (percentage < 100) {
      return "Almost done! Finish strong!";
    } else {
      return "🎉 All modules completed! Review or start over?";
    }
  }
}

class ContinueLearningDestination {
  final String topicId;
  final String moduleId;
  final String reason;

  ContinueLearningDestination({
    required this.topicId,
    required this.moduleId,
    required this.reason,
  });
}

class _ModuleWithTimestamp {
  final String topicId;
  final String moduleId;
  final int studyTime;

  _ModuleWithTimestamp({
    required this.topicId,
    required this.moduleId,
    required this.studyTime,
  });
}
