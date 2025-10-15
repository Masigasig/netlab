import '../../../../models/content_block.dart';
import '../../../../models/quiz_data.dart';

class IntroToSwitchingQuiz implements ModuleContent {
  @override
  String get moduleId => 'sr_intro_switching_quiz';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What is the primary function of a network switch in a LAN environment?',
          options: [
            'To broadcast all data to every connected device',
            'To forward data frames only to the destination device using MAC addresses',
            'To convert analog signals to digital signals',
            'To assign IP addresses to devices on the network',
          ],
          correctAnswerIndex: 1,
          explanation:
              'A switch operates at the Data Link layer and forwards data frames to the correct device by checking MAC addresses, reducing unnecessary traffic.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'At which OSI layer does a traditional switch operate?',
          options: [
            'Layer 1 – Physical Layer',
            'Layer 2 – Data Link Layer',
            'Layer 3 – Network Layer',
            'Layer 4 – Transport Layer',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Switches primarily function at the Data Link layer (Layer 2) of the OSI model, using MAC addresses to forward frames within a LAN.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'How does a switch improve network performance compared to a hub?',
          options: [
            'It allows multiple devices to communicate simultaneously without collisions',
            'It increases the power output of network signals',
            'It adds wireless functionality to wired networks',
            'It broadcasts all traffic to every port to ensure reliability',
          ],
          correctAnswerIndex: 0,
          explanation:
              'Switches create separate collision domains for each connected device, allowing multiple simultaneous communications and improving network efficiency.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What information does a switch use to decide where to forward frames?',
          options: [
            'The destination IP address',
            'The destination MAC address',
            'The source IP address',
            'The source port number',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Switches use the destination MAC address to determine which port to forward a frame to, based on entries in the MAC address table.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'True or False: Switches reduce unnecessary traffic by sending data only to the intended recipient.',
          options: ['True', 'False'],
          correctAnswerIndex: 0,
          explanation:
              'True — switches intelligently forward data only to the destination device, reducing unnecessary network traffic and improving performance.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Which of the following best describes the MAC address table in a switch?',
          options: [
            'A list of IP addresses and hostnames',
            'A database mapping MAC addresses to switch ports',
            'A routing table used to connect networks',
            'A log of all transmitted packets',
          ],
          correctAnswerIndex: 1,
          explanation:
              'The MAC address table maps each device’s MAC address to the corresponding switch port, allowing accurate data delivery.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'When a switch receives a frame with an unknown destination MAC address, what does it do?',
          options: [
            'Drops the frame immediately',
            'Sends the frame to all ports except the one it came from',
            'Sends it only to the source port',
            'Waits until the MAC address is learned',
          ],
          correctAnswerIndex: 1,
          explanation:
              'If a switch doesn’t recognize the destination MAC address, it floods the frame to all ports (except the source) — similar to hub behavior — until the address is learned.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Which of the following is a benefit of using a switch over a hub?',
          options: [
            'Creates fewer collision domains',
            'Operates only at the Network layer',
            'Provides dedicated bandwidth per port',
            'Broadcasts all traffic for redundancy',
          ],
          correctAnswerIndex: 2,
          explanation:
              'Switches provide each port with dedicated bandwidth, preventing data collisions and improving throughput.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What happens when a switch learns a new MAC address from an incoming frame?',
          options: [
            'It deletes it after one transmission',
            'It adds the address and port number to its MAC address table',
            'It broadcasts it to all other devices',
            'It assigns a new IP address to the source device',
          ],
          correctAnswerIndex: 1,
          explanation:
              'When a switch receives a frame, it records the source MAC address and the port it arrived on in its MAC address table for future reference.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'True or False: Switches can only operate in half-duplex mode.',
          options: ['True', 'False'],
          correctAnswerIndex: 1,
          explanation:
              'False — modern switches support full-duplex communication, allowing devices to send and receive data simultaneously without collisions.',
        ),
      ),
    ];
  }
}
