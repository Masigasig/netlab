import 'package:flutter/material.dart';
import '../../models/study_topic.dart';
import 'package:netlab/temp/core/constants/app_text.dart';

class TopicHeader extends StatelessWidget {
  final StudyTopic topic;
  final VoidCallback onBackPressed;

  const TopicHeader({
    super.key,
    required this.topic,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: cs.surface, // 🔹 background matches theme surface
        border: Border(
          bottom: BorderSide(
            color: cs.outline.withOpacity(0.15), // 🔹 subtle divider
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBackPressed,
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_back_ios,
                color: cs.onSurface, // 🔹 adapts to theme
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                topic.title,
                style: AppTextStyles.headerSmall.copyWith(
                  color: cs.onSurface, // 🔹 title adapts
                ),
              ),
              Text(
                'Course Content',
                style: AppTextStyles.subtitleSmall.copyWith(
                  color: cs.onSurface.withOpacity(0.7), // 🔹 subtitle softer
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
