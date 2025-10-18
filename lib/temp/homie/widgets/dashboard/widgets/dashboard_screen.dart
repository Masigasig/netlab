import 'package:flutter/material.dart';
import '../controllers/dashboard_controller.dart';
import '../services/continue_learning_service.dart';
import 'dashboard_main_content.dart';
import 'dashboard_sidebar.dart';
import 'package:netlab/core/routing/go_router.dart';
import 'package:netlab/temp/homie/widgets/study_section/features/study_content/services/study_topic_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DashboardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DashboardController();
    _controller.loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          if (_controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_controller.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: cs.error),
                  const SizedBox(height: 16),
                  Text(_controller.error!, style: TextStyle(color: cs.error)),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _controller.refresh,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!_controller.hasData) {
            return const Center(child: Text('No data available'));
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: DashboardMainContent(
                  stats: _controller.stats!,
                  streak: _controller.streak,
                ),
              ),
              DashboardSidebar(
                activities: _controller.activities,
                onContinueLearning: _navigateToContinueLearning,
                onBrowseTopics: _navigateToBrowseTopics,
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _navigateToContinueLearning() async {
    final destination =
        await ContinueLearningService.getContinueLearningDestination();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(destination.reason),
        duration: const Duration(seconds: 2),
      ),
    );

    _navigateToTopicContent(destination.topicId, destination.moduleId);
  }

  void _navigateToTopicContent(String topicId, String moduleId) {
    final topic = StudyTopicsService.getTopicById(topicId);

    if (topic == null) {
      context.go(Routes.study);
      return;
    }

    String routePath;

    switch (topicId) {
      case 'network_fundamentals':
        routePath = Routes.networkFundamentals;
        break;
      case 'switching_routing':
        routePath = Routes.switchingRouting;
        break;
      case 'network_devices':
        routePath = Routes.networkDevices;
        break;
      case 'host_to_host':
        routePath = Routes.hostToHost;
        break;
      case 'subnetting':
        routePath = Routes.subnetting;
        break;
      default:
        context.go(Routes.study);
        return;
    }

    context.go(routePath, extra: {'topic': topic, 'initialModuleId': moduleId});
  }

  void _navigateToBrowseTopics() {
    context.go(Routes.study);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
