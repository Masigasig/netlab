import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:netlab/core/constants/app_image.dart';
import 'package:netlab/temp/core/constants/app_colors.dart';

class GlobalAnimatedBackground extends StatelessWidget {
  final Widget child;

  const GlobalAnimatedBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Stack(
        children: [
          Positioned.fill(
            child: Lottie.asset(
              AppLottie.particle,
              fit: BoxFit.cover,
              repeat: true,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background,
                    AppColors.overlay,
                    AppColors.background,
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
