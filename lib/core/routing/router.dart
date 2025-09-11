import 'package:go_router/go_router.dart';

import 'package:netlab/home/home_screen.dart';
import 'package:netlab/simulation/simulation_screen.dart';
import 'package:netlab/homie/home.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/homie', builder: (context, state) => const HomieScreen()),
    GoRoute(
      path: '/simulation',
      builder: (context, state) => const SimulationScreen(),
    ),
  ],
);
