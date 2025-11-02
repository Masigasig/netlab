import 'package:flutter_riverpod/flutter_riverpod.dart';

final materialDetailProvider =
    NotifierProvider<MaterialDetailNotifier, Map<String, dynamic>>(
      MaterialDetailNotifier.new,
    );

class MaterialDetailNotifier extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() {
    return {};
  }

  void setContent(Map<String, dynamic> json) {
    state = json;
  }

  Map<String, dynamic> getChapterData(String chapterId) {
    return state[chapterId];
  }

  Map<String, dynamic> getLessonData(String chapterId, String lessonId) {
    return state[chapterId]['lessons'][lessonId];
  }
}
