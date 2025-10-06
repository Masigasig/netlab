import 'package:flutter/material.dart';
import 'package:netlab/temp/core/constants/app_text.dart';

class WelcomeCard extends StatelessWidget {
  final int streak;

  const WelcomeCard({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary, cs.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back!',
                style: AppTextStyles.forPrimary(
                  AppTextStyles.headerMedium,
                  context,
                ),
              ),
              // const SizedBox(height: 2),
              Text(
                'Keep up the great work on your learning journey',
                style: AppTextStyles.withOpacity(
                  AppTextStyles.forPrimary(
                    AppTextStyles.subtitleMedium,
                    context,
                  ),
                  0.9,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.local_fire_department, color: cs.onPrimary, size: 24),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$streak days',
                    style: AppTextStyles.forPrimary(
                      AppTextStyles.headerSmall,
                      context,
                    ),
                  ),
                  Text(
                    'Streak',
                    style: AppTextStyles.withOpacity(
                      AppTextStyles.forPrimary(
                        AppTextStyles.bodySmall,
                        context,
                      ),
                      0.9,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
