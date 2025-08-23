import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../core/components/gradient_text.dart';
import '../../core/utils/lottie_optimization.dart';
import 'package:netlab/core/constants/app_colors.dart';

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
  late final TextStyle _descriptionStyle;

  @override
  void initState() {
    super.initState();
    
    // Cache text style to avoid recreation
    _descriptionStyle = GoogleFonts.inter(
      fontSize: 18,
      color: AppColors.textSecondary,
      height: 1.4,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          // Background container
          Container(
            color: AppColors.overlay,
          ),
          
          // Main landscape layout
          Row(
            children: [
              // Left side - Text content
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
                            style: _descriptionStyle,
                          ),
                        ],
                      ),
                      
                      // Bottom widget (if provided)
                      if (widget.bottomWidget != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: widget.bottomWidget!,
                        ),
                    ],
                  ),
                ),
              ),

              // Right side - Lottie animation using the reusable widget
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: OptimizedLottieWidget(
                      key: ValueKey(widget.lottiePath), // Add key to ensure proper widget recycling
                      assetPath: widget.lottiePath,
                      constraints: const BoxConstraints(maxHeight: 450),
                      repeat: true,
                      animate: true,
                      frameRate: const FrameRate(30),
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      backgroundColor: AppColors.textSecondary.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(16),
                      errorMessage: 'Onboarding animation unavailable',
                      showStatusText: false, // Hide loading text for cleaner look
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