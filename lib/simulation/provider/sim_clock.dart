import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final simClockProvider = NotifierProvider<SimClockNotifier, Duration>(
  SimClockNotifier.new,
);

class SimClockNotifier extends Notifier<Duration> {
  Timer? _timer;

  @override
  Duration build() {
    ref.onDispose(() {
      stop();
    });
    return Duration.zero;
  }

  void start() {
    if (_timer != null) return;
    _timer = Timer.periodic(const Duration(milliseconds: 10), (_) {
      state = state + const Duration(milliseconds: 10);
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void reset() {
    stop();
    state = Duration.zero;
  }
}
