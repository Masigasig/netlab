import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart'
    show PageRoute, RouteObserver, NavigatorState, GlobalKey;

import 'package:netlab/core/components/app_layout.dart';

import 'package:netlab/dashboard/dashboard_screen.dart';
import 'package:netlab/dashboard/study/study_screen.dart';
import 'package:netlab/tools/tool_screen.dart';
import 'package:netlab/home/home_screen.dart';
import 'package:netlab/settings/setting_screen.dart';

import 'package:netlab/simulation/simulation_screen.dart';

import 'package:netlab/temp/homie/widgets/study_section/widgets/layouts/study.dart';
import 'package:netlab/temp/homie/widgets/dashboard/widgets/dashboard_screen.dart';
import 'package:netlab/temp/homie/widgets/study_section/features/study_content/data/network_fundamentals_content.dart';
import 'package:netlab/temp/homie/widgets/study_section/features/study_content/data/routing_switching_content.dart';
import 'package:netlab/temp/homie/widgets/study_section/features/study_content/data/network_devices.dart';
import 'package:netlab/temp/homie/widgets/study_section/features/study_content/data/host_to_host.dart';
import 'package:netlab/temp/homie/widgets/study_section/features/study_content/data/subnetting.dart';
import 'package:netlab/temp/homie/widgets/study_section/features/study_content/services/study_topic_service.dart';
import 'package:netlab/temp/homie/widgets/tutorial/tutorial_screen.dart';

export 'package:go_router/go_router.dart';

final routeObserver = RouteObserver<PageRoute>();

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

class Routes {
  // Add splash route
  static const splash = '/';

  // Base paths
  static const dashboard = '/dashboard';
  static const tools = '/tools';
  static const home = '/home';
  static const tutorial = '/tutorial';
  static const settings = '/settings';

  static const tempDashBoard = '/tempDashboard';
  static const tempStudy = '/tempStudy';

  // Relative paths

  static const studyRelative = 'study';
  static const simulationRelative = 'simulation';

  static const networkFundamentalsRelative = 'network-fundamentals';
  static const switchingRoutingRelative = 'switching-routing';
  static const networkDevicesRelative = 'network-devices';
  static const hostToHostRelative = 'host-to-host';
  static const subnettingRelative = 'subnetting';

  // Full paths
  static const simulation = '$home/$simulationRelative';
  static const study = '$dashboard/$studyRelative';

  static const networkFundamentals = '$tempStudy/$networkFundamentalsRelative';
  static const switchingRouting = '$tempStudy/$switchingRoutingRelative';
  static const networkDevices = '$tempStudy/$networkDevicesRelative';
  static const hostToHost = '$tempStudy/$hostToHostRelative';
  static const subnetting = '$tempStudy/$subnettingRelative';
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
          path: Routes.dashboard,
          builder: (context, state) => const DashboardScreen(),
          routes: [
            GoRoute(
              path: Routes.studyRelative,
              builder: (context, state) => const StudyScreen(),
            ),
          ],
        ),
        GoRoute(
          path: Routes.tempDashBoard,
          builder: (context, state) => const TempDashboardScreen(),
        ),
        GoRoute(
          path: Routes.tools,
          builder: (context, state) => const ToolScreen(),
        ),
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
          path: Routes.tutorial,
          builder: (context, state) => const TutorialScreen(),
        ),
        GoRoute(
          path: Routes.tempStudy,
          builder: (context, state) => const TempStudyScreen(),
          routes: [
            GoRoute(
              path: Routes.networkFundamentalsRelative,
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) {
                final (
                  topic,
                  initialModuleId,
                ) = StudyTopicsService.extractTopicData(
                  state,
                  'network_fundamentals',
                );

                return NetworkFundamentalsContent(
                  topic: topic,
                  initialModuleId: initialModuleId,
                );
              },
            ),
            GoRoute(
              path: Routes.switchingRoutingRelative,
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) {
                final (
                  topic,
                  initialModuleId,
                ) = StudyTopicsService.extractTopicData(
                  state,
                  'switching_routing',
                );

                return RoutingSwitchingContent(
                  topic: topic,
                  initialModuleId: initialModuleId,
                );
              },
            ),
            GoRoute(
              path: Routes.networkDevicesRelative,
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) {
                final (
                  topic,
                  initialModuleId,
                ) = StudyTopicsService.extractTopicData(
                  state,
                  'network_devices',
                );

                return NetworkDevicesContent(
                  topic: topic,
                  initialModuleId: initialModuleId,
                );
              },
            ),
            GoRoute(
              path: Routes.hostToHostRelative,
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) {
                final (topic, initialModuleId) =
                    StudyTopicsService.extractTopicData(state, 'host_to_host');

                return HostToHostContent(
                  topic: topic,
                  initialModuleId: initialModuleId,
                );
              },
            ),
            GoRoute(
              path: Routes.subnettingRelative,
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) {
                final (topic, initialModuleId) =
                    StudyTopicsService.extractTopicData(state, 'subnetting');

                return SubnettingContent(
                  topic: topic,
                  initialModuleId: initialModuleId,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: Routes.settings,
          builder: (context, state) => const SettingScreen(),
        ),
      ],
    ),
  ],
);
