import 'package:flutter/material.dart';
import 'tutorial_item.dart';

class TutorialSection {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final List<TutorialItem> items;

  TutorialSection({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.items,
  });
}
