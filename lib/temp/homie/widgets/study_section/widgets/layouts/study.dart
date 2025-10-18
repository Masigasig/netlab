// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:netlab/temp/homie/widgets/study_section/core/models/study_topic.dart';
import 'package:netlab/temp/homie/widgets/study_section/widgets/topic_card.dart';
import 'package:netlab/core/themes/app_theme.dart';
import 'package:netlab/temp/homie/widgets/study_section/core/services/progress_service.dart';
import 'package:netlab/temp/homie/widgets/study_section/features/study_content/services/module_registry.dart';
import 'package:netlab/temp/core/constants/app_text.dart';
import 'package:netlab/core/routing/go_router.dart';
import 'package:netlab/temp/homie/widgets/study_section/features/study_content/services/study_topic_service.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  @override
  void initState() {
    super.initState();
    _initializeTopicChapters();
  }

  Future<void> _initializeTopicChapters() async {
    for (var topic in topics) {
      final lessonCount = ModuleRegistry.getLessonCount(topic.id);
      await ProgressService.setTotalChaptersByTopic(topic.id, lessonCount);
    }
  }

  Future<int> _getCompletedTopicsCount() async {
    int completedCount = 0;

    for (var topic in topics) {
      final completedChapters =
          await ProgressService.getCompletedChaptersByTopic(topic.id);
      final totalChapters = ModuleRegistry.getLessonCount(topic.id);

      if (completedChapters.length >= totalChapters) {
        completedCount++;
      }
    }

    return completedCount;
  }

  late final List<StudyTopic> topics = StudyTopicsService.getAllTopics().values
      .toList();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

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
                    /// Headline
                    Text(
                      'Learn Networking\nFundamentals',
                      style: AppTextStyles.forSurface(
                        AppTextStyles.headerLarge.copyWith(
                          fontSize: 42,
                          height: 1.2,
                          letterSpacing: -1.0,
                        ),
                        context,
                      ),
                    ),
                    const SizedBox(height: 16),

                    /// Subtitle
                    Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Text(
                        'Master the essentials of networking with clear, practical explanations designed to build a strong foundation without the unnecessary complexity.',
                        style: AppTextStyles.forSurface(
                          AppTextStyles.bodyMedium.copyWith(height: 1.5),
                          context,
                        ).copyWith(color: cs.onSurface.withOpacity(0.7)),
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
                  orderedTopicIds: topics.map((t) => t.id).toList(),
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
      future:
          Future.wait([
            _getCompletedTopicsCount(),
            ProgressService.getTotalStudyTime(),
          ]).then(
            (values) => {'completedTopics': values[0], 'studyTime': values[1]},
          ),
      builder: (context, snapshot) {
        final completedTopics = snapshot.data?['completedTopics'] ?? 0;
        final studyTime = snapshot.data?['studyTime'] ?? 0;

        return Row(
          children: [
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
    String routePath;

    switch (topic.id) {
      case 'network_fundamentals':
        routePath = Routes.networkFundamentals;
        break;
      case 'network_devices':
        routePath = Routes.networkDevices;
        break;
      case 'subnetting':
        routePath = Routes.subnetting;
        break;
      case 'host_to_host':
        routePath = Routes.hostToHost;
        break;
      case 'switching_routing':
        routePath = Routes.switchingRouting;
        break;
      default:
        return;
    }
    context.push(routePath, extra: {'topic': topic, 'initialModuleId': null});
  }
}
