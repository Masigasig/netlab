import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

import 'package:netlab/home/widgets/animated_network_background.dart';
import 'package:netlab/home/widgets/home_content.dart';
import 'package:netlab/home/widgets/home_visual_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          AnimatedNetworkBackground(
            numberOfNodes:
                (defaultTargetPlatform == TargetPlatform.android ||
                    defaultTargetPlatform == TargetPlatform.iOS)
                ? 100 // mobile
                : 200, // desktop/web
            nodeColor: cs.primary,
            backgroundColor: cs.surface,
            pointerNodeColor: cs.secondary,
            connectionOpacity: 0.25,
            connectionDistance: 125.0,
            pointerConnectionDistance: 150.0,
            nodeSpeed: 0.75,
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            child: Row(
              children: [
                Expanded(child: HomeContent()),
                SizedBox(width: 80),
                Expanded(child: HomeVisualCard()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
