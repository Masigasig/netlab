import 'package:flutter/material.dart';

import 'package:netlab/dashboard/widgets/dashboard_sidebar.dart';
import 'package:netlab/dashboard/widgets/question_performance_card.dart';
import 'package:netlab/dashboard/widgets/stats_grid.dart';
import 'package:netlab/temp/core/components/animations.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimationPresets.cardEntrance(
                  scaleFrom: 0.95,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [cs.primary, cs.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimationPresets.titleFadeIn(
                          child: Text(
                            'Welcome back!',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: cs.onPrimary,
                            ),
                          ),
                        ),
                        AnimationPresets.textFadeIn(
                          delay: 200,
                          child: Text(
                            'Keep up the great work on your learning journey',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: cs.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                const SizedBox(height: 14),
                const StatsGrid(),
                const SizedBox(height: 14),
                AnimationPresets.textFadeIn(
                  delay: 300,
                  child: Text(
                    'Learning Progress',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const QuestionPerformanceCard(),
              ],
            ),
          ),
        ),
        const DashboardSidebar(),
      ],
    );
  }
}
