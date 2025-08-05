import 'package:go_router/go_router.dart';

import 'package:netlab/onboarding_screen/onboarding_screen.dart';
//import 'package:netlab/home/home_screen.dart';
import 'package:netlab/simulation/simulation_screen.dart';
import 'package:netlab/homie/home.dart';


final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/homie',
      builder: (context, state) => const HomieScreen(),
      routes: [
        GoRoute(
          path: 'simulation',
          builder: (context, state) => const SimulationScreen(),
        ),
      ],
    ),
  ],
);