import '../../models/content_block.dart';
import '../../models/quiz_data.dart';

class RoutingSwitchingQuiz implements ModuleContent {
  @override
  String get moduleId => 'sr_quiz';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What is the main function of a switch in a network?',
          options: [
            'To connect multiple different networks',
            'To assign IP addresses to hosts',
            'To move (switch) data between devices inside the same LAN',
            'To amplify weak signals',
          ],
          correctAnswerIndex: 2,
          explanation:
              'A switch forwards data between devices within the same LAN efficiently.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'Which address does a switch use to deliver frames?',
          options: ['IP address', 'Subnet mask', 'MAC address', 'Port number'],
          correctAnswerIndex: 2,
          explanation:
              'Switches use MAC addresses to determine the destination for each frame.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What happens when a switch receives a frame from a new device it hasn’t seen before?',
          options: [
            'It drops the frame',
            'It floods the frame to all ports except the source',
            'It sends the frame to the router',
            'It rejects the connection',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Unknown destination frames are flooded to all ports except the source port to reach the intended device.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Which of the following best describes the Learn → Flood → Forward process in a switch?',
          options: [
            'Learn new IP addresses, flood unknown packets, forward broadcasts only',
            'Learn new MAC addresses, flood if destination unknown, forward directly if known',
            'Learn subnet masks, flood ARP requests, forward packets based on routing table',
            'Learn IP routes, flood all traffic, forward broadcasts',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Switches learn MAC addresses, flood frames if the destination is unknown, and forward directly if known.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'An ARP Request is sent as:',
          options: [
            'A unicast frame',
            'A broadcast frame to all devices on the LAN',
            'A static route update',
            'A multicast frame',
          ],
          correctAnswerIndex: 1,
          explanation:
              'ARP requests are broadcasted to all devices in the local network to find the MAC address of a given IP.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What is the main difference between a host and a router?',
          options: [
            'A host can forward packets, while a router cannot',
            'A router forwards packets not addressed to itself, while a host only handles its own traffic',
            'A host always has multiple IP addresses, a router only has one',
            'A router only works at Layer 2, while a host works at Layer 3',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Routers forward packets between networks, whereas hosts only process traffic addressed to themselves.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'Why does a router need multiple IP and MAC addresses?',
          options: [
            'To act as a backup device in case of failure',
            'To identify itself uniquely on each network it connects to',
            'To communicate faster within the same subnet',
            'To replace switches in a LAN',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Routers have multiple IP and MAC addresses to uniquely identify themselves on each connected network.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What does a routing table contain?',
          options: [
            'A list of MAC addresses and ports',
            'Instructions for which network can be reached through which router/interface',
            'The ARP cache mappings for IP and MAC',
            'Encryption keys for network traffic',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Routing tables contain instructions on how to reach different networks via specific routers or interfaces.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Which type of route is automatically added when a router is physically connected to a network?',
          options: [
            'Static route',
            'Directly connected route',
            'Dynamic route',
            'Default route',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Directly connected routes are automatically added when a router interface is connected to a network.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Which of the following uses routing protocols to automatically share route information between routers?',
          options: [
            'Static routing',
            'Directly connected routes',
            'Dynamic routing',
            'ARP requests',
          ],
          correctAnswerIndex: 2,
          explanation:
              'Dynamic routing uses routing protocols to exchange routing information automatically between routers.',
        ),
      ),
    ];
  }
}
