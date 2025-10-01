import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart'
    show PageRoute, RouteObserver, NavigatorState, GlobalKey;

import 'package:netlab/core/components/app_layout.dart' show AppLayout;

import 'package:netlab/home/home_screen.dart' show HomeScreen;
import 'package:netlab/settings/setting_screen.dart' show SettingScreen;
import 'package:netlab/simulation/simulation_screen.dart' show SimulationScreen;
import 'package:netlab/temp/homie/widgets/study_section/widgets/layouts/study.dart'
    show StudyScreen;

export 'package:go_router/go_router.dart';

final routeObserver = RouteObserver<PageRoute>();

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

class Routes {
  // Base paths
  static const home = '/home';
  static const settings = '/settings';
  static const study = '/study';

  // Relative paths
  static const simulationRelative = 'simulation';

  // Full paths
  static const simulation = '$home/$simulationRelative';
}

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.home,
  debugLogDiagnostics: true,
  observers: [routeObserver],
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return AppLayout(child: child);
      },
      routes: [
        GoRoute(
          path: Routes.home,
          builder: (context, state) => const HomeScreen(),
          routes: [
            GoRoute(
              path: Routes.simulationRelative,
              //* This makes the simulation screen open as a full screen dialog over the AppLayout
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => const SimulationScreen(),
            ),
          ],
        ),
        GoRoute(
          path: Routes.settings,
          builder: (context, state) => const SettingScreen(),
        ),
        GoRoute(
          path: Routes.study,
          builder: (context, state) => const StudyScreen(),
        ),
      ],
    ),
  ],
);
