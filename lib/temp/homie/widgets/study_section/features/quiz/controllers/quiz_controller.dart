import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/progress_service.dart';

/// Controller for managing all quiz answers in a module
class ModuleQuizController extends ChangeNotifier {
  static const int requiredScore = 75;

  final String topicId;
  final String moduleId;
  final Map<int, int> _answers = {};
  final Map<int, int> _correctAnswers = {};
  final Map<int, bool> _cachedResults = {};

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

    // First check cached results from storage
    if (_cachedResults.containsKey(questionIndex)) {
      return _cachedResults[questionIndex];
    }

    // Otherwise calculate from correct answers if available
    final selectedAnswer = _answers[questionIndex];
    final correctAnswer = _correctAnswers[questionIndex];

    if (selectedAnswer == null) return false;
    if (correctAnswer == null) return null; // Question not registered yet

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

        // Cache the result
        _cachedResults[questionIndex] = isCorrect;

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
    final total = _answers.length;

    // Calculate correct answers using cached results
    for (final questionIndex in _answers.keys) {
      // Use cached results if available (from storage)
      if (_cachedResults.containsKey(questionIndex)) {
        if (_cachedResults[questionIndex] == true) {
          correct++;
        }
      }
      // Otherwise calculate from correct answers if registered
      else if (_correctAnswers.containsKey(questionIndex)) {
        final selectedAnswer = _answers[questionIndex];
        final correctAnswer = _correctAnswers[questionIndex];

        if (selectedAnswer == correctAnswer) {
          correct++;
        }
      }
    }

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
    if (hasPassed()) return;
    _answers.clear();
    _cachedResults.clear();
    _isSubmitted = false;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadPreviousAnswers() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      // Load all saved answers for this module
      final answerPrefix = 'quiz_answer_${topicId}_${moduleId}_';
      final resultPrefix = 'quiz_score_${topicId}_${moduleId}_';

      bool hasAnyResults = false;

      // Find all answer keys for this module
      final answerKeys = prefs
          .getKeys()
          .where((key) => key.startsWith(answerPrefix))
          .toList();

      debugPrint(
        'Loading quiz answers for $moduleId: Found ${answerKeys.length} saved answers',
      );

      for (final key in answerKeys) {
        // Extract question index from key
        final questionIndexStr = key.substring(answerPrefix.length);
        final questionIndex = int.tryParse(questionIndexStr);

        if (questionIndex == null) continue;

        // Get the saved answer
        final selectedAnswer = prefs.getInt(key);

        // Check if there's a result for this question
        final resultKey = '$resultPrefix$questionIndex';
        final result = prefs.getBool(resultKey);

        if (selectedAnswer != null && result != null) {
          hasAnyResults = true;
          _answers[questionIndex] = selectedAnswer;
          _cachedResults[questionIndex] = result; // Cache the result!
          debugPrint(
            'Restored Q$questionIndex: answer=$selectedAnswer, correct=$result',
          );
        }
      }

      if (hasAnyResults) {
        _isSubmitted = true;
        debugPrint(
          'Quiz marked as submitted with ${_answers.length} answers, ${_cachedResults.values.where((r) => r).length} correct',
        );
      }
    } catch (e) {
      debugPrint('Error loading previous answers: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
