import '../../study_content/models/content_block.dart';
import '../../study_content/services/content_registry.dart';

// Helper class to manage quiz-related checks and logic
class ModuleQuizManager {
  static bool hasQuizzes(String moduleId) {
    final blocks = ContentRegistry.getContent(moduleId);
    return blocks.any((block) => block.type == ContentBlockType.quiz);
  }

  static int getQuizCount(String moduleId) {
    final blocks = ContentRegistry.getContent(moduleId);
    return blocks.where((block) => block.type == ContentBlockType.quiz).length;
  }

  static bool hasBlockType(String moduleId, ContentBlockType type) {
    final blocks = ContentRegistry.getContent(moduleId);
    return blocks.any((block) => block.type == type);
  }
}
