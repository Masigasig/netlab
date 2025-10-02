import 'package:flutter/material.dart';
import '../../../core/models/content_module.dart';
import '../../../core/models/study_topic.dart';
import '../controllers/module_progress_controller.dart';
import '../coordinators/module_navigation_coordinator.dart';
import '../helpers/module_button_helper.dart';
import '../../study_content/services/content_renderer.dart';
import '../../study_content/services/content_registry.dart';
import '../../../core/services/progress_service.dart';
import 'module_header.dart';

/// Main widget for displaying module content with progress tracking
class ModuleContentView extends StatefulWidget {
  final ContentModule module;
  final StudyTopic topic;
  final int totalModules;
  final int currentModuleIndex;
  final VoidCallback? onNextModule;
  final VoidCallback? onModuleCompleted;

  const ModuleContentView({
    super.key,
    required this.module,
    required this.topic,
    required this.totalModules,
    required this.currentModuleIndex,
    this.onNextModule,
    this.onModuleCompleted,
  });

  @override
  State<ModuleContentView> createState() => _ModuleContentViewState();
}

class _ModuleContentViewState extends State<ModuleContentView> {
  late ModuleProgressController _progressController;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
    _loadModuleProgress();
  }

  void _initializeController() {
    _progressController = ModuleProgressController(
      topicId: widget.topic.id,
      moduleId: widget.module.id,
      onProgressChanged: () {
        if (mounted) {
          setState(() {});
        }
      },
    );
    _progressController.startTracking();
  }

  @override
  void didUpdateWidget(ModuleContentView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reinitialize controller if module or topic changed
    if (oldWidget.module.id != widget.module.id ||
        oldWidget.topic.id != widget.topic.id) {
      _progressController.dispose();
      _initializeController();
      _loadModuleProgress();
    }
  }

  Future<void> _loadModuleProgress() async {
    final isCompleted = await _progressController.loadCompletionStatus();
    if (mounted) {
      setState(() {
        _isCompleted = isCompleted;
      });
    }
  }

  Future<void> _handleButtonPress() async {
    // If already completed, just navigate
    if (_isCompleted) {
      ModuleNavigationCoordinator.moveToNextModule(
        currentIndex: widget.currentModuleIndex,
        totalModules: widget.totalModules,
        onNextModule: widget.onNextModule,
      );
      return;
    }

    // Complete the module
    await _progressController.completeModule();

    if (mounted) {
      setState(() {
        _isCompleted = true;
      });

      // Notify parent that module was completed
      widget.onModuleCompleted?.call();

      // Handle navigation with coordinator
      await ModuleNavigationCoordinator.handleModuleCompletion(
        context: context,
        currentIndex: widget.currentModuleIndex,
        totalModules: widget.totalModules,
        onNextModule: widget.onNextModule,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isLastModule = ModuleNavigationCoordinator.isLastModule(
      widget.currentModuleIndex,
      widget.totalModules,
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Module Header
          ModuleHeader(
            module: widget.module,
            isCompleted: _isCompleted,
            currentModuleIndex: widget.currentModuleIndex,
            totalModules: widget.totalModules,
          ),

          const SizedBox(height: 24),

          // Content Container
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow.withAlpha(100),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.outline.withAlpha(41)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rendered content with topic and module IDs
                ContentRenderer(
                  blocks: ContentRegistry.getContent(widget.module.id),
                  topicId: widget.topic.id,
                  moduleId: widget.module.id,
                ),
                const SizedBox(height: 24),

                // Quiz Performance Summary
                FutureBuilder<Map<String, dynamic>>(
                  future: ProgressService.getModuleQuizStats(
                    widget.topic.id,
                    widget.module.id,
                  ),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!['total'] == 0) {
                      return const SizedBox.shrink();
                    }

                    final stats = snapshot.data!;
                    final percentage = stats['percentage'] as int;

                    // Determine performance color
                    Color performanceColor;
                    String performanceText;
                    IconData performanceIcon;

                    if (percentage >= 80) {
                      performanceColor = cs.primary;
                      performanceText = 'Excellent!';
                      performanceIcon = Icons.emoji_events;
                    } else if (percentage >= 60) {
                      performanceColor = Colors.orange;
                      performanceText = 'Good job!';
                      performanceIcon = Icons.thumb_up;
                    } else {
                      performanceColor = cs.error;
                      performanceText = 'Keep practicing!';
                      performanceIcon = Icons.school;
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: performanceColor.withAlpha(26),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: performanceColor.withAlpha(77),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            performanceIcon,
                            color: performanceColor,
                            size: 32,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Quiz Performance',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: cs.onSurface,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$performanceText You answered ${stats['correct']} out of ${stats['total']} questions correctly',
                                  style: TextStyle(
                                    color: cs.onSurfaceVariant,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: performanceColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$percentage%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // Action button
                Center(
                  child: FilledButton.icon(
                    onPressed:
                        ModuleButtonHelper.isButtonDisabled(
                          isCompleted: _isCompleted,
                          isLastModule: isLastModule,
                        )
                        ? null
                        : _handleButtonPress,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        ModuleButtonHelper.getButtonColor(
                          isCompleted: _isCompleted,
                          isLastModule: isLastModule,
                          colorScheme: cs,
                        ),
                      ),
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                    icon: Icon(
                      ModuleButtonHelper.getButtonIcon(
                        isCompleted: _isCompleted,
                        isLastModule: isLastModule,
                      ),
                      color: cs.onPrimary,
                    ),
                    label: Text(
                      ModuleButtonHelper.getButtonText(
                        isCompleted: _isCompleted,
                        isLastModule: isLastModule,
                      ),
                      style: TextStyle(
                        color: cs.onPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // Helper text
                if (ModuleButtonHelper.getHelperText(
                      isCompleted: _isCompleted,
                      isLastModule: isLastModule,
                    ) !=
                    null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Center(
                      child: Text(
                        ModuleButtonHelper.getHelperText(
                          isCompleted: _isCompleted,
                          isLastModule: isLastModule,
                        )!,
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }
}
