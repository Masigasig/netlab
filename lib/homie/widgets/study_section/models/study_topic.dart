import 'package:flutter/material.dart';

class StudyTopic {
  final String id;
  final String title;
  final String description;
  final Color cardColor;
  final IconData icon;

  StudyTopic({
    required this.id,
    required this.title,
    required this.description,
    required this.cardColor,
    required this.icon,
  });
}