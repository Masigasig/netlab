import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:netlab/core/routing/go_router.dart';
import 'package:netlab/dashboard/study/provider/material_details_notifier.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
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
      _loadJsonData(), // Load and assign JSON
      Future.delayed(const Duration(seconds: 2)), // Optional delay
    ]);
    await _controller.reverse(); // Fade out

    if (mounted) context.go('/home'); // Navigate
  }

  Future<void> _loadJsonData() async {
    final jsonString = await rootBundle.loadString(
      'assets/learning_material/material_details.json',
    );
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;

    ref.read(materialDetailProvider.notifier).setContent(jsonData);
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
