import 'package:flutter/material.dart';
import 'widgets/onboarding_page.dart';
import 'widgets/page_indicator.dart';
import '../core/components/button.dart' as custom_button;
import 'package:netlab/core/constants/app_image.dart';
import 'widgets/bg.dart';
import 'package:go_router/go_router.dart';
import 'package:netlab/core/constants/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Welcome to NetLab!',
      'description': 'Discover how computer networks work — no cables, no configurations. Just simple, hands-on learning built for students and educators.',
      'lottie': AppLottie.kid,
    },
    {
      'title': 'Build & Connect Your Network.',
      'description': 'Use drag-and-drop tools to create network topologies. Connect routers, switches, and PCs to visualize how real networks function.',
      'lottie': AppLottie.floating,
    },
    {
      'title': 'Simulate. Learn. Repeat.',
      'description': 'Simulate basic networking scenarios to reinforce classroom concepts. Whether you’re a beginner or teaching others, learning is just a tap away.',
      'lottie': AppLottie.kid2,
    },
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      // ✅ Navigate to home when the last page is reached
      context.go('/home'); // Make sure '/home' is registered in GoRouter
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlobalAnimatedBackground(
        child: Stack(
          children: [
            Positioned.fill(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) =>
                    setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return OnboardingPage(
                    title: page['title']!,
                    description: page['description']!,
                    lottiePath: page['lottie']!,
                    bottomWidget: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        custom_button.ButtonStyle(
                          text: index == _pages.length - 1
                              ? 'Get Started'
                              : 'Next',
                          onPressed: _nextPage,
                        ),
                        TextButton(
                          onPressed: () {
                            // ✅ Skip to home screen directly
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
                  );
                },
              ),
            ),
            Positioned(
              bottom: 25,
              left: 0,
              right: 0,
              child: Center(
                child: PageIndicator(
                  currentIndex: _currentPage,
                  itemCount: _pages.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
