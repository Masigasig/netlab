// homie/widgets/study_section/widgets/default_topic_content.dart
import 'package:flutter/material.dart';
import '../widgets/base_topic_content.dart';
import '../models/content_module.dart';

class ArpContent extends BaseTopicContent {
  const ArpContent({super.key, required super.topic});

  @override
  List<ContentModule> getContentModules() {
    return [
      ContentModule(
        id: 'coming_soon',
        title: 'Coming Soon',
        description:
            'This content is currently under development and will be available soon',
        icon: Icons.construction,
        duration: 0,
        type: ContentType.reading,
      ),
      ContentModule(
        id: 'placeholder_1',
        title: 'Content in Development',
        description: 'Additional learning materials are being prepared',
        icon: Icons.schedule,
        duration: 0,
        type: ContentType.video,
      ),
      ContentModule(
        id: 'placeholder_2',
        title: 'Future Updates',
        description:
            'More interactive content will be added in upcoming releases',
        icon: Icons.update,
        duration: 0,
        type: ContentType.interactive,
      ),
    ];
  }

  @override
  void onModuleTap(BuildContext context, ContentModule module) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'This content is coming soon! Stay tuned for updates.',
        ),
        backgroundColor: topic.cardColor.withValues(alpha: 0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}
