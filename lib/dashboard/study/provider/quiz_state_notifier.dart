import 'package:flutter_riverpod/flutter_riverpod.dart';

final quizStateProvider = NotifierProvider<QuizStateNotifier, bool>(
  QuizStateNotifier.new,
);

class QuizStateNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void setQuizState(bool isQuizing) {
    state = isQuizing;
  }
}
