import 'package:flutter/foundation.dart';
import '../../../core/services/progress_service.dart';

/// Controller for managing all quiz answers in a module
class ModuleQuizController extends ChangeNotifier {
  final String topicId;
  final String moduleId;

  // Map of questionIndex -> selectedAnswerIndex
  final Map<int, int> _answers = {};
  
  // Map of questionIndex -> correctAnswerIndex
  final Map<int, int> _correctAnswers = {};
  
  // Track submission state
  bool _isSubmitted = false;
  bool _isLoading = false;

  ModuleQuizController({
    required this.topicId,
    required this.moduleId,
  });

  // Getters
  bool get isSubmitted => _isSubmitted;
  bool get isLoading => _isLoading;
  
  Map<int, int> get answers => Map.unmodifiable(_answers);
  
  int get totalQuestions => _correctAnswers.length;
  int get answeredQuestions => _answers.length;
  bool get allQuestionsAnswered => _answers.length == _correctAnswers.length && _correctAnswers.isNotEmpty;

  /// Register a quiz question with its correct answer
  void registerQuestion(int questionIndex, int correctAnswerIndex) {
    _correctAnswers[questionIndex] = correctAnswerIndex;
    notifyListeners();
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
      // Save each quiz result
      for (final entry in _answers.entries) {
        final questionIndex = entry.key;
        final selectedAnswer = entry.value;
        final correctAnswer = _correctAnswers[questionIndex];
        final isCorrect = selectedAnswer == correctAnswer;

        await ProgressService.saveQuizResult(
          topicId,
          moduleId,
          questionIndex,
          isCorrect,
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
      return {
        'total': 0,
        'correct': 0,
        'percentage': 0,
      };
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

    return {
      'total': total,
      'correct': correct,
      'percentage': percentage,
    };
  }

  /// Reset the quiz (allow retrying)
  void reset() {
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
      
      // Check if any quiz results exist for this module
      bool hasAnyResults = false;
      
      // Check each registered question
      for (final entry in _correctAnswers.entries) {
        final questionIndex = entry.key;
        final result = await ProgressService.getQuizResult(
          topicId,
          moduleId,
          questionIndex,
        );
        
        if (result != null) {
          hasAnyResults = true;
          // We can't restore the exact answer, but we know it was submitted
          // Mark as submitted so feedback shows
          break;
        }
      }

      if (hasAnyResults) {
        _isSubmitted = true;
        // Note: ProgressService only stores correct/incorrect, not the selected answer
        // So we can't restore the exact selection, but we can show it was completed
      }
    } catch (e) {
      debugPrint('Error loading previous answers: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}