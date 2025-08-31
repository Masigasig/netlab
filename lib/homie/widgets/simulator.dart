import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/components/gradient_text.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_image.dart';
import '../../core/constants/app_text.dart';
import '../../core/utils/lottie_optimization.dart';
import '../../core/components/button.dart' as custom_button;
import 'package:lottie/lottie.dart';

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
                      const GradientText(
                        text: 'Explore Network Simulation',
                        gradientWords: ['Simulation'],
                        fontSize: 39,
                        textAlign: TextAlign.start,
                      )
                      .animate()
                      .fadeIn(duration: 700.ms, curve: Curves.easeOut)
                      .blur(begin: const Offset(0, 5), duration: 700.ms, curve: Curves.easeOut)
                      .slideY(begin: 0.3, duration: 700.ms, curve: Curves.easeOutCubic),
                      
                      const SizedBox(height: 10),
                      Text(
                        'Practice network configuration in a safe, virtual lab with our interactive simulator.',
                        style: AppTextStyles.secondaryCustom(
                          fontSize: 18,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 300.ms, curve: Curves.easeOut)
                      .blur(begin: const Offset(0, 3), duration: 600.ms, delay: 300.ms, curve: Curves.easeOut)
                      .slideY(begin: 0.2, duration: 600.ms, delay: 300.ms, curve: Curves.easeOut),
                    ],
                  ),
                  
                  Expanded(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                              height: 55,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.secondary.withOpacity(0.8),
                                    AppColors.primary.withOpacity(0.8),
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
                                    // TODO: Save file
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
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
                          )
                          .animate()
                          .fadeIn(duration: 500.ms, delay: 600.ms, curve: Curves.easeOut)
                          .blur(begin: const Offset(0, 2), duration: 500.ms, delay: 600.ms, curve: Curves.easeOut)
                          .slideY(begin: 0.2, duration: 500.ms, delay: 600.ms, curve: Curves.easeOut)
                          .scale(begin: const Offset(0.9, 0.9), duration: 500.ms, delay: 600.ms, curve: Curves.easeOutBack),
                          
                          const SizedBox(width: 12),
                          Flexible(
                            child: Container(
                              height: 55,
                              decoration: BoxDecoration(
                                color: AppColors.textSecondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.textSecondary.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    // TODO: Load file
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
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
                          )
                          .animate()
                          .fadeIn(duration: 500.ms, delay: 700.ms, curve: Curves.easeOut)
                          .blur(begin: const Offset(0, 2), duration: 500.ms, delay: 700.ms, curve: Curves.easeOut)
                          .slideY(begin: 0.2, duration: 500.ms, delay: 700.ms, curve: Curves.easeOut)
                          .scale(begin: const Offset(0.9, 0.9), duration: 500.ms, delay: 700.ms, curve: Curves.easeOutBack),
                        ],
                      ),
                    ),
                  ),

                  Center(
                    child: SizedBox(
                      width: 200,
                      child: custom_button.ButtonStyle(
                        text: 'Simulate',
                        onPressed: () {
                          // TODO: Start simulation
                        },
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 900.ms, curve: Curves.easeOut)
                  .blur(begin: const Offset(0, 3), duration: 600.ms, delay: 900.ms, curve: Curves.easeOut)
                  .slideY(begin: 0.3, duration: 600.ms, delay: 900.ms, curve: Curves.easeOut)
                  .scale(begin: const Offset(0.8, 0.8), duration: 600.ms, delay: 900.ms, curve: Curves.easeOutBack),
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
              )
              .animate()
              .fadeIn(duration: 800.ms, delay: 500.ms, curve: Curves.easeOut)
              .blur(begin: const Offset(0, 4), duration: 800.ms, delay: 500.ms, curve: Curves.easeOut)
              .scale(begin: const Offset(0.7, 0.7), duration: 800.ms, delay: 500.ms, curve: Curves.easeOutBack)
              .slideY(begin: 0.2, duration: 800.ms, delay: 500.ms, curve: Curves.easeOutCubic),
            ),
          ),
        ],
      ),
    );
  }
}