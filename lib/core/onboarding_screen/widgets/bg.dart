import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:netlab/core/constants/app_image.dart';

class GlobalAnimatedBackground extends StatelessWidget {
  final Widget child;

  const GlobalAnimatedBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0B0F1E),
      child: Stack(
        children: [
          Positioned.fill(
            child: Lottie.asset(
              AppLottie.particle,
              fit: BoxFit.cover,
              repeat: true,
            ),
          ),
          // this is gradient man idk if its cool or what still on experiment
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0B0F1E),
                    Color(0x000B0F1E),
                    Color(0xFF0B0F1E),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
