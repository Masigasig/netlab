// ignore_for_file: deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Widget',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const QuizScreen(),
    );
  }
}

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample quiz data
    final sampleQuestions = [
      {
        'chapterId': 'ch1',
        'lessonId': 'l1',
        'questionId': 'q1',
        'question': 'What is the capital of France?',
        'answers': ['London', 'Paris', 'Berlin', 'Madrid'],
        'correctAnswer': 'Paris',
        'explanation': 'Paris is the capital and largest city of France.',
      },
      {
        'chapterId': 'ch1',
        'lessonId': 'l1',
        'questionId': 'q2',
        'question': 'Which planet is known as the Red Planet?',
        'answers': ['Venus', 'Mars', 'Jupiter', 'Saturn'],
        'correctAnswer': 'Mars',
        'explanation':
            'Mars is called the Red Planet due to its reddish appearance caused by iron oxide on its surface.',
      },
      {
        'chapterId': 'ch1',
        'lessonId': 'l2',
        'questionId': 'q3',
        'question': 'What is 2 + 2?',
        'answers': ['3', '4', '5', '6'],
        'correctAnswer': '4',
        'explanation': '2 + 2 equals 4. This is basic arithmetic.',
      },
      {
        'chapterId': 'ch2',
        'lessonId': 'l1',
        'questionId': 'q4',
        'question': 'Who painted the Mona Lisa?',
        'answers': [
          'Vincent van Gogh',
          'Leonardo da Vinci',
          'Pablo Picasso',
          'Michelangelo',
        ],
        'correctAnswer': 'Leonardo da Vinci',
        'explanation':
            'Leonardo da Vinci painted the Mona Lisa in the early 16th century.',
      },
      {
        'chapterId': 'ch2',
        'lessonId': 'l2',
        'questionId': 'q5',
        'question': 'What is the largest ocean on Earth?',
        'answers': [
          'Atlantic Ocean',
          'Indian Ocean',
          'Pacific Ocean',
          'Arctic Ocean',
        ],
        'correctAnswer': 'Pacific Ocean',
        'explanation':
            'The Pacific Ocean is the largest ocean, covering more than 63 million square miles.',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz'), centerTitle: true),
      body: QuizWidget(questions: sampleQuestions),
    );
  }
}

