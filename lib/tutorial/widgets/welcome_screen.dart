import 'package:flutter/material.dart';
import 'package:netlab/core/constants/app_text.dart';
import 'package:netlab/core/components/animations.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      color: cs.surface,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimationPresets.mediaEntrance(
              delay: 0,
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: cs.primaryContainer.withAlpha(77),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.school_outlined, size: 80, color: cs.primary),
              ),
            ),
            const SizedBox(height: 32),
            AnimationPresets.titleFadeIn(
              delay: 400,
              child: Text(
                'Choose a topic to get started',
                style: AppTextStyles.forSurface(
                  AppTextStyles.headerLarge,
                  context,
                ),
              ),
            ),
            const SizedBox(height: 12),
            AnimationPresets.textFadeIn(
              delay: 600,
              child: Text(
                'Select from the topics on the left to begin learning',
                style: AppTextStyles.forSurface(
                  AppTextStyles.bodyLarge,
                  context,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
