import 'package:go_router/go_router.dart';
import 'package:netlab/home/home_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [

      ],
    ),
  ],
);