class QuizWidget extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> questions;

  const QuizWidget({super.key, required this.questions});

  @override
  ConsumerState<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends ConsumerState<QuizWidget> {
  int currentQuestionIndex = 0;
  String? selectedAnswer;
  bool isAnswerChecked = false;
  List<Map<String, dynamic>> quizResults = [];
  DateTime? questionStartTime;

  @override
  void initState() {
    super.initState();
    questionStartTime = DateTime.now();
  }

  void selectAnswer(String answer) {
    if (!isAnswerChecked) {
      setState(() {
        selectedAnswer = answer;
      });
    }
  }

  void checkAnswer() {
    if (selectedAnswer == null) return;

    final currentQuestion = widget.questions[currentQuestionIndex];
    final isCorrect = selectedAnswer == currentQuestion['correctAnswer'];
    final duration = DateTime.now().difference(questionStartTime!);

    setState(() {
      isAnswerChecked = true;
      quizResults.add({
        'chapterId': currentQuestion['chapterId'],
        'lessonId': currentQuestion['lessonId'],
        'questionId': currentQuestion['questionId'],
        'status': isCorrect ? 'correct' : 'wrong',
        'time_answering': duration.inSeconds,
        'selectedAnswer': selectedAnswer,
      });
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
        isAnswerChecked = false;
        questionStartTime = DateTime.now();
      });
    }
  }

  void finishQuiz() {
    final totalQuestions = widget.questions.length;
    final correctAnswers = quizResults
        .where((r) => r['status'] == 'correct')
        .length;
    final score = (correctAnswers / totalQuestions) * 100;
    const passingScore = 80.0;
    final isPassed = score >= passingScore;

    print('=== QUIZ RESULTS ===');
    print('Total Questions: $totalQuestions');
    print('Correct Answers: $correctAnswers');
    print('Score: ${score.toStringAsFixed(1)}%');
    print('Passing Score: ${passingScore.toStringAsFixed(0)}%');
    print('Status: ${isPassed ? 'PASSED ✓' : 'FAILED ✗'}');
    print('\nDetailed Results:');
    for (var i = 0; i < quizResults.length; i++) {
      print('\nQuestion ${i + 1}:');
      print('  Chapter ID: ${quizResults[i]['chapterId']}');
      print('  Lesson ID: ${quizResults[i]['lessonId']}');
      print('  Question ID: ${quizResults[i]['questionId']}');
      print('  Status: ${quizResults[i]['status']}');
      print('  Time Answering: ${quizResults[i]['time_answering']} seconds');
      print('  Selected Answer: ${quizResults[i]['selectedAnswer']}');
    }
    print('\n===================');

    // Show dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isPassed ? '🎉 Congratulations!' : '📚 Keep Trying!',
          style: TextStyle(color: isPassed ? Colors.green : Colors.orange),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Score: ${score.toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'You got $correctAnswers out of $totalQuestions correct!',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isPassed ? Colors.green[100] : Colors.orange[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPassed ? Icons.check_circle : Icons.info,
                    color: isPassed ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isPassed ? 'PASSED' : 'FAILED',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: isPassed ? Colors.green[800] : Colors.orange[800],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Passing score: ${passingScore.toStringAsFixed(0)}%',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            const Text(
              '\nCheck the console for detailed results.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                currentQuestionIndex = 0;
                selectedAnswer = null;
                isAnswerChecked = false;
                quizResults.clear();
                questionStartTime = DateTime.now();
              });
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.questions[currentQuestionIndex];
    final isLastQuestion = currentQuestionIndex == widget.questions.length - 1;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Question counter
          Text(
            'Question ${currentQuestionIndex + 1} of ${widget.questions.length}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),

          // Question text
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                currentQuestion['question'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Answer choices
          Expanded(
            child: ListView.builder(
              itemCount: (currentQuestion['answers'] as List).length,
              itemBuilder: (context, index) {
                final answer = currentQuestion['answers'][index];
                final isSelected = selectedAnswer == answer;
                final isCorrect = answer == currentQuestion['correctAnswer'];

                Color? cardColor;
                if (isAnswerChecked && isSelected) {
                  cardColor = isCorrect ? Colors.green[100] : Colors.red[100];
                } else if (isAnswerChecked && isCorrect) {
                  cardColor = Colors.green[50];
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: InkWell(
                    onTap: () => selectAnswer(answer),
                    child: Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Radio<String>(
                            value: answer,
                            groupValue: selectedAnswer,
                            onChanged: isAnswerChecked
                                ? null
                                : (value) => selectAnswer(value!),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              answer,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          if (isAnswerChecked && isCorrect)
                            const Icon(Icons.check_circle, color: Colors.green),
                          if (isAnswerChecked && isSelected && !isCorrect)
                            const Icon(Icons.cancel, color: Colors.red),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Explanation (shown after check)
          if (isAnswerChecked)
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Explanation:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentQuestion['explanation'],
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Progress indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.questions.length, (index) {
              Color circleColor = Colors.grey[300]!;

              if (index < quizResults.length) {
                circleColor = quizResults[index]['status'] == 'correct'
                    ? Colors.green
                    : Colors.red;
              }

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: circleColor,
                  border: Border.all(
                    color: index == currentQuestionIndex
                        ? Colors.blue
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 16),

          // Action button
          ElevatedButton(
            onPressed: selectedAnswer == null
                ? null
                : () {
                    if (!isAnswerChecked) {
                      checkAnswer();
                    } else if (isLastQuestion) {
                      finishQuiz();
                    } else {
                      nextQuestion();
                    }
                  },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey[300],
            ),
            child: Text(
              !isAnswerChecked
                  ? 'Check Answer'
                  : isLastQuestion
                  ? 'Finish'
                  : 'Next Question',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
