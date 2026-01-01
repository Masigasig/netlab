import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:netlab/core/components/app_layout.dart';
import 'package:netlab/dashboard/dashboard_screen.dart';
import 'package:netlab/dashboard/study/study_screen.dart';
import 'package:netlab/dashboard/study/widgets/chapter_quiz_screen.dart';
import 'package:netlab/dashboard/study/widgets/chapter_screen.dart';
import 'package:netlab/dashboard/study/widgets/default_content.dart';
import 'package:netlab/dashboard/study/widgets/lesson_content.dart';
import 'package:netlab/tools/tool_screen.dart';
import 'package:netlab/home/home_screen.dart';
import 'package:netlab/home/simulation/simulation_screen.dart';
import 'package:netlab/settings/setting_screen.dart';
import 'package:netlab/tutorial/tutorial_screen.dart';

export 'package:go_router/go_router.dart';

final routeObserver = RouteObserver<PageRoute>();

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

class Routes {
  //* Base paths
  static const dashboard = '/dashboard';
  static const tools = '/tools';
  static const home = '/';
  static const tutorial = '/tutorial';
  static const settings = '/settings';

  //* Relative paths
  static const studyRelative = 'study';
  static const simulationRelative = 'simulation';

  //* Full paths
  static const simulation = '$home$simulationRelative';
  static const study = '$dashboard/$studyRelative';
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
              routes: [
                ShellRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state, child) {
                    final chapterId = state.pathParameters['chapterId']!;
                    return ChapterScreen(chapterId: chapterId, child: child);
                  },
                  routes: [
                    GoRoute(
                      path: ':chapterId',
                      builder: (context, state) {
                        final chapterId = state.pathParameters['chapterId']!;
                        return DefaultContent(chapterId: chapterId);
                      },
                      routes: [
                        GoRoute(
                          path: ':lessonId',
                          builder: (context, state) {
                            final lessonId = state.pathParameters['lessonId']!;
                            final chapterId =
                                state.pathParameters['chapterId']!;

                            if (lessonId == 'chapter_quiz') {
                              return ChapterQuizScreen(chapterId: chapterId);
                            }

                            return LessonContent(
                              chapterId: chapterId,
                              lessonId: lessonId,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
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
          path: Routes.settings,
          builder: (context, state) => const SettingScreen(),
        ),
      ],
    ),
  ],
);
