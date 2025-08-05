import 'dart:math';
import 'package:flutter/material.dart';

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

  final BorderRadius _borderRadius = BorderRadius.circular(30);
  final double _borderWidth = 2;
  final Duration _duration = const Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: _duration,
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
        return CustomPaint(
          painter: GradientBorderPainter(
            animationValue: _controller.value,
            borderRadius: _borderRadius,
            borderWidth: _borderWidth,
          ),
          child: Container(
            padding: EdgeInsets.all(_borderWidth),
            child: ElevatedButton(
              onPressed: widget.onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B0F1E), // Updated dark background
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: _borderRadius,
                ),
              ),
              child: Text(
                widget.text,
                style: const TextStyle(
                  color: Colors.white, // High contrast
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class GradientBorderPainter extends CustomPainter {
  final double animationValue;
  final BorderRadius borderRadius;
  final double borderWidth;

  GradientBorderPainter({
    required this.animationValue,
    required this.borderRadius,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final gradient = SweepGradient(
      startAngle: 0.0,
      endAngle: 2 * pi,
      transform: GradientRotation(2 * pi * animationValue),
      colors: const [
        Color(0xFF6C63FF),
        Color(0xFFD77EFF),
        Color(0xFFFF4D94),
        Color(0xFF6C63FF),
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final rrect = borderRadius.toRRect(rect);
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant GradientBorderPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.borderWidth != borderWidth;
  }
}
