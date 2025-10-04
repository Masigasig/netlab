import 'package:flutter/material.dart';
import '../../../core/models/content_module.dart';
import '../../../core/models/study_topic.dart';
import '../controllers/module_progress_controller.dart';
import '../../quiz/controllers/quiz_controller.dart';
import '../coordinators/module_navigation_coordinator.dart';
import '../../study_content/services/content_renderer.dart';
import '../../study_content/services/content_registry.dart';
import '../helpers/module_quiz_manager.dart';
import 'module_header.dart';
import 'module_completion_button.dart';
import '../../quiz/widgets/quiz_submit_button.dart';
import '../../quiz/widgets/quiz_performance_summary.dart';

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
  late ModuleQuizController _quizController;
  bool _isCompleted = false;
  bool _hasQuizzes = false;

  @override
  void initState() {
    super.initState();
    _initializeModule();
  }

  @override
  void didUpdateWidget(ModuleContentView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reinitialize if module or topic changed
    if (oldWidget.module.id != widget.module.id ||
        oldWidget.topic.id != widget.topic.id) {
      _cleanupAndReinitialize();
    }
  }

  void _initializeModule() {
    _hasQuizzes = ModuleQuizManager.hasQuizzes(widget.module.id);
    _initializeControllers();
    _loadModuleProgress();
  }

  void _initializeControllers() {
    _progressController = ModuleProgressController(
      topicId: widget.topic.id,
      moduleId: widget.module.id,
      onProgressChanged: () {
        if (mounted) setState(() {});
      },
    );
    _progressController.startTracking();

    _quizController = ModuleQuizController(
      topicId: widget.topic.id,
      moduleId: widget.module.id,
    );

    // Load previous quiz state if module has quizzes
    if (_hasQuizzes) {
      _quizController.loadPreviousAnswers();
    }
  }

  void _cleanupAndReinitialize() {
    _progressController.dispose();
    
    if (_quizController.isSubmitted) {
      _quizController.reset();
    }

    _initializeModule();

    // Delay quiz loading to ensure questions are registered
    if (_hasQuizzes) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          _quizController.loadPreviousAnswers();
        }
      });
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

  Future<void> _handleModuleCompletion() async {
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

      // Notify parent
      widget.onModuleCompleted?.call();

      // Handle navigation
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
          _buildContentContainer(cs, isLastModule),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildContentContainer(ColorScheme cs, bool isLastModule) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow.withAlpha(100),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline.withAlpha(41)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Content renderer
          ContentRenderer(
            blocks: ContentRegistry.getContent(widget.module.id),
            topicId: widget.topic.id,
            moduleId: widget.module.id,
            quizController: _quizController,
          ),
          const SizedBox(height: 24),

          // Quiz submit button
          if (_hasQuizzes) ...[
            SubmitQuizButton(quizController: _quizController),
            const SizedBox(height: 24),
          ],

          // Quiz performance summary
          if (_hasQuizzes)
            QuizPerformanceSummary(
              topicId: widget.topic.id,
              moduleId: widget.module.id,
              quizController: _quizController,
            ),

          // Module completion button
          ModuleCompletionButton(
            isCompleted: _isCompleted,
            isLastModule: isLastModule,
            hasQuizzes: _hasQuizzes,
            quizController: _quizController,
            onPressed: _handleModuleCompletion,
          ),
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