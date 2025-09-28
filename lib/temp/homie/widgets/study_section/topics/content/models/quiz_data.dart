class QuizData {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String? explanation;
  final String? hint;

  QuizData({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
    this.hint,
  }) : assert(
         correctAnswerIndex >= 0 && correctAnswerIndex < options.length,
         'correctAnswerIndex must be a valid index within the options list',
       );

  String get correctAnswer => options[correctAnswerIndex];

  bool isCorrect(int answerIndex) => answerIndex == correctAnswerIndex;
}
