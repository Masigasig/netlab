import 'package:flutter/material.dart';

class StudyTopic {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final Color cardColor;
  final int lessonCount;
  final String readTime;
  final bool isCompleted;
  final double progress;

  StudyTopic({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.cardColor,
    required this.lessonCount,
    required this.readTime,
    required this.isCompleted,
    required this.progress,
  });
}