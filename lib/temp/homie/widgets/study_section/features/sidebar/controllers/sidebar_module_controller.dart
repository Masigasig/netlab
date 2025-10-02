import '../../../core/services/progress_service.dart';
import '../../modules/controllers/module_progress_controller.dart';

class SidebarModuleController {
  final String topicId;
  final String moduleId;
  final int moduleIndex;
  final List<dynamic> allModules;
  final VoidCallback? onStateChanged;

  bool isCompleted = false;
  bool isAccessible = false;
  bool isLoading = true;

  SidebarModuleController({
    required this.topicId,
    required this.moduleId,
    required this.moduleIndex,
    required this.allModules,
    this.onStateChanged,
  });

  // Load both completion and accessibility status
  Future<void> loadModuleStatus() async {
    isLoading = true;
    onStateChanged?.call();

    // Check completion
    isCompleted = await ProgressService.isChapterCompleted(topicId, moduleId);

    // Check accessibility using the shared controller
    isAccessible = await ModuleProgressController.isModuleAccessible(
      topicId: topicId,
      modules: allModules,
      moduleIndex: moduleIndex,
    );

    isLoading = false;
    onStateChanged?.call();
  }

  // Check if module can be tapped
  bool canTap() => isAccessible;

  Future<void> refresh() async {
    // Check completion
    isCompleted = await ProgressService.isChapterCompleted(topicId, moduleId);

    // Check accessibility using the shared controller
    isAccessible = await ModuleProgressController.isModuleAccessible(
      topicId: topicId,
      modules: allModules,
      moduleIndex: moduleIndex,
    );

    onStateChanged?.call();
  }
}
