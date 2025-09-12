import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../core/components/gradient_text.dart';
import '../../core/utils/lottie_optimization.dart';
import '../../core/components/animations.dart';
import 'package:netlab/temp/core/constants/app_colors.dart';
import 'package:netlab/temp/core/constants/app_text.dart';

class OnboardingPage extends StatefulWidget {
  final String title;
  final String description;
  final String lottiePath;
  final Widget? bottomWidget;
  final List<String> gradientWords;
  final int pageIndex;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.lottiePath,
    required this.pageIndex,
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
          Container(color: AppColors.overlay),
          Row(
            children: [
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
                          AnimationPresets.titleFadeIn(
                            child: RepaintBoundary(
                              child: GradientText(
                                text: widget.title,
                                gradientWords: widget.gradientWords,
                                fontSize: 42,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            delay: 0,
                            duration: const Duration(milliseconds: 700),
                          ),

                          const SizedBox(height: 16),

                          AnimationPresets.textFadeIn(
                            child: Text(
                              widget.description,
                              style: AppTextStyles.secondaryCustom(
                                fontSize: 18,
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                            delay: 300,
                            duration: const Duration(milliseconds: 600),
                          ),
                        ],
                      ),

                      if (widget.bottomWidget != null)
                        AnimationPresets.buttonBounce(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: widget.bottomWidget!,
                          ),
                          delay: 800,
                          duration: const Duration(milliseconds: 500),
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
                      delay: 500,
                      duration: const Duration(milliseconds: 800),
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
