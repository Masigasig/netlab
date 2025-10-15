import '../../../../models/content_block.dart';
import '../../../../models/quiz_data.dart';

class HostOverviewQuiz implements ModuleContent {
  @override
  String get moduleId => 'hh_host_overview_quiz';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What is a host in a network?',
          options: [
            'A device that provides network cables',
            'Any device that sends or receives data over a network',
            'A special server that manages routers',
            'Only a computer running a web browser',
          ],
          correctAnswerIndex: 1,
          explanation:
              'A host is any device connected to a network that can send or receive data — including computers, printers, and mobile devices.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What must every host on a network have to communicate?',
          options: [
            'A unique IP address',
            'The same MAC address as others',
            'A physical cable connection',
            'A shared hostname',
          ],
          correctAnswerIndex: 0,
          explanation:
              'Each host must have a unique IP address to be identified and communicate properly on a network.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'Which of the following is an example of a host device?',
          options: ['Router', 'Switch', 'Laptop', 'Network hub'],
          correctAnswerIndex: 2,
          explanation:
              'A laptop is considered a host device because it generates, sends, and receives data within the network.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'True or False: Hosts cannot communicate directly without a router.',
          options: ['True', 'False'],
          correctAnswerIndex: 1,
          explanation:
              'False — hosts within the same network (subnet) can communicate directly without the need for a router.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What allows hosts to communicate with other networks beyond their local one?',
          options: ['Default gateway', 'Switch', 'Access point', 'Firewall'],
          correctAnswerIndex: 0,
          explanation:
              'A default gateway, usually a router, enables hosts to communicate outside their local network.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Which of the following best describes host-to-host communication?',
          options: [
            'The process of sharing data between two devices over a network',
            'A broadcast signal sent to all devices in a network',
            'A local-only file transfer',
            'An encrypted session for authentication',
          ],
          correctAnswerIndex: 0,
          explanation:
              'Host-to-host communication refers to the exchange of data between two devices connected to a network.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Why is addressing important for host-to-host communication?',
          options: [
            'It defines the color of network cables used',
            'It ensures data is sent to the correct destination host',
            'It encrypts all messages on the network',
            'It reduces network congestion',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Addressing ensures each data packet reaches the correct destination host, avoiding misdelivery in communication.',
        ),
      ),
    ];
  }
}
