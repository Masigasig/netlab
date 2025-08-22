import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/components/gradient_text.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_image.dart';
import 'package:lottie/lottie.dart';
import '../../core/components/button.dart' as custom_button;

class SimulatorScreen extends StatelessWidget {
  const SimulatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Row(
        children: [
          // Left side - Content
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const GradientText(
                        text: 'Explore Network Simulation',
                        gradientWords: ['Simulation'],
                        fontSize: 42,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Practice network configuration in a safe, virtual lab with our interactive simulator.',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // File operation buttons
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              // TODO: Save file
                            },
                            icon: const Icon(Icons.save_rounded, color: Colors.white),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.1),
                              padding: const EdgeInsets.all(12),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () {
                              // TODO: Load file
                            },
                            icon: const Icon(Icons.folder_open_rounded, color: Colors.white),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.1),
                              padding: const EdgeInsets.all(12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Bottom start button
                  custom_button.ButtonStyle(
                    text: 'Start Simulation',
                    onPressed: () {
                      // TODO: Start simulation
                    },
                  ),
                ],
              ),
            ),
          ),

          // Right side - Animation
          Expanded( 
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Align(
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 450),
                  child: Lottie.asset(AppLottie.circle),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
