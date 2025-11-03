import 'package:flutter_riverpod/flutter_riverpod.dart';

final materialContentProvider =
    NotifierProvider<MaterialContentNotifier, Map<String, Map<String, String>>>(
      MaterialContentNotifier.new,
    );

class MaterialContentNotifier
    extends Notifier<Map<String, Map<String, String>>> {
  @override
  Map<String, Map<String, String>> build() {
    return {};
  }

  void setContent(Map<String, Map<String, String>> content) {
    state = content;
  }

  String getLessonContent(String chapterId, String lessonId) {
    return state[chapterId]![lessonId]!;
  }
}
