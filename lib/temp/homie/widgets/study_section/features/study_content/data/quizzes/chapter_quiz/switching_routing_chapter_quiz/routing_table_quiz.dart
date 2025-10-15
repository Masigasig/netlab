import '../../../../models/content_block.dart';
import '../../../../models/quiz_data.dart';

class RoutingTableQuiz implements ModuleContent {
  @override
  String get moduleId => 'sr_routing_table_quiz';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What is the main function of a routing table in a router?',
          options: [
            'To store MAC addresses of connected devices',
            'To determine the best path for data packets to reach their destination',
            'To record bandwidth usage for each network interface',
            'To manage wireless access point connections',
          ],
          correctAnswerIndex: 1,
          explanation:
              'A routing table stores information about network destinations and the best available paths, allowing routers to forward packets efficiently.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Which of the following pieces of information is typically found in a routing table entry?',
          options: [
            'Destination network, next hop, and outgoing interface',
            'MAC address, port number, and VLAN ID',
            'Username, password, and encryption key',
            'Application name, protocol type, and port speed',
          ],
          correctAnswerIndex: 0,
          explanation:
              'Each routing table entry includes the destination network, the next-hop IP address, and the outgoing interface for forwarding packets.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What is the “next hop” in a routing table used for?',
          options: [
            'It identifies the next device or router to send a packet to',
            'It shows the application that generated the data',
            'It marks where the data will be stored temporarily',
            'It indicates the source of the original transmission',
          ],
          correctAnswerIndex: 0,
          explanation:
              'The “next hop” specifies the next device (usually another router) where a packet should be forwarded to reach its destination.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'True or False: Routers can have both static and dynamic routes in their routing tables.',
          options: ['True', 'False'],
          correctAnswerIndex: 0,
          explanation:
              'True — routers can use static routes configured manually or dynamic routes learned automatically through routing protocols like OSPF or RIP.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Which type of route is automatically learned through routing protocols?',
          options: [
            'Static route',
            'Dynamic route',
            'Manual route',
            'Default route',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Dynamic routes are learned automatically through routing protocols, allowing routers to adapt to network changes without manual updates.',
        ),
      ),
    ];
  }
}
