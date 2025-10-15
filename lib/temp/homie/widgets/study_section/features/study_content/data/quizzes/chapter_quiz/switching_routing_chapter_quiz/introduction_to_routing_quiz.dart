import '../../../../models/content_block.dart';
import '../../../../models/quiz_data.dart';

class IntroductionToRoutingQuiz implements ModuleContent {
  @override
  String get moduleId => 'sr_introduction_to_routing_quiz';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What is the primary function of a router in a network?',
          options: [
            'To amplify network signals',
            'To forward data between different networks',
            'To connect devices within the same LAN',
            'To assign MAC addresses to devices',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Routers are responsible for forwarding packets between different networks, enabling communication across network boundaries.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'At which OSI layer does a router primarily operate?',
          options: [
            'Layer 1 – Physical Layer',
            'Layer 2 – Data Link Layer',
            'Layer 3 – Network Layer',
            'Layer 4 – Transport Layer',
          ],
          correctAnswerIndex: 2,
          explanation:
              'Routers function mainly at the Network Layer (Layer 3), using IP addresses to determine packet forwarding paths.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Which type of address does a router use to make forwarding decisions?',
          options: [
            'MAC address',
            'Port address',
            'IP address',
            'Application address',
          ],
          correctAnswerIndex: 2,
          explanation:
              'Routers use IP addresses to determine the next hop in the path toward the destination network.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What is the term for the path that a packet takes from the source to the destination across multiple networks?',
          options: [
            'Transmission route',
            'Routing path',
            'Network link',
            'Frame circuit',
          ],
          correctAnswerIndex: 1,
          explanation:
              'The routing path refers to the specific route a packet follows across interconnected networks to reach its destination.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'True or False: Routers forward frames based on MAC addresses.',
          options: ['True', 'False'],
          correctAnswerIndex: 1,
          explanation:
              'False — switches use MAC addresses, while routers make forwarding decisions using IP addresses at Layer 3.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What is a routing table used for?',
          options: [
            'To store a list of MAC addresses',
            'To record the physical connections between devices',
            'To determine the best path to a destination network',
            'To monitor traffic collisions in a LAN',
          ],
          correctAnswerIndex: 2,
          explanation:
              'A routing table contains information about network destinations and the paths (next hops) used to reach them.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What does a router do when it receives a packet for a network it doesn’t recognize?',
          options: [
            'It floods the packet to all ports',
            'It drops the packet',
            'It assigns a new IP address to the packet',
            'It sends the packet to a switch',
          ],
          correctAnswerIndex: 1,
          explanation:
              'If a router has no route for a destination network, it discards the packet and may send an ICMP “Destination Unreachable” message.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What is the “default gateway” in a network?',
          options: [
            'A backup router used only when the main fails',
            'A device that assigns IP addresses automatically',
            'The router interface that connects the local network to external networks',
            'The switch port connected to all hosts',
          ],
          correctAnswerIndex: 2,
          explanation:
              'The default gateway is the router interface that forwards packets from a local network to other networks when no specific route exists.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Which of the following best describes the process of routing?',
          options: [
            'Deciding how to forward data frames within a LAN',
            'Determining the best path to a destination network',
            'Assigning addresses to hosts',
            'Amplifying signals for long-distance transmission',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Routing is the process of determining the optimal path for data packets to reach their destination network.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What happens to the source and destination MAC addresses when a packet moves through multiple routers?',
          options: [
            'They stay the same throughout the path',
            'They change at each router hop',
            'Only the destination MAC changes',
            'Only the source MAC changes',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Each router replaces both the source and destination MAC addresses at every hop since MAC addresses are only relevant within each local network segment.',
        ),
      ),
    ];
  }
}
