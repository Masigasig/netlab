import 'package:flutter/material.dart';
import '../../../core/models/content_module.dart';
import '../../../core/models/study_topic.dart';
import '../controllers/module_progress_controller.dart';
import '../../quiz/controllers/quiz_controller.dart';
import '../coordinators/module_navigation_coordinator.dart';
import '../helpers/module_button_helper.dart';
import '../../study_content/services/content_renderer.dart';
import '../../study_content/services/content_registry.dart';
import '../../study_content/models/content_block.dart';
import '../../../core/services/progress_service.dart';
import 'module_header.dart';
import '../../quiz/widgets/quiz_submit_button.dart';

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
  late ModuleQuizController _quizController;
  bool _isCompleted = false;
  bool _hasQuizzes = false;

  @override
  void initState() {
    super.initState();
    _checkForQuizzes();
    _initializeControllers();
    _loadModuleProgress();
  }

  void _checkForQuizzes() {
    final blocks = ContentRegistry.getContent(widget.module.id);
    _hasQuizzes = blocks.any((block) => block.type == ContentBlockType.quiz);
  }

  void _initializeControllers() {
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

    _quizController = ModuleQuizController(
      topicId: widget.topic.id,
      moduleId: widget.module.id,
    );

    // Only load previous quiz state if module has quizzes
    if (_hasQuizzes) {
      _quizController.loadPreviousAnswers();
    }
  }

  @override
  void didUpdateWidget(ModuleContentView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reinitialize controllers if module or topic changed
    if (oldWidget.module.id != widget.module.id ||
        oldWidget.topic.id != widget.topic.id) {
      // Dispose old controllers
      _progressController.dispose();

      // Clear quiz state before switching
      if (_quizController.isSubmitted) {
        _quizController.reset();
      }

      // Initialize for new module
      _checkForQuizzes();
      _initializeControllers();
      _loadModuleProgress();

      // Load quiz state for new module if it has quizzes
      // Delay slightly to ensure all questions are registered
      if (_hasQuizzes) {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) {
            _quizController.loadPreviousAnswers();
          }
        });
      }
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
                // Rendered content with quiz controller
                ContentRenderer(
                  blocks: ContentRegistry.getContent(widget.module.id),
                  topicId: widget.topic.id,
                  moduleId: widget.module.id,
                  quizController: _quizController,
                ),
                const SizedBox(height: 24),

                // Submit Quiz Button (only show if module has quizzes)
                if (_hasQuizzes) ...[
                  SubmitQuizButton(quizController: _quizController),
                  const SizedBox(height: 24),
                ],

                // Quiz Performance Summary (only show if has quizzes and after submission)
                if (_hasQuizzes)
                  ListenableBuilder(
                    listenable: _quizController,
                    builder: (context, _) {
                      if (!_quizController.isSubmitted) {
                        return const SizedBox.shrink();
                      }

                      return FutureBuilder<Map<String, dynamic>>(
                        future: ProgressService.getModuleQuizStats(
                          widget.topic.id,
                          widget.module.id,
                        ),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData ||
                              snapshot.data!['total'] == 0 ||
                              !_quizController.isSubmitted) {
                            return const SizedBox.shrink();
                          }

                          // Combine stats from ProgressService and QuizController
                          final storedStats = snapshot.data!;
                          final currentStats = _quizController.getStats();

                          // Use current stats if they exist, otherwise use stored stats
                          final stats = _quizController.isSubmitted
                              ? currentStats
                              : storedStats;
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                      );
                    },
                  ),

                // Action button
                ListenableBuilder(
                  listenable: _quizController,
                  builder: (context, _) {
                    if (_hasQuizzes && !_quizController.isSubmitted) {
                      return const SizedBox.shrink();
                    }

                    return Center(
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
                    );
                  },
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

