import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart'
    show PageRoute, RouteObserver, NavigatorState, GlobalKey;

import 'package:netlab/core/components/app_layout.dart' show AppLayout;

import 'package:netlab/home/home_screen.dart' show HomeScreen;
import 'package:netlab/settings/setting_screen.dart' show SettingScreen;
import 'package:netlab/simulation/simulation_screen.dart' show SimulationScreen;
import 'package:netlab/temp/homie/widgets/study_section/widgets/layouts/study.dart'
    show StudyScreen;
import 'package:netlab/temp/homie/widgets/dashboard/widgets/dashboard_screen.dart'
    show DashboardScreen;
import 'package:netlab/temp/homie/widgets/study_section/features/study_content/data/network_fundamentals_content.dart'
    show NetworkFundamentalsContent;
import 'package:netlab/temp/homie/widgets/study_section/features/study_content/data/routing_switching_content.dart'
    show RoutingSwitchingContent;
import 'package:netlab/temp/homie/widgets/study_section/features/study_content/data/network_devices.dart'
    show NetworkDevicesContent;
import 'package:netlab/temp/homie/widgets/study_section/features/study_content/data/host_to_host.dart'
    show HostToHostContent;
import 'package:netlab/temp/homie/widgets/study_section/core/models/study_topic.dart'
    show StudyTopic;

export 'package:go_router/go_router.dart';

final routeObserver = RouteObserver<PageRoute>();

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

class Routes {
  // Base paths
  static const home = '/home';
  static const settings = '/settings';
  static const study = '/study';
  static const dashboard = '/dashboard';

  // Relative paths
  static const simulationRelative = 'simulation';

  // Study topic relative paths
  static const networkFundamentalsRelative = 'network-fundamentals';
  static const switchingRoutingRelative = 'switching-routing';
  static const networkDevicesRelative = 'network-devices';
  static const hostToHostRelative = 'host-to-host';

  // Full paths
  static const simulation = '$home/$simulationRelative';
  static const networkFundamentals = '$study/$networkFundamentalsRelative';
  static const switchingRouting = '$study/$switchingRoutingRelative';
  static const networkDevices = '$study/$networkDevicesRelative';
  static const hostToHost = '$study/$hostToHostRelative';
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
          routes: [
            // Network Fundamentals - Full Screen
            GoRoute(
              path: Routes.networkFundamentalsRelative,
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) {
                final topic = state.extra as StudyTopic;
                return NetworkFundamentalsContent(topic: topic);
              },
            ),
            // Switching and Routing - Full Screen
            GoRoute(
              path: Routes.switchingRoutingRelative,
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) {
                final topic = state.extra as StudyTopic;
                return RoutingSwitchingContent(topic: topic);
              },
            ),
            // Network Devices - Full Screen
            GoRoute(
              path: Routes.networkDevicesRelative,
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) {
                final topic = state.extra as StudyTopic;
                return NetworkDevicesContent(topic: topic);
              },
            ),
            // Host-to-Host - Full Screen
            GoRoute(
              path: Routes.hostToHostRelative,
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) {
                final topic = state.extra as StudyTopic;
                return HostToHostContent(topic: topic);
              },
            ),
          ],
        ),
        GoRoute(
          path: Routes.dashboard,
          builder: (context, state) => const DashboardScreen(),
        ),
      ],
    ),
  ],
);
