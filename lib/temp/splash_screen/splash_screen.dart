import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _startSplash();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _startSplash() async {
    await _controller.forward(); // Fade in

    await Future.wait([
      // _loadJsonData(), // Load and assign JSON
      Future.delayed(const Duration(seconds: 2)), // Optional delay
    ]);
    await _controller.reverse(); // Fade out

    if (mounted) context.go('/home'); // Navigate
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: FadeTransition(
        opacity: _fade,
        child: Center(
          child: SvgPicture.asset(
            'assets/images/logo.svg',
            width: 200,
            height: 200,
            semanticsLabel: 'App Logo',
          ),
        ),
      ),
    );
  }
}
