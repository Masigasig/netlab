import '../../../../models/content_block.dart';
import '../../../../models/quiz_data.dart';

class BridgeQuiz implements ModuleContent {
  @override
  String get moduleId => 'nd_bridge_quiz';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What is the main function of a bridge in a network?',
          options: [
            'To connect and filter traffic between two network segments',
            'To amplify electrical signals',
            'To broadcast data to all connected devices',
            'To assign IP addresses to hosts',
          ],
          correctAnswerIndex: 0,
          explanation:
              'A bridge connects two or more network segments and filters traffic based on MAC addresses, improving efficiency and reducing collisions.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'At which OSI layer does a bridge operate?',
          options: [
            'Physical layer (Layer 1)',
            'Data Link layer (Layer 2)',
            'Network layer (Layer 3)',
            'Transport layer (Layer 4)',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Bridges operate at the Data Link layer (Layer 2) because they use MAC addresses to determine where to forward or filter frames.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'How does a bridge decide whether to forward or block a data frame?',
          options: [
            'By checking the IP address of the sender',
            'By using the MAC address table it builds',
            'By broadcasting the frame to all ports',
            'By measuring signal strength',
          ],
          correctAnswerIndex: 1,
          explanation:
              'A bridge maintains a MAC address table that maps devices to specific ports. It uses this table to forward frames only where needed.',
        ),
      ),
      // ContentBlock(
      //   type: ContentBlockType.quiz,
      //   content: QuizData(
      //     question:
      //         'True or False: A bridge helps reduce collisions by dividing a network into multiple collision domains.',
      //     options: ['True', 'False'],
      //     correctAnswerIndex: 0,
      //     explanation:
      //         'True — each port on a bridge represents a separate collision domain, which helps reduce unnecessary traffic and collisions.',
      //   ),
      // ),
      // ContentBlock(
      //   type: ContentBlockType.quiz,
      //   content: QuizData(
      //     question:
      //         'What is one advantage of using a bridge compared to a hub?',
      //     options: [
      //       'It operates faster due to physical connections',
      //       'It filters traffic and forwards data only to the destination segment',
      //       'It uses less memory and has no logic',
      //       'It can operate at higher network layers',
      //     ],
      //     correctAnswerIndex: 1,
      //     explanation:
      //         'Unlike hubs, bridges filter and forward data selectively using MAC addresses, which reduces unnecessary network traffic.',
      //   ),
      // ),
      // ContentBlock(
      //   type: ContentBlockType.quiz,
      //   content: QuizData(
      //     question:
      //         'Which of the following best describes how a bridge learns about devices on a network?',
      //     options: [
      //       'It uses ARP requests to find all devices',
      //       'It inspects the source MAC address of incoming frames',
      //       'It relies on a manual configuration of MAC addresses',
      //       'It broadcasts to every device and waits for responses',
      //     ],
      //     correctAnswerIndex: 1,
      //     explanation:
      //         'Bridges automatically learn device locations by examining the source MAC addresses of incoming frames and storing them in a table.',
      //   ),
      // ),
    ];
  }
}
