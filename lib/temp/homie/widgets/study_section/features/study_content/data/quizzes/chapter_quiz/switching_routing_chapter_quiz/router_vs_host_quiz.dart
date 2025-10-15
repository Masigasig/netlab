import '../../../../models/content_block.dart';
import '../../../../models/quiz_data.dart';

class RouterVsHostQuiz implements ModuleContent {
  @override
  String get moduleId => 'sr_router_vs_host_quiz';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What is the main difference between a router and a host in a network?',
          options: [
            'A host forwards data between networks, while a router generates data for applications',
            'A router forwards packets between networks, while a host sends and receives data within its own network',
            'Both perform the same role but at different speeds',
            'A host is a type of switch used in local networks',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Routers forward packets between different networks, while hosts generate and receive data within a network — routers move data across networks, hosts use that data locally.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'At which OSI layer does a router primarily operate?',
          options: [
            'Layer 1 – Physical',
            'Layer 2 – Data Link',
            'Layer 3 – Network',
            'Layer 4 – Transport',
          ],
          correctAnswerIndex: 2,
          explanation:
              'Routers operate at the Network layer (Layer 3) of the OSI model, where IP addressing and routing decisions occur.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'How does a router determine where to send data packets?',
          options: [
            'By checking the MAC address table',
            'By using its routing table to find the best path',
            'By broadcasting the packet to all ports',
            'By guessing based on previous transmissions',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Routers use a routing table containing known network paths and next-hop addresses to decide the most efficient route for each packet.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Which statement best describes a host’s role in network communication?',
          options: [
            'It directs packets between multiple networks',
            'It only stores data but never sends it',
            'It generates, processes, and receives data within its own network',
            'It maintains network topology and routing tables',
          ],
          correctAnswerIndex: 2,
          explanation:
              'Hosts act as endpoints — they create and consume data. Unlike routers, hosts don’t forward packets between networks.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'True or False: A router can act as a host if it has applications that send or receive data.',
          options: ['True', 'False'],
          correctAnswerIndex: 0,
          explanation:
              'True — while routers primarily forward data between networks, they can also act as hosts if they run applications that originate or consume network data.',
        ),
      ),
    ];
  }
}
