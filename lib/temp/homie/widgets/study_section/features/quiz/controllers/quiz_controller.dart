import 'package:flutter/widgets.dart';
import '../../../core/services/progress_service.dart';

/// Controller for managing all quiz answers in a module
class ModuleQuizController extends ChangeNotifier {
  static const int requiredScore = 75;

  final String topicId;
  final String moduleId;

  // Map of questionIndex -> selectedAnswerIndex
  final Map<int, int> _answers = {};

  // Map of questionIndex -> correctAnswerIndex
  final Map<int, int> _correctAnswers = {};

  // Track submission state
  bool _isSubmitted = false;
  bool _isLoading = false;

  ModuleQuizController({required this.topicId, required this.moduleId});

  // Getters
  bool get isSubmitted => _isSubmitted;
  bool get isLoading => _isLoading;

  Map<int, int> get answers => Map.unmodifiable(_answers);

  int get totalQuestions => _correctAnswers.length;
  int get answeredQuestions => _answers.length;
  bool get allQuestionsAnswered =>
      _answers.length == _correctAnswers.length && _correctAnswers.isNotEmpty;

  /// Register a quiz question with its correct answer
  void registerQuestion(int questionIndex, int correctAnswerIndex) {
    _correctAnswers[questionIndex] = correctAnswerIndex;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  /// Update the selected answer for a question
  void setAnswer(int questionIndex, int selectedAnswerIndex) {
    if (_isSubmitted) return; // Can't change answers after submission

    _answers[questionIndex] = selectedAnswerIndex;
    notifyListeners();
  }

  /// Get the selected answer for a question (null if not answered)
  int? getAnswer(int questionIndex) {
    return _answers[questionIndex];
  }

  /// Check if a specific answer is correct (only available after submission)
  bool? isAnswerCorrect(int questionIndex) {
    if (!_isSubmitted) return null;

    final selectedAnswer = _answers[questionIndex];
    final correctAnswer = _correctAnswers[questionIndex];

    if (selectedAnswer == null) return false;
    return selectedAnswer == correctAnswer;
  }

  /// Get the correct answer index for a question (only available after submission)
  int? getCorrectAnswer(int questionIndex) {
    if (!_isSubmitted) return null;
    return _correctAnswers[questionIndex];
  }

  /// Submit all answers and save to progress service
  Future<void> submitAnswers() async {
    if (_isSubmitted || _isLoading) return;
    if (!allQuestionsAnswered) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Save each quiz result AND the selected answer
      for (final entry in _answers.entries) {
        final questionIndex = entry.key;
        final selectedAnswer = entry.value;
        final correctAnswer = _correctAnswers[questionIndex];
        final isCorrect = selectedAnswer == correctAnswer;

        // Save whether correct/incorrect
        await ProgressService.saveQuizResult(
          topicId,
          moduleId,
          questionIndex,
          isCorrect,
        );

        // Save the selected answer index for restoration
        await ProgressService.saveQuizAnswer(
          topicId,
          moduleId,
          questionIndex,
          selectedAnswer,
        );
      }

      _isSubmitted = true;
    } catch (e) {
      debugPrint('Error submitting quiz answers: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get quiz statistics after submission
  Map<String, dynamic> getStats() {
    if (!_isSubmitted) {
      return {'total': 0, 'correct': 0, 'percentage': 0, 'passed': false};
    }

    int correct = 0;
    for (final entry in _answers.entries) {
      final questionIndex = entry.key;
      final selectedAnswer = entry.value;
      final correctAnswer = _correctAnswers[questionIndex];

      if (selectedAnswer == correctAnswer) {
        correct++;
      }
    }

    final total = _answers.length;
    final percentage = total > 0 ? ((correct / total) * 100).round() : 0;
    final passed = percentage >= requiredScore;

    return {
      'total': total,
      'correct': correct,
      'percentage': percentage,
      'passed': passed,
    };
  }

  /// Check if quiz has been passed
  bool hasPassed() {
    final stats = getStats();
    return stats['passed'] as bool;
  }

  /// Reset the quiz state and randomize questions (allow retrying)
  void reset() {
    if (hasPassed()) return; // Don't allow reset if already passed

    // Randomize the order of questions
    final indices = _correctAnswers.keys.toList()..shuffle();
    final newCorrectAnswers = <int, int>{};

    for (int i = 0; i < indices.length; i++) {
      newCorrectAnswers[i] = _correctAnswers[indices[i]]!;
    }

    _correctAnswers.clear();
    _correctAnswers.addAll(newCorrectAnswers);
    _answers.clear();
    _isSubmitted = false;
    _isLoading = false;
    notifyListeners();
  }

  /// Load previous answers from progress service
  Future<void> loadPreviousAnswers() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Wait a bit for all questions to register first
      await Future.delayed(const Duration(milliseconds: 100));

      // Check if any quiz results exist and restore them
      bool hasAnyResults = false;

      // Check each registered question
      for (final entry in _correctAnswers.entries) {
        final questionIndex = entry.key;

        // Check if this question was answered
        final result = await ProgressService.getQuizResult(
          topicId,
          moduleId,
          questionIndex,
        );

        // Get the selected answer
        final selectedAnswer = await ProgressService.getQuizAnswer(
          topicId,
          moduleId,
          questionIndex,
        );

        if (result != null && selectedAnswer != null) {
          hasAnyResults = true;
          // Restore the selected answer
          _answers[questionIndex] = selectedAnswer;
        }
      }

      if (hasAnyResults) {
        _isSubmitted = true;
      }
    } catch (e) {
      debugPrint('Error loading previous answers: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
