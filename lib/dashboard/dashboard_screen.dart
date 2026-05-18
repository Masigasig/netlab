import 'package:flutter/material.dart';

import 'package:netlab/core/components/animations.dart';
import 'package:netlab/dashboard/widgets/dashboard_sidebar.dart';
import 'package:netlab/dashboard/widgets/question_performance_card.dart';
import 'package:netlab/dashboard/widgets/stats_grid.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        // The sidebar grows with the viewport but stays in a usable range
        // so it never looks cramped on wide screens.
        final sidebarWidth = (constraints.maxWidth * 0.26)
            .clamp(300.0, 380.0)
            .toDouble();

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          horizontal: 28,
                          vertical: 18,
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
                                  fontSize: 24,
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
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: cs.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const StatsGrid(),
                    const SizedBox(height: 18),
                    AnimationPresets.textFadeIn(
                      delay: 300,
                      child: Text(
                        'Learning Progress',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 22,
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
            DashboardSidebar(width: sidebarWidth),
          ],
        );
      },
    );
  }
}
