import 'package:flutter/material.dart' show PageRoute, RouteObserver;
import 'package:go_router/go_router.dart';
import 'package:netlab/core/components/app_layout.dart';

import 'package:netlab/home/home_screen.dart';
import 'package:netlab/settings/setting_screen.dart';
import 'package:netlab/simulation/simulation_screen.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

final router = GoRouter(
  initialLocation: '/home',
  observers: [routeObserver],
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return AppLayout(child: child);
      },
      routes: [
        GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingScreen(),
        ),
      ],
    ),

    GoRoute(
      path: '/simulation',
      builder: (context, state) => const SimulationScreen(),
    ),
  ],
);
