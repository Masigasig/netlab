import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../core/components/gradient_text.dart';
import 'package:netlab/core/constants/app_colors.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String lottiePath;
  final Widget? bottomWidget;
  final List<String> gradientWords;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.lottiePath,
    this.bottomWidget,
    this.gradientWords = const ['NetLab', 'Build', 'Simulate'],
  });

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return SizedBox.expand(
      child: Stack(
        children: [
          Container(
            color: AppColors.overlay,
          ),
          isLandscape
              ? Row(
                  children: [
                    // Left side
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
                                GradientText(
                                  text: title,
                                  gradientWords: gradientWords,
                                  fontSize: 42,
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  description,
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    color: AppColors.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                            if (bottomWidget != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: bottomWidget!,
                              ),
                          ],
                        ),
                      ),
                    ),

                    // Right side
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 450),
                            child: Lottie.asset(lottiePath),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(lottiePath, height: 250),
                    const SizedBox(height: 20),
                    GradientText(
                      text: title,
                      gradientWords: gradientWords,
                      fontSize: 32,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        description,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (bottomWidget != null) bottomWidget!,
                  ],
                ),
        ],
      ),
    );
  }
}