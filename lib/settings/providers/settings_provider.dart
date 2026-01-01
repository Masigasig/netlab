import 'package:flutter_riverpod/flutter_riverpod.dart';

final fontMultiplierProvider = NotifierProvider<FontMultiplierNotifier, double>(
  FontMultiplierNotifier.new,
);

class FontMultiplierNotifier extends Notifier<double> {
  @override
  double build() => 1.0;

  void setMultiplier(double value) {
    state = value.clamp(0.5, 1.5);
  }

  void reset() {
    state = 1.0;
  }
}
