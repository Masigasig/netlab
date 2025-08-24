import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../core/components/gradient_text.dart';
import '../../core/utils/lottie_optimization.dart';
import 'package:netlab/core/constants/app_colors.dart';
import 'package:netlab/core/constants/app_text.dart';

class OnboardingPage extends StatefulWidget {
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
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          // Background container
          Container(
            color: AppColors.overlay,
          ),
          
          // Main layout
          Row(
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
                      // Title and description
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RepaintBoundary(
                            child: GradientText(
                              text: widget.title,
                              gradientWords: widget.gradientWords,
                              fontSize: 42,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.description,
                            style: AppTextStyles.secondaryCustom(
                              fontSize: 18,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                      
                      // Bottom widget
                      if (widget.bottomWidget != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: widget.bottomWidget!,
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
                    child: OptimizedLottieWidget(
                      key: ValueKey(widget.lottiePath),
                      assetPath: widget.lottiePath,
                      constraints: const BoxConstraints(maxHeight: 450),
                      repeat: true,
                      animate: true,
                      frameRate: const FrameRate(30),
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      backgroundColor: AppColors.textSecondary,
                      borderRadius: BorderRadius.circular(16),
                      errorMessage: 'Onboarding animation unavailable',
                      showStatusText: false,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}