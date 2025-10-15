import 'package:flutter/material.dart';
import 'package:netlab/core/themes/app_theme.dart';
import 'package:netlab/temp/core/constants/app_text.dart';
import '../../quiz/controllers/quiz_controller.dart';

class QuizResultBottomSheet extends StatefulWidget {
  final ModuleQuizController quizController;
  final VoidCallback onRetry;

  const QuizResultBottomSheet({
    super.key,
    required this.quizController,
    required this.onRetry,
  });

  @override
  State<QuizResultBottomSheet> createState() => _QuizResultBottomSheetState();

  /// Show the bottom sheet with results
  static Future<void> show(
    BuildContext context, {
    required ModuleQuizController quizController,
    required VoidCallback onRetry,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuizResultBottomSheet(
        quizController: quizController,
        onRetry: onRetry,
      ),
    );
  }
}

class _QuizResultBottomSheetState extends State<QuizResultBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();

    // Trigger celebration if passed
    if (widget.quizController.hasPassed()) {
      _showCelebration();
    }
  }

  void _showCelebration() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        // wala pa po possible lottie lag
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final stats = widget.quizController.getStats();
    final percentage = stats['percentage'] as int;
    final correct = stats['correct'] as int;
    final total = stats['total'] as int;
    final passed = widget.quizController.hasPassed();

    Color performanceColor;
    String performanceText;
    String subtitle;
    IconData performanceIcon;

    if (percentage >= 80) {
      performanceColor = cs.primary;
      performanceText = 'Excellent Work!';
      subtitle = 'You\'ve mastered this topic!';
      performanceIcon = Icons.emoji_events;
    } else if (percentage >= 60) {
      performanceColor = Colors.orange;
      performanceText = 'Good Job!';
      subtitle = 'You\'re making great progress!';
      performanceIcon = Icons.thumb_up;
    } else {
      performanceColor = cs.errorContainer;
      performanceText = 'Keep Practicing!';
      subtitle = 'Review the material and try again!';
      performanceIcon = Icons.school;
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.onSurfaceVariant.withAlpha(102),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: Column(
                    children: [
                      // Animated icon
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: performanceColor.withAlpha(26),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            performanceIcon,
                            color: performanceColor,
                            size: 48,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Performance text
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            Text(
                              performanceText,
                              style: AppTextStyles.headerLarge.copyWith(
                                color: performanceColor,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              subtitle,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: performanceColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Score display
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: performanceColor.withAlpha(26),
                          borderRadius: BorderRadius.circular(
                            AppStyles.cardRadius,
                          ),
                          border: Border.all(
                            color: performanceColor.withAlpha(77),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Your Score',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: performanceColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '$percentage',
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: performanceColor,
                                    height: 1,
                                  ),
                                ),
                                Text(
                                  '%',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: performanceColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$correct out of $total correct',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: performanceColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Warning message if failed - shows passing score requirement
                      if (!passed)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cs.errorContainer,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: cs.error.withAlpha(128),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: cs.error,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Score ${ModuleQuizController.requiredScore}% or higher to unlock the next module',
                                  style: TextStyle(
                                    color: cs.onErrorContainer,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Sticky buttons at bottom
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.visibility),
                          label: const Text('Review Answers'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      if (!passed) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              widget.onRetry();
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Try Again'),
                            style: FilledButton.styleFrom(
                              backgroundColor: performanceColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
