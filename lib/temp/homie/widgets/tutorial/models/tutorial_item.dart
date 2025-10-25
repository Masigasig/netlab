import 'package:flutter/material.dart';
import 'package:netlab/temp/homie/widgets/study_section/features/study_content/models/content_block.dart';

class TutorialItem {
  final String title;
  final String description;
  final IconData icon;
  final ModuleContent content;

  TutorialItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.content,
  });
}
