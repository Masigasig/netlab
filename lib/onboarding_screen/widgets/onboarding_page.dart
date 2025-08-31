import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
          Container(
            color: AppColors.overlay,
          ),
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
                          RepaintBoundary(
                            child: GradientText(
                              text: widget.title,
                              gradientWords: widget.gradientWords,
                              fontSize: 42,
                              textAlign: TextAlign.start,
                            ),
                          )
                          .animate(key: ValueKey('title_${widget.pageIndex}'))
                          .fadeIn(duration: 700.ms, curve: Curves.easeOut)
                          .blur(begin: const Offset(0, 5), duration: 700.ms, curve: Curves.easeOut)
                          .slideY(begin: 0.3, duration: 700.ms, curve: Curves.easeOutCubic),
                          
                          const SizedBox(height: 16),
                          Text(
                            widget.description,
                            style: AppTextStyles.secondaryCustom(
                              fontSize: 18,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          )
                          .animate(key: ValueKey('description_${widget.pageIndex}'))
                          .fadeIn(duration: 600.ms, delay: 300.ms, curve: Curves.easeOut)
                          .blur(begin: const Offset(0, 3), duration: 600.ms, delay: 300.ms, curve: Curves.easeOut)
                          .slideY(begin: 0.2, duration: 600.ms, delay: 300.ms, curve: Curves.easeOut), // Changed from slideX to slideY
                        ],
                      ),
                      
                      if (widget.bottomWidget != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: widget.bottomWidget!,
                        )
                        .animate(key: ValueKey('bottom_${widget.pageIndex}'))
                        .fadeIn(duration: 500.ms, delay: 800.ms, curve: Curves.easeOut)
                        .blur(begin: const Offset(0, 2), duration: 500.ms, delay: 800.ms, curve: Curves.easeOut)
                        .slideY(begin: 0.3, duration: 500.ms, delay: 800.ms, curve: Curves.easeOut),
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
                    child: Container(
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
                    )
                    .animate(key: ValueKey('lottie_${widget.pageIndex}'))
                    .fadeIn(duration: 800.ms, delay: 500.ms, curve: Curves.easeOut)
                    .scale(
                      begin: const Offset(0.7, 0.7), 
                      duration: 800.ms, 
                      delay: 500.ms, 
                      curve: Curves.easeOutBack,
                    )
                    .slideX(
                      begin: 0.2, 
                      duration: 800.ms, 
                      delay: 500.ms, 
                      curve: Curves.easeOutCubic,
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