import 'dart:async';
import '../../../core/services/progress_service.dart';

typedef VoidCallback = void Function();

/// Handles all module progress tracking and time management logic
class ModuleProgressController {
  final String topicId;
  final String moduleId;
  final VoidCallback? onProgressChanged;

  DateTime? _startTime;
  Timer? _periodicTimer;
  bool _isDisposed = false;

  ModuleProgressController({
    required this.topicId,
    required this.moduleId,
    this.onProgressChanged,
  });

  // Start tracking study time for this module
  void startTracking() {
    _startTime = DateTime.now();
    _startPeriodicTimeUpdate();
  }

  // Stop tracking and clean up resources
  void stopTracking() {
    _periodicTimer?.cancel();
    _periodicTimer = null;
  }

  // Reset the start time (useful when switching modules)
  void resetStartTime() {
    _startTime = DateTime.now();
  }

  // Update study time every minute while the module is active
  void _startPeriodicTimeUpdate() {
    _periodicTimer = Timer.periodic(const Duration(minutes: 1), (timer) async {
      if (_isDisposed) {
        timer.cancel();
        return;
      }

      if (_startTime != null) {
        const studyTimeMinutes = 1;
        await ProgressService.updateStudyTime(
          topicId,
          moduleId,
          studyTimeMinutes,
        );
        _startTime = DateTime.now(); // Reset start time for next minute
        onProgressChanged?.call();
      }
    });
  }

  /// Load the completion status of the current module
  Future<bool> loadCompletionStatus() async {
    return await ProgressService.isChapterCompleted(topicId, moduleId);
  }

  /// Complete the current module and update study time
  Future<void> completeModule() async {
    if (_startTime != null) {
      // Calculate final study time
      final studyTimeSeconds = DateTime.now().difference(_startTime!).inSeconds;
      final studyTimeMinutes = (studyTimeSeconds / 60).ceil();

      await ProgressService.updateStudyTime(
        topicId,
        moduleId,
        studyTimeMinutes,
      );
    }

    // Mark module as completed
    await ProgressService.markChapterAsCompleted(
      topicId,
      moduleId,
      completed: true,
    );

    onProgressChanged?.call();
  }

  // Check if a module is accessible based on previous module completion
  static Future<bool> isModuleAccessible({
    required String topicId,
    required List<dynamic> modules,
    required int moduleIndex,
  }) async {
    // First module is always accessible
    if (moduleIndex == 0) return true;

    // Check if the previous module is completed
    final previousModule = modules[moduleIndex - 1];
    return await ProgressService.isChapterCompleted(topicId, previousModule.id);
  }

  // Get the next accessible module index
  static Future<int?> getNextAccessibleModuleIndex({
    required String topicId,
    required List<dynamic> modules,
    required int currentIndex,
  }) async {
    for (int i = currentIndex + 1; i < modules.length; i++) {
      if (await isModuleAccessible(
        topicId: topicId,
        modules: modules,
        moduleIndex: i,
      )) {
        return i;
      }
    }
    return null;
  }

  void dispose() {
    _isDisposed = true;
    stopTracking();
  }
}
