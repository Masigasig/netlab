import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:netlab/core/components/animations.dart';
import '../../temp/core/constants/app_text.dart';
import 'gradient_text.dart';
import 'package:netlab/core/routing/go_router.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Welcome Badge
        AnimationPresets.cardEntrance(
          delay: 100,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cs.primary.withAlpha(26), cs.secondary.withAlpha(26)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: cs.primary.withAlpha(77), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedStars,
                  color: cs.primary,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Welcome to',
                  style: AppTextStyles.custom(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ).copyWith(color: cs.primary),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Title
        AnimationPresets.titleFadeIn(
          delay: 300,
          child: CustomGradientText(
            text: 'NetLab Network Simulator',
            gradientWords: const ['NetLab'],
            fontSize: 40,
            fontWeight: FontWeight.w600,
            letterSpacing: -1,
            height: 1.1,
            textAlign: TextAlign.left,
            gradientColors: [cs.primary, cs.secondary],
            defaultColor: cs.onSurface,
          ),
        ),
        const SizedBox(height: 12),

        // Description
        AnimationPresets.textFadeIn(
          delay: 500,
          child: Text(
            'Build and simulate network topologies in a hands-on learning environment.',
            style: AppTextStyles.custom(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              height: 1.6,
            ).copyWith(color: cs.onSurface.withAlpha(179)),
          ),
        ),
        const SizedBox(height: 16),

        // CTA Buttons
        Row(
          children: [
            AnimationPresets.buttonBounce(
              delay: 700,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [cs.primary, cs.secondary]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/simulation');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: cs.onPrimary,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Start Simulation',
                        style: AppTextStyles.custom(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const HugeIcon(
                        icon: HugeIcons.strokeRoundedArrowRight02,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            AnimationPresets.buttonBounce(
              delay: 850,
              child: OutlinedButton(
                onPressed: () {
                  context.go(Routes.study);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: cs.onSurface,
                  side: BorderSide(color: cs.onSurface.withAlpha(77)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedBookOpen02,
                      color: cs.onSurface,
                      size: 14,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Learn More',
                      style: AppTextStyles.custom(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
