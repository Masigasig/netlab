import 'package:flutter/material.dart';
import 'base_topic_content.dart';
import '../models/content_module.dart';

class DefaultTopicContent extends BaseTopicContent {
  const DefaultTopicContent({
    super.key,
    required super.topic,
  });

  @override
  List<ContentModule> getContentModules() {
    return [
      ContentModule(
        id: 'coming_soon',
        title: 'Coming Soon',
        description: 'This content is under development',
        icon: Icons.construction,
        duration: 0,
        type: ContentType.reading,
      ),
    ];
  }
}