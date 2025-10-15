import '../../../../models/content_block.dart';
import '../../../../models/quiz_data.dart';

class NetworkIpQuiz implements ModuleContent {
  @override
  String get moduleId => 'nf_network_ip_quiz';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What is the main purpose of an IP address?',
          options: [
            'To identify a device uniquely on a network',
            'To provide Internet speed',
            'To locate websites on search engines',
            'To store user credentials',
          ],
          correctAnswerIndex: 0,
          explanation:
              'An IP address uniquely identifies a device on a network, allowing it to send and receive data.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'Which of the following is a valid IPv4 address?',
          options: ['256.1.1.1', '192.168.1.1', '999.0.0.1', '1234.12.0.1'],
          correctAnswerIndex: 1,
          explanation:
              'IPv4 addresses use four octets (0–255). The example 192.168.1.1 is a valid IPv4 address.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What does the subnet mask determine?',
          options: [
            'The physical layout of a network',
            'The division between network and host portions of an IP address',
            'The type of cabling used',
            'The Internet connection speed',
          ],
          correctAnswerIndex: 1,
          explanation:
              'A subnet mask defines which part of an IP address identifies the network and which part identifies the host.',
        ),
      ),
      // ContentBlock(
      //   type: ContentBlockType.quiz,
      //   content: QuizData(
      //     question: 'What is the default subnet mask for a Class C network?',
      //     options: [
      //       '255.0.0.0',
      //       '255.255.0.0',
      //       '255.255.255.0',
      //       '255.255.255.255',
      //     ],
      //     correctAnswerIndex: 2,
      //     explanation:
      //         'The default subnet mask for Class C networks is 255.255.255.0, meaning the first three octets define the network.',
      //   ),
      // ),
      // ContentBlock(
      //   type: ContentBlockType.quiz,
      //   content: QuizData(
      //     question: 'Which of the following is a private IP address?',
      //     options: ['8.8.8.8', '172.16.0.1', '198.51.100.5', '203.0.113.1'],
      //     correctAnswerIndex: 1,
      //     explanation:
      //         '172.16.0.1 belongs to the private IP range (172.16.0.0 – 172.31.255.255).',
      //   ),
      // ),
      // ContentBlock(
      //   type: ContentBlockType.quiz,
      //   content: QuizData(
      //     question: 'What is the purpose of a default gateway?',
      //     options: [
      //       'To allow devices to access other networks or the Internet',
      //       'To store DNS records',
      //       'To provide Wi-Fi connectivity',
      //       'To encrypt network traffic',
      //     ],
      //     correctAnswerIndex: 0,
      //     explanation:
      //         'A default gateway routes traffic from a local network to external networks such as the Internet.',
      //   ),
      // ),
      // ContentBlock(
      //   type: ContentBlockType.quiz,
      //   content: QuizData(
      //     question:
      //         'True or False: Every device on the Internet must have a unique public IP address.',
      //     options: ['True', 'False'],
      //     correctAnswerIndex: 0,
      //     explanation:
      //         'True — each device that directly connects to the Internet must have a unique public IP to communicate properly.',
      //   ),
      // ),
    ];
  }
}
