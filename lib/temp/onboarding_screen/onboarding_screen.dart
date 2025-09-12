import 'package:flutter/material.dart';
import 'widgets/onboarding_page.dart';
import 'widgets/page_indicator.dart';
import '../core/components/button.dart' as custom_button;
import '../core/components/animations.dart';
import 'package:netlab/core/constants/app_image.dart';
import 'widgets/bg.dart';
import 'package:go_router/go_router.dart';
import 'package:netlab/temp/core/constants/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  bool _isAnimating = false;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Welcome to NetLab!',
      'description':
          'Discover how computer networks work — no cables, no configurations. Just simple, hands-on learning built for students and educators.',
      'lottie': AppLottie.kid,
    },
    {
      'title': 'Build & Connect Your Network.',
      'description':
          'Use drag-and-drop tools to create network topologies. Connect routers, switches, and PCs to visualize how real networks function.',
      'lottie': AppLottie.floating,
    },
    {
      'title': 'Simulate. Learn. Repeat.',
      'description':
          'Simulate basic networking scenarios to reinforce classroom concepts. Whether you\'re a beginner or teaching others, learning is just a tap away.',
      'lottie': AppLottie.kid2,
    },
  ];

  void _nextPage() async {
    if (_isAnimating) return;

    if (_currentPage < _pages.length - 1) {
      setState(() => _isAnimating = true);

      await Future.delayed(const Duration(milliseconds: 200));

      setState(() {
        _currentPage++;
        _isAnimating = false;
      });
    } else {
      context.go('/homie');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPageData = _pages[_currentPage];

    return Scaffold(
      body: GlobalAnimatedBackground(
        child: Stack(
          children: [
            Positioned.fill(
              child: OnboardingPage(
                key: ValueKey<int>(_currentPage),
                title: currentPageData['title']!,
                description: currentPageData['description']!,
                lottiePath: currentPageData['lottie']!,
                pageIndex: _currentPage,
                bottomWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    custom_button.ButtonStyle(
                      text: _currentPage == _pages.length - 1
                          ? 'Get Started'
                          : 'Next',
                      onPressed: _nextPage,
                    ),
                    TextButton(
                      onPressed: () {
                        context.go('/homie');
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 25,
              left: 0,
              right: 0,
              child: Center(
                child: AnimationPresets.pageIndicator(
                  child: PageIndicator(
                    currentIndex: _currentPage,
                    itemCount: _pages.length,
                  ),
                  delay: 800,
                  duration: const Duration(milliseconds: 400),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
