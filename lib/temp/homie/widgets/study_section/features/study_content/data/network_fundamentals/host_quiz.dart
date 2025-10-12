import '../../models/content_block.dart';
import '../../models/quiz_data.dart';

class HostQuiz implements ModuleContent {
  @override
  String get moduleId => 'nf_host_quiz';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What is the primary characteristic of a host device in a network?',
          options: [
            'It only forwards data',
            'It can send and receive data',
            'It only receives data',
            'It only connects cables',
          ],
          correctAnswerIndex: 1,
          explanation:
              'A host device is an endpoint device that can both send and receive data in a network.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Which of the following is NOT typically considered a host device?',
          options: [
            'Laptop',
            'Network Switch',
            'Smart Phone',
            'Network Printer',
          ],
          correctAnswerIndex: 1,
          explanation:
              'A network switch is an intermediary device that forwards data between hosts, not a host device itself.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What role does a host play in the client-server model?',
          options: [
            'Always a client',
            'Always a server',
            'Can be either a client or a server',
            'Neither client nor server',
          ],
          correctAnswerIndex: 2,
          explanation:
              'A host can function as either a client (requesting services) or a server (providing services) depending on its role in the communication.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What identifies a host on a network?',
          options: [
            'Only its MAC address',
            'Only its IP address',
            'Both MAC and IP addresses',
            'Neither MAC nor IP address',
          ],
          correctAnswerIndex: 2,
          explanation:
              'A host is identified by both its MAC address (physical address) and IP address (logical address) on a network.',
        ),
      ),
    ];
  }
}
