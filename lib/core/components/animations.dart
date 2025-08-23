import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Animation types enum - Essential animations only
enum EssentialAnimationType {
  typeWriter,
  fadeInUp,
  tilt3D,
}

/// Essential Animation Widget
/// A reusable animation widget that provides three core animations:
/// - TypeWriter: Character-by-character text reveal
/// - FadeInUp: Smooth upward slide with fade
/// - Tilt3D: 3D perspective rotation for images
class EssentialAnimation extends StatefulWidget {
  /// The child widget to animate
  final Widget child;
  
  /// The type of animation to apply
  final EssentialAnimationType animationType;
  
  /// Duration of the animation
  final Duration duration;
  
  /// Delay before animation starts
  final Duration delay;
  
  /// Whether to repeat the animation
  final bool repeat;
  
  /// Text content for typewriter animation (required for typeWriter type)
  final String? text;
  
  /// Custom text style for typewriter animation
  final TextStyle? textStyle;
  
  /// Animation curve (defaults to easeInOut)
  final Curve curve;
  
  const EssentialAnimation({
    Key? key,
    required this.child,
    required this.animationType,
    this.duration = const Duration(milliseconds: 1000),
    this.delay = Duration.zero,
    this.repeat = false,
    this.text,
    this.textStyle,
    this.curve = Curves.easeInOut,
  }) : super(key: key);

  @override
  State<EssentialAnimation> createState() => _EssentialAnimationState();
}

class _EssentialAnimationState extends State<EssentialAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
    
    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
        if (widget.repeat) {
          _controller.repeat(reverse: true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        switch (widget.animationType) {
          case EssentialAnimationType.typeWriter:
            return _buildTypeWriter();
          case EssentialAnimationType.fadeInUp:
            return _buildFadeInUp();
          case EssentialAnimationType.tilt3D:
            return _buildTilt3D();
        }
      },
    );
  }

  /// TypeWriter Animation
  /// Creates a character-by-character text reveal with optional cursor
  Widget _buildTypeWriter() {
    if (widget.text == null) {
      assert(false, 'Text parameter is required for typeWriter animation');
      return widget.child;
    }
    
    final totalLength = widget.text!.length;
    final visibleLength = (totalLength * _animation.value).round();
    final visibleText = widget.text!.substring(0, visibleLength);
    
    // Blinking cursor effect
    final showCursor = _animation.value < 1.0 && 
                      (DateTime.now().millisecondsSinceEpoch ~/ 500) % 2 == 0;
    
    return Text(
      visibleText + (showCursor ? '|' : ''),
      style: widget.textStyle ?? const TextStyle(
        fontSize: 24, 
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// Fade In Up Animation
  /// Combines upward translation with opacity fade
  Widget _buildFadeInUp() {
    const slideDistance = 30.0;
    
    return Transform.translate(
      offset: Offset(0, slideDistance * (1 - _animation.value)),
      child: Opacity(
        opacity: _animation.value,
        child: widget.child,
      ),
    );
  }

  /// 3D Tilt Animation
  /// Creates perspective-based rotation effect
  Widget _buildTilt3D() {
    final animationValue = widget.repeat ? _animation.value : _animation.value;
    
    final tiltX = widget.repeat 
        ? 0.3 * math.sin(animationValue * math.pi * 2)
        : 0.3 * math.sin(animationValue * math.pi);
        
    final tiltY = widget.repeat 
        ? 0.2 * math.cos(animationValue * math.pi * 2)
        : 0.2 * math.cos(animationValue * math.pi);
        
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // Perspective
        ..rotateX(tiltX)
        ..rotateY(tiltY),
      child: widget.child,
    );
  }

  /// Public method to restart the animation
  void restart() {
    if (mounted) {
      _controller.reset();
      _controller.forward();
    }
  }

  /// Public method to stop the animation
  void stop() {
    if (mounted) {
      _controller.stop();
    }
  }

  /// Public method to pause the animation
  void pause() {
    if (mounted) {
      _controller.stop();
    }
  }

  /// Public method to resume the animation
  void resume() {
    if (mounted) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Staggered Animation Helper
/// Creates sequential animations with customizable delays
class StaggeredEssentialAnimation extends StatelessWidget {
  final List<Widget> children;
  final EssentialAnimationType animationType;
  final Duration staggerDelay;
  final Duration itemDuration;
  final Curve curve;

  const StaggeredEssentialAnimation({
    Key? key,
    required this.children,
    this.animationType = EssentialAnimationType.fadeInUp,
    this.staggerDelay = const Duration(milliseconds: 100),
    this.itemDuration = const Duration(milliseconds: 600),
    this.curve = Curves.easeInOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;
        
        return EssentialAnimation(
          animationType: animationType,
          duration: itemDuration,
          delay: staggerDelay * index,
          curve: curve,
          child: child,
        );
      }).toList(),
    );
  }
}

/// Custom Page Route with Fade Transition
class EssentialPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final Duration duration;

  EssentialPageRoute({
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          pageBuilder: (context, animation, _) => child,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}