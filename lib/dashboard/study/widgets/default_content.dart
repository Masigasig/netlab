import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netlab/dashboard/study/provider/material_details_notifier.dart';

//* TODO: Designan mo to JADE
class DefaultContent extends ConsumerWidget {
  final String chapterId;

  const DefaultContent({super.key, required this.chapterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapterData = ref
        .read(materialDetailProvider.notifier)
        .getChapterData(chapterId);

    return Center(
      child: Text('Placeholder for Chapter ${chapterData['title']}'),
    );
  }
}
