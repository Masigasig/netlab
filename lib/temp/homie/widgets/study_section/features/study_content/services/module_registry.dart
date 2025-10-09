import 'content_registry.dart';

class ModuleRegistry {
  static Map<String, List<String>>? _cachedTopicModules;

  static Map<String, List<String>> _getTopicModules() {
    if (_cachedTopicModules != null) return _cachedTopicModules!;

    final topicModules = <String, List<String>>{
      'network_fundamentals': [],
      'switching_routing': [],
      'network_devices': [],
      'host_to_host': [],
      'subnetting': [],
    };

    final allModuleIds = ContentRegistry.getAllModuleIds();

    for (final moduleId in allModuleIds) {
      if (moduleId.startsWith('nf_')) {
        topicModules['network_fundamentals']!.add(moduleId);
      } else if (moduleId.startsWith('sr_')) {
        topicModules['switching_routing']!.add(moduleId);
      } else if (moduleId.startsWith('nd_')) {
        topicModules['network_devices']!.add(moduleId);
      } else if (moduleId.startsWith('h2h_')) {
        topicModules['host_to_host']!.add(moduleId);
      } else if (moduleId.startsWith('sub_')) {
        topicModules['subnetting']!.add(moduleId);
      } else {}
    }

    _cachedTopicModules = topicModules;
    return topicModules;
  }

  static int getLessonCount(String topicId) {
    final modules = _getTopicModules()[topicId];
    if (modules == null || modules.isEmpty) {
      return 0;
    }
    return modules.length;
  }

  static List<String> getModuleIds(String topicId) {
    return _getTopicModules()[topicId] ?? [];
  }

  static bool hasModule(String topicId, String moduleId) {
    final modules = _getTopicModules()[topicId];
    return modules != null && modules.contains(moduleId);
  }

  static String? getQuizModuleId(String topicId) {
    final modules = _getTopicModules()[topicId];
    if (modules == null) return null;

    try {
      return modules.firstWhere((m) => m.endsWith('_quiz'));
    } catch (e) {
      return null;
    }
  }

  static bool hasQuiz(String topicId) {
    return getQuizModuleId(topicId) != null;
  }

  static List<String> getContentModuleIds(String topicId) {
    final modules = _getTopicModules()[topicId];
    if (modules == null) return [];
    return modules.where((m) => !m.endsWith('_quiz')).toList();
  }

  static int getModuleIndex(String topicId, String moduleId) {
    final modules = _getTopicModules()[topicId];
    if (modules == null) return -1;
    return modules.indexOf(moduleId);
  }

  static String? getNextModuleId(String topicId, String currentModuleId) {
    final modules = _getTopicModules()[topicId];
    if (modules == null) return null;

    final currentIndex = modules.indexOf(currentModuleId);
    if (currentIndex == -1 || currentIndex == modules.length - 1) {
      return null;
    }

    return modules[currentIndex + 1];
  }

  static String? getPreviousModuleId(String topicId, String currentModuleId) {
    final modules = _getTopicModules()[topicId];
    if (modules == null) return null;

    final currentIndex = modules.indexOf(currentModuleId);
    if (currentIndex <= 0) {
      return null;
    }

    return modules[currentIndex - 1];
  }

  static List<String> getAllTopicIds() {
    return _getTopicModules().keys.toList();
  }

  static void clearCache() {
    _cachedTopicModules = null;
  }
}
