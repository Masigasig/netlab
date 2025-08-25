import 'package:flutter/material.dart';
import '../../models/study_topic.dart';
import 'package:netlab/core/constants/app_text.dart';
import 'package:netlab/core/constants/app_colors.dart'; // Import your colors

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
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.background, // Use your app background color
        border: Border(
          bottom: BorderSide(
            color: Color(0x1AFFFFFF), // Same opacity as sidebar divider
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
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
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
                style: AppTextStyles.headerSmall,
              ),
              Text(
                'Course Content',
                style: AppTextStyles.subtitleSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}