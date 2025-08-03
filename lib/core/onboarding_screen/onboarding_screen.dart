import 'package:flutter/material.dart';
import 'widgets/onboarding_page.dart';
import 'widgets/page_indicator.dart';
import 'widgets/onboarding_button.dart';
import 'package:netlab/core/constants/app_image.dart';


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
      'title': 'Welcome!',
      'description': 'Discover new ways to learn.',
      'lottie': AppLottie.reading,
    },
    {
      'title': 'Stay Motivated',
      'description': 'Get reminders and track your progress.',
      'lottie': AppLottie.reading,
    },
    {
      'title': 'Start Now',
      'description': 'Let’s begin your learning journey.',
      'lottie': AppLottie.reading,
    },
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      // Navigate to home or login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                final page = _pages[index];
                return OnboardingPage(
                  title: page['title']!,
                  description: page['description']!,
                  lottiePath: page['lottie']!,
                );
              },
            ),
          ),
          PageIndicator(currentIndex: _currentPage, itemCount: _pages.length),
          const SizedBox(height: 20),
          OnboardingButton(
            text: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
            onPressed: _nextPage,
          ),
          TextButton(
            onPressed: () {
              // Optional: skip to last page or login
            },
            child: const Text('Skip'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
