// ignore_for_file: avoid_print

void main() {
  // Original map of questions
  Map<String, Map<String, dynamic>> questions = {
    "question_0": {
      "question": "What is the main purpose of a computer network?",
      "answers": [
        "To play games only",
        "To connect devices and share resources",
        "To keep devices isolated",
        "To store electricity",
      ],
      "correct_answer": "To connect devices and share resources",
    },
    "question_1": {
      "question": "Which devices can be part of a computer network?",
      "answers": ["Printers", "Routers", "Servers", "All of the above"],
      "correct_answer": "All of the above",
    },
    "question_2": {
      "question": "Which protocol is used to access websites?",
      "answers": ["FTP", "HTTP", "SMTP", "SSH"],
      "correct_answer": "HTTP",
    },
  };

  // Step 1: Generate a list of keys
  List<String> keys = questions.keys.toList();

  // Step 2: Shuffle the keys
  keys.shuffle();

  // Step 3: Loop through shuffled keys and shuffle answers
  for (String key in keys) {
    var q = questions[key]!;
    List<String> shuffledAnswers = List.from(q["answers"])..shuffle();
    String correct = q["correct_answer"];
    int correctIndex = shuffledAnswers.indexOf(correct);

    print("- [$key] ${q['question']}");
    print("  Shuffled Answers: $shuffledAnswers");
    print("  Correct Index: $correctIndex");
    print("  Correct Answer: ${shuffledAnswers[correctIndex]}\n");
  }
}
