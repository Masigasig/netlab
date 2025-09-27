import 'package:flutter/material.dart';
import '../../models/content_module.dart';
import '../../models/study_topic.dart';
import '../../services/progress_service.dart';
import 'module_type_helpers.dart';
import '../../topics/content/content_renderer.dart';
import '../../topics/content/content_registry.dart';

// ignore_for_file: deprecated_member_use
class ModuleContentView extends StatefulWidget {
  final ContentModule module;
  final StudyTopic topic;
  final int totalModules;

  const ModuleContentView({
    super.key,
    required this.module,
    required this.topic,
    required this.totalModules,
  });

  @override
  State<ModuleContentView> createState() => _ModuleContentViewState();
}

class _ModuleContentViewState extends State<ModuleContentView> {
  bool _isCompleted = false;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _loadModuleProgress();
    _startTime = DateTime.now();
    _startPeriodicTimeUpdate();
  }

  void _startPeriodicTimeUpdate() {
    // Update study time every minute while reading
    Future.doWhile(() async {
      await Future.delayed(const Duration(minutes: 1));
      if (!mounted) return false;

      if (_startTime != null && !_isCompleted) {
        const studyTimeMinutes = 1;
        await ProgressService.updateStudyTime(
          widget.topic.id,
          widget.module.id,
          studyTimeMinutes,
        );
        _startTime = DateTime.now(); // Reset start time for next minute
      }

      return true;
    });
  }

  @override
  void didUpdateWidget(ModuleContentView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.module.id != widget.module.id ||
        oldWidget.topic.id != widget.topic.id) {
      _loadModuleProgress();
      // Reset start time when switching to a new module
      _startTime = DateTime.now();
    }
  }

  Future<void> _loadModuleProgress() async {
    final isCompleted = await ProgressService.isChapterCompleted(
      widget.topic.id,
      widget.module.id,
    );
    if (mounted) {
      setState(() {
        _isCompleted = isCompleted;
      });
    }
  }

  Future<void> _toggleModuleCompletion() async {
    final newState = !_isCompleted;

    if (newState && _startTime != null) {
      // Calculate study time in seconds and convert to minutes (rounded up)
      final studyTimeSeconds = DateTime.now().difference(_startTime!).inSeconds;
      final studyTimeMinutes = (studyTimeSeconds / 60).ceil();
      await ProgressService.updateStudyTime(
        widget.topic.id,
        widget.module.id,
        studyTimeMinutes,
      );
    }

    await ProgressService.markChapterAsCompleted(
      widget.topic.id,
      widget.module.id,
      completed: newState,
    );

    if (mounted) {
      setState(() {
        _isCompleted = newState;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newState ? 'Chapter completed!' : 'Chapter marked as incomplete',
            ),
            duration: const Duration(seconds: 2),
          ),
        );

        if (context.mounted) {
          Navigator.of(context).setState(() {});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Module Header
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: ModuleTypeHelpers.getTypeColor(widget.module.type),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.module.icon,
                      color: cs.onPrimary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.module.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: ModuleTypeHelpers.getTypeColor(
                                  widget.module.type,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                ModuleTypeHelpers.getTypeLabel(
                                  widget.module.type,
                                ),
                                style: TextStyle(
                                  color: cs.onPrimary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${widget.module.duration} minutes',
                              style: TextStyle(
                                fontSize: 14,
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerLow.withAlpha(100),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cs.outline.withOpacity(0.15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ContentRenderer(
                      blocks: ContentRegistry.getContent(widget.module.id),
                    ),
                    const SizedBox(height: 24),
                    // Mark as Complete Button
                    Center(
                      child: FilledButton.icon(
                        onPressed: _toggleModuleCompletion,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            _isCompleted
                                ? cs.primary.withOpacity(0.6)
                                : cs.primary,
                          ),
                        ),
                        icon: Icon(
                          _isCompleted
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                          color: cs.onPrimary,
                        ),
                        label: Text(
                          _isCompleted ? 'Completed' : 'Mark as Complete',
                          style: TextStyle(color: cs.onPrimary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
