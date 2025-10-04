import '../../models/content_block.dart';
import '../../models/quiz_data.dart';

class H2HQuiz implements ModuleContent {
  @override
  String get moduleId => 'h2h_quiz';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What uniquely identifies a host at the hardware level?',
          options: ['IP address', 'Port number', 'MAC address', 'Subnet mask'],
          correctAnswerIndex: 2,
          explanation:
              'A MAC address uniquely identifies a host at the hardware (data link) level.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What uniquely identifies a host logically across different networks?',
          options: ['NIC card', 'IP address', 'ARP cache', 'Router'],
          correctAnswerIndex: 1,
          explanation:
              'An IP address uniquely identifies a host logically across networks.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'The subnet mask works with the IP address to:',
          options: [
            'Translate MAC addresses',
            'Determine if the destination is on the same local network',
            'Assign IP addresses automatically',
            'Encrypt data packets',
          ],
          correctAnswerIndex: 1,
          explanation:
              'The subnet mask helps determine if a destination is within the same subnet or needs routing.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'If two devices are on the same subnet, how do they communicate?',
          options: [
            'Through a router',
            'Directly with each other',
            'Through the Internet',
            'Using a switch only',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Devices on the same subnet can communicate directly without going through a router.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'If the destination device is on a different subnet, the data must pass through:',
          options: ['Switch', 'Bridge', 'Router', 'Hub'],
          correctAnswerIndex: 2,
          explanation:
              'Data must pass through a router to reach a different subnet.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What is contained in the IP header (Layer 3)?',
          options: [
            'Source and destination MAC addresses',
            'Source and destination IP addresses',
            'Subnet mask and gateway address',
            'ARP cache entries',
          ],
          correctAnswerIndex: 1,
          explanation:
              'The IP header contains the source and destination IP addresses for end-to-end delivery.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'Why is ARP needed in networking?',
          options: [
            'To map IP addresses to MAC addresses',
            'To encrypt and secure communication',
            'To assign subnet masks',
            'To regenerate weak signals',
          ],
          correctAnswerIndex: 0,
          explanation:
              'ARP maps IP addresses to MAC addresses to deliver packets at the data link layer.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'An ARP Request is:',
          options: [
            'A unicast message to one host',
            'A broadcast asking which device has a given IP address',
            'A reply message containing a MAC address',
            'A packet filtering rule',
          ],
          correctAnswerIndex: 1,
          explanation:
              'An ARP Request is broadcasted to all devices to find the MAC address of a given IP.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'After receiving an ARP Reply, where does the host store the mapping of IP to MAC?',
          options: ['IP header', 'NIC', 'ARP cache', 'Subnet mask'],
          correctAnswerIndex: 2,
          explanation:
              'The host stores IP-to-MAC mappings in the ARP cache for faster future communication.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What happens once both devices already have each other’s IP-to-MAC mapping?',
          options: [
            'They must repeat the ARP request for every packet',
            'Communication becomes faster since ARP is not needed again until cache expires',
            'They stop using MAC addresses',
            'They only use Layer 3 addresses for delivery',
          ],
          correctAnswerIndex: 1,
          explanation:
              'With mappings in the ARP cache, communication is faster and ARP requests are not needed until cache expiry.',
        ),
      ),
    ];
  }
}
