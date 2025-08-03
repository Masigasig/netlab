import 'package:go_router/go_router.dart';

import 'package:netlab/core/onboarding_screen/onboarding_screen.dart';
import 'package:netlab/home/home_screen.dart';
import 'package:netlab/simulation/simulation_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'simulation',
          builder: (context, state) => const SimulationScreen(),
        ),
      ],
    ),
  ],
);