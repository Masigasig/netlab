import 'package:flutter/material.dart';
import '../controllers/dashboard_controller.dart';
import 'dashboard_main_content.dart';
import 'dashboard_sidebar.dart';

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

  void _navigateToContinueLearning() {
    // TODO: Navigate to the last studied topic/module
    // Navigator.pushNamed(context, '/study');
  }

  void _navigateToBrowseTopics() {
    // TODO: Navigate to topics list
    // Navigator.pushNamed(context, '/topics');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
