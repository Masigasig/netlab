import 'dart:math';
import 'package:flutter/material.dart';
import 'package:netlab/core/constants/app_colors.dart';

class AnimatedGradientBorder extends StatefulWidget {
  /// The child widget to wrap with the gradient border
  final Widget child;
  
  /// Border radius for the gradient border
  final double borderRadius;
  
  /// Width of the gradient border
  final double borderWidth;
  
  /// Colors for the gradient (defaults to AppColors.extendedGradient)
  final List<Color>? gradientColors;
  
  /// Duration of the animation
  final Duration animationDuration;
  
  /// Whether to animate the gradient (set to false for static border)
  final bool isAnimated;
  
  const AnimatedGradientBorder({
    super.key,
    required this.child,
    this.borderRadius = 12.0,
    this.borderWidth = 2.0,
    this.gradientColors,
    this.animationDuration = const Duration(seconds: 2),
    this.isAnimated = true,
  });
  
  @override
  State<AnimatedGradientBorder> createState() => _AnimatedGradientBorderState();
}

class _AnimatedGradientBorderState extends State<AnimatedGradientBorder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    if (widget.isAnimated) {
      _animationController.repeat();
    }
  }
  
  @override
  void didUpdateWidget(AnimatedGradientBorder oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Handle animation state changes
    if (widget.isAnimated != oldWidget.isAnimated) {
      if (widget.isAnimated) {
        _animationController.repeat();
      } else {
        _animationController.stop();
      }
    }
    
    // Handle duration changes
    if (widget.animationDuration != oldWidget.animationDuration) {
      _animationController.duration = widget.animationDuration;
    }
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final colors = widget.gradientColors ?? AppColors.extendedGradient;
    final innerRadius = (widget.borderRadius - widget.borderWidth).clamp(0.0, double.infinity);
    
    return AnimatedBuilder(
      animation: widget.isAnimated ? _animationController : kAlwaysCompleteAnimation,
      builder: (context, _) {
        return IntrinsicWidth(
          child: IntrinsicHeight(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                gradient: SweepGradient(
                  startAngle: 0.0,
                  endAngle: 2 * pi,
                  transform: widget.isAnimated 
                      ? GradientRotation(2 * pi * _animationController.value)
                      : null,
                  colors: colors,
                ),
              ),
              padding: EdgeInsets.all(widget.borderWidth),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(innerRadius),
                  color: Colors.transparent, // Let the child handle its own background
                ),
                child: widget.child,
              ),
            ),
          ),
        );
      },
    );
  }
}