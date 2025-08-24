import 'package:flutter/material.dart';
import '../models/content_module.dart';
import 'package:netlab/core/constants/app_text.dart'; // Import your text styles

class ContentModuleItem extends StatelessWidget {
  final ContentModule module;
  final VoidCallback onTap;

  const ContentModuleItem({
    super.key,
    required this.module,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getTypeColor(),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            module.icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          module.title,
          style: AppTextStyles.primaryCustom(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          '${module.description} • ${module.duration} min',
          style: AppTextStyles.secondaryCustom(
            fontSize: 12,
            color: const Color(0xB3FFFFFF), // Colors.white with ~70% opacity as solid color
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getTypeColor(),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _getTypeLabel(),
            style: AppTextStyles.primaryCustom(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Color _getTypeColor() {
    switch (module.type) {
      case ContentType.video:
        return Colors.red.withOpacity(0.7);
      case ContentType.reading:
        return Colors.blue.withOpacity(0.7);
      case ContentType.quiz:
        return Colors.orange.withOpacity(0.7);
      case ContentType.interactive:
        return Colors.purple.withOpacity(0.7);
      case ContentType.lab:
        return Colors.green.withOpacity(0.7);
    }
  }

  String _getTypeLabel() {
    switch (module.type) {
      case ContentType.video:
        return 'VIDEO';
      case ContentType.reading:
        return 'READ';
      case ContentType.quiz:
        return 'QUIZ';
      case ContentType.interactive:
        return 'INTERACTIVE';
      case ContentType.lab:
        return 'LAB';
    }
  }
}