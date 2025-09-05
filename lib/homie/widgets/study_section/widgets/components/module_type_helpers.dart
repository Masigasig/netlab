import 'package:flutter/material.dart';
import '../../models/content_module.dart';

class ModuleTypeHelpers {
  static Color getTypeColor(ContentType type) {
    switch (type) {
      case ContentType.video:
        return Colors.red.withValues(alpha: 0.7);
      case ContentType.reading:
        return Colors.blue.withValues(alpha: 0.7);
      case ContentType.quiz:
        return Colors.orange.withValues(alpha: 0.7);
      case ContentType.interactive:
        return Colors.purple.withValues(alpha: 0.7);
      case ContentType.lab:
        return Colors.green.withValues(alpha: 0.7);
    }
  }

  static String getTypeLabel(ContentType type) {
    switch (type) {
      case ContentType.video:
        return 'VIDEO';
      case ContentType.reading:
        return 'READING';
      case ContentType.quiz:
        return 'QUIZ';
      case ContentType.interactive:
        return 'INTERACTIVE';
      case ContentType.lab:
        return 'LAB';
    }
  }

  static String getShortTypeLabel(ContentType type) {
    switch (type) {
      case ContentType.video:
        return 'VIDEO';
      case ContentType.reading:
        return 'READ';
      case ContentType.quiz:
        return 'QUIZ';
      case ContentType.interactive:
        return 'INTER';
      case ContentType.lab:
        return 'LAB';
    }
  }

  static IconData getActionIcon(ContentType type) {
    switch (type) {
      case ContentType.video:
        return Icons.play_arrow;
      case ContentType.reading:
        return Icons.menu_book;
      case ContentType.quiz:
        return Icons.quiz;
      case ContentType.interactive:
        return Icons.touch_app;
      case ContentType.lab:
        return Icons.science;
    }
  }
}
