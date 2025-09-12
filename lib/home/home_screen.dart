import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:netlab/home/widgets/menu_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('HomeScreen Widget rebuilt');
    return Scaffold(
      appBar: AppBar(title: const Text('NetLab Home')),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 400),
          child: MenuButton(
            icon: Icons.play_circle_fill,
            label: 'Open Simulation',
            onPressed: () {
              context.go('/simulation');
            },
          ),
        ),
      ),
    );
  }
}
