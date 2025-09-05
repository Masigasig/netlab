import 'package:flutter/material.dart';

class ContentModule {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final int duration;
  final ContentType type;

  ContentModule({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.duration,
    required this.type,
  });
}

enum ContentType { video, reading, quiz, interactive, lab }
