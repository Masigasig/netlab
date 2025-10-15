import '../../../../models/content_block.dart';
import '../../../../models/quiz_data.dart';

class PacketTransmissionReceptionQuiz implements ModuleContent {
  @override
  String get moduleId => 'hh_packet_transmission_quiz';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What happens during the packet transmission process?',
          options: [
            'Data is converted into electrical signals or bits for transmission',
            'The receiving host creates new data',
            'Only the network layer processes the information',
            'Packets are stored permanently in routers',
          ],
          correctAnswerIndex: 0,
          explanation:
              'During transmission, the sender encapsulates data into packets and converts them into signals (electrical, optical, or radio) for delivery across the network.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'When a packet reaches the destination device, what process occurs?',
          options: [
            'Encapsulation',
            'Decapsulation',
            'Fragmentation',
            'Encryption',
          ],
          correctAnswerIndex: 1,
          explanation:
              'At the receiver’s end, decapsulation occurs — each OSI layer removes its corresponding header information to interpret the data correctly.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'In what order does encapsulation occur during packet creation?',
          options: [
            'Application → Transport → Network → Data Link → Physical',
            'Physical → Data Link → Network → Transport → Application',
            'Network → Application → Data Link → Physical → Transport',
            'Transport → Network → Physical → Application → Data Link',
          ],
          correctAnswerIndex: 0,
          explanation:
              'Encapsulation occurs from top to bottom: each higher OSI layer passes data to the next lower layer, which adds its own header before transmission.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What is the purpose of headers added during encapsulation?',
          options: [
            'To store the application name',
            'To provide control and addressing information for each layer',
            'To encrypt the data',
            'To reduce data size',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Headers include addressing, sequencing, and control information that help devices deliver and reassemble packets properly.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What happens to headers during the decapsulation process at the destination?',
          options: [
            'They are removed one by one by each corresponding layer',
            'They are duplicated for record-keeping',
            'They are sent back to the sender',
            'They are combined into a single header',
          ],
          correctAnswerIndex: 0,
          explanation:
              'During decapsulation, each layer removes its header and passes the remaining data up the OSI stack until it reaches the application layer.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Which OSI layer is responsible for delivering packets to the correct physical device on the network?',
          options: [
            'Data Link Layer',
            'Network Layer',
            'Transport Layer',
            'Application Layer',
          ],
          correctAnswerIndex: 0,
          explanation:
              'The Data Link layer ensures that packets are delivered to the correct device on the same local network using MAC addresses.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Which OSI layer is responsible for identifying the correct destination IP address during transmission?',
          options: [
            'Network Layer',
            'Transport Layer',
            'Application Layer',
            'Session Layer',
          ],
          correctAnswerIndex: 0,
          explanation:
              'The Network layer uses IP addresses to determine the correct path and destination for packet delivery.',
        ),
      ),
    ];
  }
}
