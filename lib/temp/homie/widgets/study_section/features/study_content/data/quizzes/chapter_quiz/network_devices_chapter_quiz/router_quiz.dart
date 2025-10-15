import '../../../../models/content_block.dart';
import '../../../../models/quiz_data.dart';

class RouterQuiz implements ModuleContent {
  @override
  String get moduleId => 'nd_router_quiz';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What is the main function of a router in a network?',
          options: [
            'To connect multiple devices within the same local network',
            'To forward data packets between different networks',
            'To boost signal strength between devices',
            'To assign MAC addresses to hosts',
          ],
          correctAnswerIndex: 1,
          explanation:
              'A router connects multiple networks and forwards data packets between them based on IP addresses, enabling communication across networks.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'At which OSI layer does a router primarily operate?',
          options: [
            'Physical Layer (Layer 1)',
            'Data Link Layer (Layer 2)',
            'Network Layer (Layer 3)',
            'Transport Layer (Layer 4)',
          ],
          correctAnswerIndex: 2,
          explanation:
              'Routers operate mainly at the Network Layer (Layer 3), using IP addresses to determine the best path for forwarding packets.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What information does a router use to determine the best path for forwarding data?',
          options: [
            'MAC address table',
            'IP routing table',
            'Device hostname',
            'Physical cable connections',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Routers use a routing table that contains network destinations and next-hop addresses to decide where to forward packets.',
        ),
      ),
      // ContentBlock(
      //   type: ContentBlockType.quiz,
      //   content: QuizData(
      //     question:
      //         'True or False: A router divides a network into multiple broadcast domains.',
      //     options: ['True', 'False'],
      //     correctAnswerIndex: 0,
      //     explanation:
      //         'True — routers separate broadcast domains, preventing unnecessary traffic from spreading across networks.',
      //   ),
      // ),
      // ContentBlock(
      //   type: ContentBlockType.quiz,
      //   content: QuizData(
      //     question: 'Which of the following best describes a routing table?',
      //     options: [
      //       'A list of connected devices and their MAC addresses',
      //       'A map of IP networks and the paths to reach them',
      //       'A log of transmitted data packets',
      //       'A database of DNS entries',
      //     ],
      //     correctAnswerIndex: 1,
      //     explanation:
      //         'A routing table stores information about network destinations and how to reach them — it’s the router’s roadmap for data delivery.',
      //   ),
      // ),
      // ContentBlock(
      //   type: ContentBlockType.quiz,
      //   content: QuizData(
      //     question: 'Which of the following is a function of a router?',
      //     options: [
      //       'Filtering traffic using IP addresses',
      //       'Broadcasting data to all network devices',
      //       'Regenerating weak signals',
      //       'Assigning MAC addresses to connected hosts',
      //     ],
      //     correctAnswerIndex: 0,
      //     explanation:
      //         'Routers can filter and control network traffic using IP addressing, improving security and efficiency in data routing.',
      //   ),
      // ),
    ];
  }
}
