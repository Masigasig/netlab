import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netlab/dashboard/study/provider/material_details_notifier.dart';

class LessonContent extends ConsumerWidget {
  final String chapterId;
  final String lessonId;

  const LessonContent({
    super.key,
    required this.chapterId,
    required this.lessonId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonData = ref
        .read(materialDetailProvider.notifier)
        .getLessonData(chapterId, lessonId);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(lessonData['title']), Text(lessonData['content_path'])],
      ),
    );
  }
}
