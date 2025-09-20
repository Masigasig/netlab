import 'package:flutter/material.dart';
import '../../models/study_topic.dart';
import 'package:netlab/temp/core/components/animations.dart';
import 'package:netlab/temp/core/constants/app_text.dart';

class WelcomeContentView extends StatelessWidget {
  final StudyTopic topic;

  const WelcomeContentView({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            AnimationPresets.titleFadeIn(
              child: Text(
                'Welcome to ${topic.title}',
                style: AppTextStyles.headerMedium.copyWith(
                  fontSize: 26,
                  color: cs.onSurface.withOpacity(0.9), // 🔹 adaptive text color
                ),
                textAlign: TextAlign.center,
              ),
              delay: 0,
              duration: const Duration(milliseconds: 700),
            ),

            const SizedBox(height: 16),

            // Description
            AnimationPresets.textFadeIn(
              child: Text(
                topic.description,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 16,
                  color: cs.onSurface.withOpacity(0.7), // 🔹 softer theme-based text
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              delay: 300,
              duration: const Duration(milliseconds: 600),
            ),

            const SizedBox(height: 32),

            // Info box
            AnimationPresets.cardEntrance(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerLow, // 🔹 themed background
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: cs.outline.withOpacity(0.15),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimationPresets.iconSlide(
                      child: Icon(
                        Icons.arrow_back,
                        color: cs.onSurfaceVariant, // 🔹 softer icon
                        size: 18,
                      ),
                      delay: 800,
                      duration: const Duration(milliseconds: 400),
                      slideFrom: -0.3,
                    ),

                    const SizedBox(width: 10),

                    AnimationPresets.textFadeIn(
                      child: Text(
                        'Select a module from the sidebar to begin',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 14,
                          color: cs.onSurface.withOpacity(0.7), // 🔹 adaptive
                        ),
                      ),
                      delay: 900,
                      duration: const Duration(milliseconds: 400),
                      slideDistance: 0.0,
                      blurAmount: 0.0,
                    ),
                  ],
                ),
              ),
              delay: 600,
              duration: const Duration(milliseconds: 500),
              scaleFrom: 0.95,
            ),
          ],
        ),
      ),
    );
  }
}
