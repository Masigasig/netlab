import 'package:flutter/material.dart';
import '../../models/study_topic.dart';
import 'package:netlab/core/constants/app_text.dart';

class WelcomeContentView extends StatelessWidget {
  final StudyTopic topic;

  const WelcomeContentView({
    super.key,
    required this.topic,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            Text(
              'Welcome to ${topic.title}',
              style: AppTextStyles.headerMedium.copyWith(
                fontSize: 26,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              topic.description,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 16,
                color: Colors.white.withOpacity(0.85),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Instruction box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_back,
                    color: Colors.white.withOpacity(0.7),
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Select a module from the sidebar to begin',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
