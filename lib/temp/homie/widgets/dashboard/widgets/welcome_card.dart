import 'package:flutter/material.dart';

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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: cs.onPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Keep up the great work on your learning journey',
                style: TextStyle(
                  fontSize: 13,
                  color: cs.onPrimary.withAlpha(230),
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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: cs.onPrimary,
                    ),
                  ),
                  Text(
                    'Streak',
                    style: TextStyle(
                      fontSize: 12,
                      color: cs.onPrimary.withAlpha(230),
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
