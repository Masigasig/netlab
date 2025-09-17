import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/simulation/provider/sim_screen_notifier.dart';

//* Solution to the bug where animation is not rendering continuously when
//* the app is built due to flutter optimization
class LoopAnimator extends ConsumerStatefulWidget {
  const LoopAnimator({super.key});

  @override
  ConsumerState<LoopAnimator> createState() => _LoopAnimatorState();
}

class _LoopAnimatorState extends ConsumerState<LoopAnimator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('LoopAnimator Rebuilt');
    final isPlaying = ref.watch(simScreenProvider.select((s) => s.isPlaying));

    if (isPlaying && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!isPlaying && _controller.isAnimating) {
      _controller.stop();
    }

    // Invisible widget to keep the ticker alive
    return RotationTransition(
      turns: _controller,
      child: const SizedBox.shrink(),
    );
  }
}
