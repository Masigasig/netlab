import 'package:flutter/material.dart';
import 'widgets/home_content.dart';
import 'widgets/home_visual_card.dart';
import 'widgets/background_grid_pattern.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          BackgroundGridPattern(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              child: Row(
                children: [
                  Expanded(child: HomeContent()),
                  SizedBox(width: 80),
                  Expanded(child: HomeVisualCard()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
