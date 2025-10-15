import '../../../../models/content_block.dart';
import '../../../../models/quiz_data.dart';

class NFQuiz implements ModuleContent {
  @override
  String get moduleId => 'nf_quiz';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What is the main purpose of a computer network?',
          options: [
            'To play games only',
            'To connect devices and share resources',
            'To keep devices isolated',
            'To store electricity',
          ],
          correctAnswerIndex: 1,
          explanation:
              'A computer network allows devices to connect and share resources like files, printers, and internet connections.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Which of the following devices can be part of a computer network?',
          options: ['Printers', 'Routers', 'Servers', 'All of the above'],
          correctAnswerIndex: 3,
          explanation:
              'Printers, routers, and servers can all be part of a computer network.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What was the simple idea that started computer networking?',
          options: [
            'Using the internet for gaming',
            'One computer wanting to share data with another',
            'Creating social media',
            'Making faster processors',
          ],
          correctAnswerIndex: 1,
          explanation:
              'The original idea behind networking was to allow one computer to share data with another.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What device is commonly used to connect multiple computers within the same network?',
          options: ['Monitor', 'Switch', 'Keyboard', 'Flash drive'],
          correctAnswerIndex: 1,
          explanation:
              'A switch connects multiple devices in a local area network (LAN) to enable communication.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Which of the following actions is possible because of computer networks?',
          options: [
            'Sending emails',
            'Browsing the internet',
            'Sharing files',
            'All of the above',
          ],
          correctAnswerIndex: 3,
          explanation:
              'Computer networks enable communication, file sharing, and internet access — all of the above.',
        ),
      ),
    ];
  }
}
