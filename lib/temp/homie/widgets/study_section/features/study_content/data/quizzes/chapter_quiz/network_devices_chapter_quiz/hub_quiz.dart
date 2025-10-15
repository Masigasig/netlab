import '../../../../models/content_block.dart';
import '../../../../models/quiz_data.dart';

class HubQuiz implements ModuleContent {
  @override
  String get moduleId => 'nd_hub_quiz';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What is the main function of a hub in a network?',
          options: [
            'To regenerate and amplify signals',
            'To forward data packets to a specific destination',
            'To broadcast data to all connected devices',
            'To store MAC addresses for each port',
          ],
          correctAnswerIndex: 2,
          explanation:
              'A hub broadcasts incoming data to all its ports, meaning every connected device receives the same data, regardless of the intended recipient.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'At which OSI layer does a hub operate?',
          options: [
            'Physical layer (Layer 1)',
            'Data Link layer (Layer 2)',
            'Network layer (Layer 3)',
            'Transport layer (Layer 4)',
          ],
          correctAnswerIndex: 0,
          explanation:
              'A hub operates at the Physical layer (Layer 1) of the OSI model because it deals with electrical or signal transmission, not data addressing or logic.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'How does a hub handle network traffic?',
          options: [
            'It filters traffic and sends it only to the destination device',
            'It sends all traffic to all connected ports',
            'It stores data temporarily before forwarding it',
            'It converts digital data to analog signals',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Hubs are simple devices that forward all incoming signals to every port, which can lead to unnecessary traffic on the network.',
        ),
      ),
      // ContentBlock(
      //   type: ContentBlockType.quiz,
      //   content: QuizData(
      //     question: 'True or False: A hub can reduce network collisions.',
      //     options: ['True', 'False'],
      //     correctAnswerIndex: 1,
      //     explanation:
      //         'False — since hubs broadcast data to all devices, they increase the likelihood of collisions within the same network segment.',
      //   ),
      // ),
      // ContentBlock(
      //   type: ContentBlockType.quiz,
      //   content: QuizData(
      //     question:
      //         'What type of domain does a hub create for all connected devices?',
      //     options: [
      //       'Separate collision domains',
      //       'A single collision domain',
      //       'Separate broadcast domains',
      //       'A virtual LAN (VLAN)',
      //     ],
      //     correctAnswerIndex: 1,
      //     explanation:
      //         'All devices connected to a hub share the same collision domain, meaning simultaneous transmissions can interfere with each other.',
      //   ),
      // ),
      // ContentBlock(
      //   type: ContentBlockType.quiz,
      //   content: QuizData(
      //     question:
      //         'What is one disadvantage of using a hub compared to a switch?',
      //     options: [
      //       'It is more expensive',
      //       'It does not support multiple data transmissions at once',
      //       'It cannot be connected to other networks',
      //       'It operates at a higher OSI layer',
      //     ],
      //     correctAnswerIndex: 1,
      //     explanation:
      //         'Unlike switches, hubs cannot send data simultaneously to different devices. They send one signal to all ports, causing inefficiency and collisions.',
      //   ),
      // ),
    ];
  }
}
