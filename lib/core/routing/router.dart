import 'package:go_router/go_router.dart';
import 'package:netlab/core/components/app_layout.dart';

import 'package:netlab/home/home_screen.dart';
import 'package:netlab/temp/homie/home.dart';

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return AppLayout(child: child);
      },
      routes: [
        GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const HomieScreen(),
        ),
      ],
    ),
  ],

  // routes: [
  //   GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
  //   GoRoute(path: '/homie', builder: (context, state) => const HomieScreen()),
  //   GoRoute(
  //     path: '/simulation',
  //     builder: (context, state) => const SimulationScreen(),
  //   ),
  // ],
);
