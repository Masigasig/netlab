import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Reusable animation presets to avoid duplication across the app
class AnimationPresets {
  // Private constructor to prevent instantiation
  AnimationPresets._();

  /// Standard text fade-in animation (for titles, descriptions)
  static Animate textFadeIn({
    required Widget child,
    int delay = 0,
    Duration duration = const Duration(milliseconds: 600),
    double slideDistance = 0.2,
    double blurAmount = 3.0,
  }) {
    return child.animate()
      .fadeIn(duration: duration, delay: delay.ms, curve: Curves.easeOut)
      .blur(begin: Offset(0, blurAmount), duration: duration, delay: delay.ms, curve: Curves.easeOut)
      .slideY(begin: slideDistance, duration: duration, delay: delay.ms, curve: Curves.easeOut);
  }

  /// Large title animation with scale effect
  static Animate titleFadeIn({
    required Widget child,
    int delay = 0,
    Duration duration = const Duration(milliseconds: 700),
  }) {
    return child.animate()
      .fadeIn(duration: duration, delay: delay.ms, curve: Curves.easeOut)
      .blur(begin: const Offset(0, 4), duration: duration, delay: delay.ms, curve: Curves.easeOut)
      .slideY(begin: 0.3, duration: duration, delay: delay.ms, curve: Curves.easeOutCubic)
      .scale(begin: const Offset(0.9, 0.9), duration: duration, delay: delay.ms, curve: Curves.easeOut);
  }

  /// Card/Button entrance animation
  static Animate cardEntrance({
    required Widget child,
    int delay = 0,
    Duration duration = const Duration(milliseconds: 600),
    double scaleFrom = 0.8,
  }) {
    return child.animate()
      .fadeIn(duration: duration, delay: delay.ms, curve: Curves.easeOut)
      .blur(begin: const Offset(0, 3), duration: duration, delay: delay.ms, curve: Curves.easeOut)
      .scale(begin: Offset(scaleFrom, scaleFrom), duration: duration, delay: delay.ms, curve: Curves.easeOutBack)
      .slideY(begin: 0.2, duration: duration, delay: delay.ms, curve: Curves.easeOutCubic);
  }

  /// Staggered list item animation (slides from right)
  static Animate listItemSlideRight({
    required Widget child,
    required int index,
    int staggerDelay = 100,
    Duration duration = const Duration(milliseconds: 600),
  }) {
    final delay = index * staggerDelay;
    return child.animate()
      .fadeIn(duration: duration, delay: delay.ms, curve: Curves.easeOut)
      .blur(begin: const Offset(2, 0), duration: duration, delay: delay.ms, curve: Curves.easeOut)
      .slideX(begin: 0.3, duration: duration, delay: delay.ms, curve: Curves.easeOutCubic)
      .scale(begin: const Offset(0.95, 0.95), duration: duration, delay: delay.ms, curve: Curves.easeOut);
  }

  /// Staggered list item animation (slides from left) - for sidebars
  static Animate listItemSlideLeft({
    required Widget child,
    required int index,
    int staggerDelay = 80,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    final delay = index * staggerDelay;
    return child.animate()
      .fadeIn(duration: duration, delay: delay.ms, curve: Curves.easeOut)
      .blur(begin: const Offset(1, 0), duration: duration, delay: delay.ms, curve: Curves.easeOut)
      .slideX(begin: -0.2, duration: duration, delay: delay.ms, curve: Curves.easeOutCubic)
      .scale(begin: const Offset(0.96, 0.96), duration: duration, delay: delay.ms, curve: Curves.easeOut);
  }

  /// Lottie/Image animation with scale and slide
  static Animate mediaEntrance({
    required Widget child,
    int delay = 500,
    Duration duration = const Duration(milliseconds: 800),
  }) {
    return child.animate()
      .fadeIn(duration: duration, delay: delay.ms, curve: Curves.easeOut)
      .blur(begin: const Offset(0, 4), duration: duration, delay: delay.ms, curve: Curves.easeOut)
      .scale(begin: const Offset(0.7, 0.7), duration: duration, delay: delay.ms, curve: Curves.easeOutBack)
      .slideY(begin: 0.2, duration: duration, delay: delay.ms, curve: Curves.easeOutCubic);
  }

  /// Icon slide animation
  static Animate iconSlide({
    required Widget child,
    int delay = 0,
    Duration duration = const Duration(milliseconds: 400),
    double slideFrom = -0.3,
  }) {
    return child.animate()
      .fadeIn(duration: duration, delay: delay.ms, curve: Curves.easeOut)
      .slideX(begin: slideFrom, duration: duration, delay: delay.ms, curve: Curves.easeOut);
  }

  /// Button with bounce effect
  static Animate buttonBounce({
    required Widget child,
    int delay = 0,
    Duration duration = const Duration(milliseconds: 600),
  }) {
    return child.animate()
      .fadeIn(duration: duration, delay: delay.ms, curve: Curves.easeOut)
      .blur(begin: const Offset(0, 2), duration: duration, delay: delay.ms, curve: Curves.easeOut)
      .slideY(begin: 0.3, duration: duration, delay: delay.ms, curve: Curves.easeOut)
      .scale(begin: const Offset(0.8, 0.8), duration: duration, delay: delay.ms, curve: Curves.easeOutBack);
  }

  /// Page indicator animation
  static Animate pageIndicator({
    required Widget child,
    int delay = 800,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return child.animate()
      .fadeIn(duration: duration, delay: delay.ms, curve: Curves.easeOut)
      .slideY(begin: 0.1, duration: duration, delay: delay.ms, curve: Curves.easeOut);
  }
}