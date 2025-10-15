import '../../../../models/content_block.dart';
import '../../../../models/quiz_data.dart';

class SwitchOperationsQuiz implements ModuleContent {
  @override
  String get moduleId => 'sr_switch_operations_quiz';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What is the primary function of a network switch?',
          options: [
            'To connect multiple networks together',
            'To forward frames based on MAC addresses',
            'To assign IP addresses to connected devices',
            'To filter packets using IP routing tables',
          ],
          correctAnswerIndex: 1,
          explanation:
              'A switch forwards Ethernet frames based on the MAC address table, directing traffic to the correct destination port.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'When a switch receives a frame, which part of the frame does it examine to decide where to send it?',
          options: [
            'The source IP address',
            'The destination MAC address',
            'The frame checksum',
            'The VLAN tag',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Switches operate at the Data Link layer (Layer 2) and use the destination MAC address to determine the correct output port for the frame.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What happens when a switch receives a broadcast frame?',
          options: [
            'It drops the frame immediately',
            'It sends the frame to the router only',
            'It forwards the frame to all ports except the one it was received on',
            'It only sends it to one random port',
          ],
          correctAnswerIndex: 2,
          explanation:
              'Broadcast frames are sent to all ports except the incoming one, allowing all devices in the broadcast domain to receive it.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What does a switch do before forwarding a frame to its destination?',
          options: [
            'It checks for an entry in its MAC address table',
            'It assigns a new MAC address to the frame',
            'It converts the frame to a packet',
            'It sends the frame to the router for processing',
          ],
          correctAnswerIndex: 0,
          explanation:
              'Before forwarding, the switch checks its MAC address table to determine the correct port to send the frame through.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What happens when a switch cannot find the destination MAC address in its table?',
          options: [
            'It drops the frame',
            'It sends the frame to all ports (flooding)',
            'It requests the MAC address from the DHCP server',
            'It logs the event but takes no action',
          ],
          correctAnswerIndex: 1,
          explanation:
              'If the destination MAC is unknown, the switch floods the frame to all ports except the incoming one to find the correct destination device.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'Which process allows a switch to learn new MAC addresses?',
          options: [
            'By checking the source MAC address of incoming frames',
            'By scanning the IP address range in the network',
            'By requesting ARP replies from routers',
            'By reading the routing table entries',
          ],
          correctAnswerIndex: 0,
          explanation:
              'Switches learn MAC addresses by recording the source address of each incoming frame and associating it with the receiving port.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What is the benefit of switching compared to using a hub?',
          options: [
            'Switches provide full-duplex communication and reduce collisions',
            'Switches broadcast all traffic like hubs',
            'Switches only work with wireless signals',
            'Switches increase network congestion intentionally',
          ],
          correctAnswerIndex: 0,
          explanation:
              'Switches enable full-duplex communication between devices and eliminate collisions by isolating traffic per port, unlike hubs which broadcast everything.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Which type of switching operation allows data to be forwarded as soon as the destination MAC is read?',
          options: [
            'Cut-through switching',
            'Store-and-forward switching',
            'Fragment-free switching',
            'Fast-switching',
          ],
          correctAnswerIndex: 0,
          explanation:
              'Cut-through switching starts forwarding frames as soon as the destination MAC address is read, minimizing latency.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What advantage does store-and-forward switching have over cut-through switching?',
          options: [
            'It reduces latency significantly',
            'It checks for frame errors before forwarding',
            'It sends frames faster without checking CRC',
            'It floods all ports automatically',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Store-and-forward switching verifies the frame’s integrity by checking the CRC before forwarding, ensuring error-free transmission.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'True or False: Switches operate primarily at OSI Layer 3.',
          options: ['True', 'False'],
          correctAnswerIndex: 1,
          explanation:
              'False — switches primarily operate at Layer 2 (Data Link Layer), though some multilayer switches also perform Layer 3 routing functions.',
        ),
      ),
    ];
  }
}
