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
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _controller.forward();

    await Future.wait([
      _loadAssets(),
      _initializeServices(),
      Future.delayed(const Duration(seconds: 2)),
    ]);

    await _controller.reverse();

    if (mounted) {
      context.go('/home');
    }
  }

  Future<void> _loadAssets() async {
    const loader = SvgAssetLoader('assets/images/logo.svg');
    await svg.cache.putIfAbsent(
      loader.cacheKey(null),
      () => loader.loadBytes(null),
    );

    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _initializeServices() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 300,
                padding: const EdgeInsets.all(24),
                child: SvgPicture.asset(
                  'assets/images/logo.svg',
                  semanticsLabel: 'NetLab Logo',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
