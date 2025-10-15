import '../../../../models/content_block.dart';
import '../../../../models/quiz_data.dart';

class SwitchQuiz implements ModuleContent {
  @override
  String get moduleId => 'nd_switch_quiz';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What is the main function of a network switch?',
          options: [
            'To connect multiple network segments and manage traffic intelligently',
            'To connect computers wirelessly',
            'To assign IP addresses to devices',
            'To amplify electrical signals between cables',
          ],
          correctAnswerIndex: 0,
          explanation:
              'A switch connects multiple devices in a network and directs data only to the intended recipient using MAC address information, improving efficiency.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'At which OSI layer does a typical network switch operate?',
          options: [
            'Physical Layer (Layer 1)',
            'Data Link Layer (Layer 2)',
            'Network Layer (Layer 3)',
            'Application Layer (Layer 7)',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Most switches operate at the Data Link layer (Layer 2), using MAC addresses to make forwarding decisions.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'How does a switch determine which port to send a frame to?',
          options: [
            'By checking the source IP address',
            'By using a MAC address table built from learned addresses',
            'By sending the frame to all connected devices',
            'By randomly selecting a port',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Switches maintain a MAC address table that maps device addresses to ports. They use it to forward frames only where needed.',
        ),
      ),
      // ContentBlock(
      //   type: ContentBlockType.quiz,
      //   content: QuizData(
      //     question:
      //         'True or False: A switch creates a separate collision domain for each connected device.',
      //     options: ['True', 'False'],
      //     correctAnswerIndex: 0,
      //     explanation:
      //         'True — switches reduce collisions by providing a dedicated connection and collision domain for each port.',
      //   ),
      // ),
      // ContentBlock(
      //   type: ContentBlockType.quiz,
      //   content: QuizData(
      //     question: 'How is a switch different from a hub?',
      //     options: [
      //       'A switch forwards data only to the destination device, while a hub broadcasts to all devices.',
      //       'A switch operates slower than a hub.',
      //       'A hub filters traffic intelligently like a switch.',
      //       'They are identical in function but differ in size.',
      //     ],
      //     correctAnswerIndex: 0,
      //     explanation:
      //         'Unlike hubs, switches forward frames only to the device that needs them, reducing unnecessary network traffic and improving speed.',
      //   ),
      // ),
      // ContentBlock(
      //   type: ContentBlockType.quiz,
      //   content: QuizData(
      //     question: 'Which of the following describes a Layer 3 switch?',
      //     options: [
      //       'It only forwards data based on MAC addresses',
      //       'It can route packets using IP addresses in addition to switching frames',
      //       'It acts as a repeater to boost signal strength',
      //       'It can only operate within a single LAN segment',
      //     ],
      //     correctAnswerIndex: 1,
      //     explanation:
      //         'A Layer 3 switch combines the functions of a router and switch — it can make forwarding decisions using both MAC and IP addresses.',
      //   ),
      // ),
    ];
  }
}
