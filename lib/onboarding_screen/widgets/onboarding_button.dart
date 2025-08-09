import 'dart:math';
import 'package:flutter/material.dart';
import 'package:netlab/core/constants/app_colors.dart';

class OnboardingButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  
  const OnboardingButton({
    super.key,
    required this.text,
    required this.onPressed,
  });
  
  @override
  State<OnboardingButton> createState() => _OnboardingButtonState();
}

class _OnboardingButtonState extends State<OnboardingButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: SweepGradient(
              startAngle: 0.0,
              endAngle: 2 * pi,
              transform: GradientRotation(2 * pi * _controller.value),
              colors: AppColors.extendedGradient,
            ),
          ),
          padding: const EdgeInsets.all(2),
          child: ElevatedButton(
            onPressed: widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.background,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            child: Text(
              widget.text,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }
}