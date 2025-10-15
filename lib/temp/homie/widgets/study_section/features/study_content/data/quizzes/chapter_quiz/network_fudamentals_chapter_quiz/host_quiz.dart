import '../../../../models/content_block.dart';
import '../../../../models/quiz_data.dart';

class HostQuiz implements ModuleContent {
  @override
  String get moduleId => 'nf_host_quiz';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What is a host in a computer network?',
          options: [
            'A person who manages the network',
            'A device that connects to other devices and sends or receives data',
            'A cable used for connection',
            'A software application',
          ],
          correctAnswerIndex: 1,
          explanation:
              'A host is any device that connects to other devices and can send or receive data over a network.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'Which of the following devices can be considered a host?',
          options: ['Computer', 'Smartphone', 'Printer', 'All of the above'],
          correctAnswerIndex: 3,
          explanation:
              'All devices that can send or receive data on a network, such as computers, smartphones, and printers, are considered hosts.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What determines if a device is a host?',
          options: [
            'Its size and power',
            'Its ability to send or receive traffic over a network',
            'Its manufacturer',
            'Its IP address format',
          ],
          correctAnswerIndex: 1,
          explanation:
              'A device is considered a host if it can send or receive network traffic, regardless of its type or size.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What are the two main categories of hosts?',
          options: [
            'Modems and routers',
            'Clients and servers',
            'Hubs and switches',
            'Access points and cables',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Hosts are categorized as clients and servers—clients request data or services, while servers provide them.',
        ),
      ),
      // ContentBlock(
      //   type: ContentBlockType.quiz,
      //   content: QuizData(
      //     question: 'What does a client do in a network?',
      //     options: [
      //       'Responds to other devices’ requests',
      //       'Initiates a request for data or services',
      //       'Controls all network communication',
      //       'Blocks incoming connections',
      //     ],
      //     correctAnswerIndex: 1,
      //     explanation:
      //         'A client initiates communication by requesting data or services from a server.',
      //   ),
      // ),
      // ContentBlock(
      //   type: ContentBlockType.quiz,
      //   content: QuizData(
      //     question: 'What does a server do in a network?',
      //     options: [
      //       'Sends requests to clients',
      //       'Responds to client requests and provides resources',
      //       'Manages local printers only',
      //       'Converts analog signals to digital',
      //     ],
      //     correctAnswerIndex: 1,
      //     explanation:
      //         'A server responds to client requests and provides data, services, or resources on a network.',
      //   ),
      // ),
      // ContentBlock(
      //   type: ContentBlockType.quiz,
      //   content: QuizData(
      //     question:
      //         'True or False: Any device that sends or receives data over a network is considered a host.',
      //     options: ['True', 'False'],
      //     correctAnswerIndex: 0,
      //     explanation:
      //         'This is true—any device capable of sending or receiving network data qualifies as a host.',
      //   ),
      // ),
      // ContentBlock(
      //   type: ContentBlockType.quiz,
      //   content: QuizData(
      //     question: 'The role of a host (client or server) in a network is:',
      //     options: [
      //       'To store only local files',
      //       'To participate in communication by sending or receiving data',
      //       'To build network cables',
      //       'To configure routers',
      //     ],
      //     correctAnswerIndex: 1,
      //     explanation:
      //         'A host’s main role is to communicate on the network by sending or receiving data.',
      //   ),
      // ),
    ];
  }
}
