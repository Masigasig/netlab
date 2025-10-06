import 'package:flutter/material.dart';
import '../../core/components/gradient_text.dart';
import '../../core/components/animations.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_image.dart';
import '../../core/constants/app_text.dart';
import '../../core/utils/lottie_optimization.dart';
import '../../core/components/button.dart' as custom_button;
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';

class SimulatorScreen extends StatelessWidget {
  const SimulatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimationPresets.titleFadeIn(
                        child: const GradientText(
                          text: 'Explore Network Simulation',
                          gradientWords: ['Simulation'],
                          fontSize: 39,
                          textAlign: TextAlign.start,
                        ),
                        delay: 0,
                        duration: const Duration(milliseconds: 700),
                      ),

                      const SizedBox(height: 10),

                      AnimationPresets.textFadeIn(
                        child: Text(
                          'Practice network configuration in a safe, virtual lab with our interactive simulator.',
                          style: AppTextStyles.forSecondary(
                            AppTextStyles.secondaryCustom(
                              fontSize: 18,
                              height: 1.4,
                            ),
                            context,
                          ),
                        ),
                        delay: 300,
                        duration: const Duration(milliseconds: 600),
                      ),
                    ],
                  ),

                  Expanded(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimationPresets.cardEntrance(
                            child: Flexible(
                              child: Container(
                                height: 55,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.secondary.withValues(
                                        alpha: 0.8,
                                      ),
                                      AppColors.primary.withValues(alpha: 0.8),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      //? Will Remove
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.save_rounded,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Save',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            delay: 600,
                            duration: const Duration(milliseconds: 500),
                            scaleFrom: 0.9,
                          ),

                          const SizedBox(width: 12),

                          AnimationPresets.cardEntrance(
                            child: Flexible(
                              child: Container(
                                height: 55,
                                decoration: BoxDecoration(
                                  color: AppColors.textSecondary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.textSecondary.withValues(
                                      alpha: 0.3,
                                    ),
                                    width: 1,
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      //? Will Remove
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.folder_open_rounded,
                                            color: AppColors.textSecondary,
                                            size: 20,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Load',
                                            style: TextStyle(
                                              color: AppColors.textSecondary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            delay: 700,
                            duration: const Duration(milliseconds: 500),
                            scaleFrom: 0.9,
                          ),
                        ],
                      ),
                    ),
                  ),

                  AnimationPresets.buttonBounce(
                    child: Center(
                      child: SizedBox(
                        width: 200,
                        child: custom_button.ButtonStyle(
                          text: 'Simulate',
                          onPressed: () {
                            context.go('/simulation');
                          },
                        ),
                      ),
                    ),
                    delay: 900,
                    duration: const Duration(milliseconds: 600),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Align(
                alignment: Alignment.center,
                child: AnimationPresets.mediaEntrance(
                  child: OptimizedLottieWidget(
                    key: const ValueKey('simulator_animation'),
                    assetPath: AppLottie.circle,
                    constraints: const BoxConstraints(maxHeight: 450),
                    repeat: true,
                    animate: true,
                    frameRate: const FrameRate(30),
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    backgroundColor: AppColors.textSecondary,
                    borderRadius: BorderRadius.circular(16),
                    errorMessage: 'Simulation animation unavailable',
                    showStatusText: false,
                  ),
                  delay: 500,
                  duration: const Duration(milliseconds: 800),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
