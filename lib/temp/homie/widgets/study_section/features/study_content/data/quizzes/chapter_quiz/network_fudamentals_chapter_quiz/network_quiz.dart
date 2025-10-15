import '../../../../models/content_block.dart';
import '../../../../models/quiz_data.dart';

class NetworkQuiz implements ModuleContent {
  @override
  String get moduleId => 'nf_network_quiz';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What is a network?',
          options: [
            'A collection of isolated computers',
            'A group of computers connected to share resources',
            'A single mainframe computer',
            'An Internet service provider',
          ],
          correctAnswerIndex: 1,
          explanation:
              'A network is a group of interconnected computers or devices that share data and resources.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'Which of the following is an example of a network device?',
          options: ['Printer', 'Router', 'Scanner', 'Monitor'],
          correctAnswerIndex: 1,
          explanation:
              'A router is a networking device that forwards data packets between networks, making it a core network device.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What is the main function of a network switch?',
          options: [
            'To convert analog signals to digital',
            'To connect devices within the same local area network',
            'To provide wireless connectivity',
            'To assign IP addresses automatically',
          ],
          correctAnswerIndex: 1,
          explanation:
              'A switch connects multiple devices within a LAN and forwards data to the correct destination device.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'True or False: A LAN (Local Area Network) covers a wide geographic area.',
          options: ['True', 'False'],
          correctAnswerIndex: 1,
          explanation:
              'False — a LAN covers a limited area like a home, school, or office building.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'Which of the following networks spans the largest area?',
          options: ['LAN', 'MAN', 'WAN', 'PAN'],
          correctAnswerIndex: 2,
          explanation:
              'A WAN (Wide Area Network) covers a very large area, often connecting multiple LANs across countries or continents.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What device connects different networks together?',
          options: ['Hub', 'Switch', 'Router', 'Bridge'],
          correctAnswerIndex: 2,
          explanation:
              'A router connects multiple networks and directs data packets between them.',
        ),
      ),
    ];
  }
}
