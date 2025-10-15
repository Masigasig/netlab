import '../../../../models/content_block.dart';
import '../../../../models/quiz_data.dart';

class SubsequentCommunicationQuiz implements ModuleContent {
  @override
  String get moduleId => 'h2h_subsequent_communication_quiz';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What happens during subsequent communications between two hosts after the first data exchange?',
          options: [
            'The ARP process is repeated every time',
            'The destination MAC address is retrieved from the ARP cache',
            'The sender must manually re-enter the destination IP',
            'The packet is sent without addressing information',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Once the initial ARP process is done, subsequent communications use the stored MAC address in the ARP cache to send packets more efficiently.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Why is the ARP cache important for subsequent communication?',
          options: [
            'It stores frequently used MAC addresses for faster communication',
            'It blocks unknown IP addresses',
            'It encrypts all packets sent across the network',
            'It stores data backups of transmitted packets',
          ],
          correctAnswerIndex: 0,
          explanation:
              'The ARP cache allows devices to quickly map IP addresses to MAC addresses, avoiding the need to repeat the ARP broadcast each time.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What happens if an entry in the ARP cache becomes outdated or invalid?',
          options: [
            'The ARP process is triggered again to refresh the entry',
            'The system automatically shuts down communication',
            'The MAC address is guessed based on the IP',
            'The device sends packets to all devices on the network',
          ],
          correctAnswerIndex: 0,
          explanation:
              'If a cache entry expires or changes, the sender performs another ARP request to update the correct mapping.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'True or False: Once an ARP entry is learned, it stays permanently in the cache.',
          options: ['True', 'False'],
          correctAnswerIndex: 1,
          explanation:
              'False — ARP entries have a timeout period. If not refreshed, they are removed to keep the cache accurate and up-to-date.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'How does caching improve the efficiency of subsequent communication?',
          options: [
            'By reducing the need for repeated ARP broadcasts',
            'By increasing the size of transmitted packets',
            'By encrypting all ARP messages',
            'By using only IP addresses instead of MAC addresses',
          ],
          correctAnswerIndex: 0,
          explanation:
              'Caching eliminates the overhead of ARP requests for known devices, enabling faster and more efficient data delivery in future transmissions.',
        ),
      ),
    ];
  }
}
