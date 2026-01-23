import 'package:flutter/material.dart';

import 'package:netlab/core/components/animations.dart';

class HomeVisualCard extends StatelessWidget {
  const HomeVisualCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;
    final imagePath = isDarkMode
        ? 'assets/images/homeDark.png'
        : 'assets/images/homeLight.png';

    return Center(
      child: AnimationPresets.mediaEntrance(
        delay: 400,
        duration: const Duration(milliseconds: 900),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 500),
          decoration: BoxDecoration(
            color: cs.surface.withAlpha(204),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: cs.primary.withAlpha(51), width: 1),
            boxShadow: [
              BoxShadow(
                color: cs.primary.withAlpha(26),
                blurRadius: 20,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );
  }
}
