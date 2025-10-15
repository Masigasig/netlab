import '../../../../models/content_block.dart';
import '../../../../models/quiz_data.dart';

class RouterNetworkConnectionsQuiz implements ModuleContent {
  @override
  String get moduleId => 'sr_router_network_connections_quiz';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What is the primary purpose of router network connections?',
          options: [
            'To connect end-user devices to a local switch',
            'To link multiple networks together for communication',
            'To provide power to connected devices',
            'To encrypt traffic between computers on the same LAN',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Router network connections exist to connect different networks, allowing communication and data exchange between them — such as between LANs and WANs.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Which type of router interface connects directly to end-user devices within a local network?',
          options: [
            'WAN interface',
            'LAN interface',
            'Serial interface',
            'Loopback interface',
          ],
          correctAnswerIndex: 1,
          explanation:
              'LAN interfaces on routers connect to devices within the local network (like switches or PCs), providing internal communication before packets are routed externally.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What type of interface allows a router to connect to external networks such as the Internet?',
          options: [
            'Ethernet interface',
            'WAN interface',
            'Local interface',
            'Administrative interface',
          ],
          correctAnswerIndex: 1,
          explanation:
              'WAN interfaces connect routers to external or remote networks, like ISPs or other routers across long distances.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'True or False: Routers can have both physical and logical interfaces for network connections.',
          options: ['True', 'False'],
          correctAnswerIndex: 0,
          explanation:
              'True — routers use physical interfaces (like Ethernet or serial ports) and logical interfaces (like VLANs or loopbacks) to manage and route traffic efficiently.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What is a loopback interface commonly used for in routers?',
          options: [
            'Providing a test or management IP address',
            'Physically connecting to other networks',
            'Powering network cables',
            'Transmitting wireless signals',
          ],
          correctAnswerIndex: 0,
          explanation:
              'Loopback interfaces are virtual interfaces used mainly for testing, management, and network stability. They are always up as long as the router is operational.',
        ),
      ),
    ];
  }
}
