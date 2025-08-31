import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
            // Title - appears first
            Text(
              'Welcome to ${topic.title}',
              style: AppTextStyles.headerMedium.copyWith(
                fontSize: 26,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            )
            .animate()
            .fadeIn(duration: 700.ms, curve: Curves.easeOut)
            .blur(begin: const Offset(0, 4), duration: 700.ms, curve: Curves.easeOut)
            .slideY(begin: 0.3, duration: 700.ms, curve: Curves.easeOutCubic)
            .scale(begin: const Offset(0.9, 0.9), duration: 700.ms, curve: Curves.easeOut),

            const SizedBox(height: 16),

            // Description - appears second
            Text(
              topic.description,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 16,
                color: Colors.white.withOpacity(0.85),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            )
            .animate()
            .fadeIn(duration: 600.ms, delay: 300.ms, curve: Curves.easeOut)
            .blur(begin: const Offset(0, 3), duration: 600.ms, delay: 300.ms, curve: Curves.easeOut)
            .slideY(begin: 0.2, duration: 600.ms, delay: 300.ms, curve: Curves.easeOut),

            const SizedBox(height: 32),

            // Instruction box - appears last
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
                  )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 800.ms, curve: Curves.easeOut)
                  .slideX(begin: -0.3, duration: 400.ms, delay: 800.ms, curve: Curves.easeOut),
                  
                  const SizedBox(width: 10),
                  
                  Text(
                    'Select a module from the sidebar to begin',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 900.ms, curve: Curves.easeOut),
                ],
              ),
            )
            .animate()
            .fadeIn(duration: 500.ms, delay: 600.ms, curve: Curves.easeOut)
            .blur(begin: const Offset(0, 2), duration: 500.ms, delay: 600.ms, curve: Curves.easeOut)
            .slideY(begin: 0.2, duration: 500.ms, delay: 600.ms, curve: Curves.easeOut)
            .scale(begin: const Offset(0.95, 0.95), duration: 500.ms, delay: 600.ms, curve: Curves.easeOutBack),
          ],
        ),
      ),
    );
  }
}