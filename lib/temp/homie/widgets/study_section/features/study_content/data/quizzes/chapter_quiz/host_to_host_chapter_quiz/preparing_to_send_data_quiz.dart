import '../../../../models/content_block.dart';
import '../../../../models/quiz_data.dart';

class PreparingToSendDataQuiz implements ModuleContent {
  @override
  String get moduleId => 'hh_preparing_quiz';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What happens before data is sent across a network?',
          options: [
            'The data is deleted to free up space',
            'The data is formatted, addressed, and encapsulated for transmission',
            'The data is automatically compressed by the router',
            'The data is divided randomly into small packets',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Before sending, data goes through encapsulation — it is formatted, addressed, and broken into packets suitable for transmission.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What is encapsulation in the context of data transmission?',
          options: [
            'Adding control information to data as it moves through network layers',
            'Removing headers and footers from packets',
            'Encrypting data for secure communication',
            'Combining multiple packets into a single frame',
          ],
          correctAnswerIndex: 0,
          explanation:
              'Encapsulation is the process of adding headers and sometimes footers to data as it moves down the network layers to prepare it for transmission.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Which layer of the OSI model is responsible for packaging data into segments for transmission?',
          options: [
            'Application Layer',
            'Transport Layer',
            'Network Layer',
            'Physical Layer',
          ],
          correctAnswerIndex: 1,
          explanation:
              'The Transport Layer segments data for transmission, ensuring it can be reassembled properly at the destination.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'True or False: Only the sending device adds headers to data packets.',
          options: ['True', 'False'],
          correctAnswerIndex: 1,
          explanation:
              'False — both the sending and receiving devices use headers; the sender adds them during encapsulation, and the receiver reads them to interpret data properly.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What is included in a packet’s header?',
          options: [
            'Source and destination IP addresses',
            'User’s login credentials',
            'Device storage information',
            'File permissions',
          ],
          correctAnswerIndex: 0,
          explanation:
              'Headers contain important information such as source and destination IP addresses to ensure proper delivery of packets.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Which protocol is primarily responsible for logical addressing during the data preparation process?',
          options: [
            'IP (Internet Protocol)',
            'HTTP (Hypertext Transfer Protocol)',
            'Ethernet',
            'DNS (Domain Name System)',
          ],
          correctAnswerIndex: 0,
          explanation:
              'The Internet Protocol (IP) handles logical addressing, assigning source and destination IP addresses to each packet during data preparation.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What ensures that large data files are properly divided before transmission?',
          options: [
            'Segmentation by the Transport Layer',
            'Encapsulation by the Network Layer',
            'Switch forwarding tables',
            'Encryption by the Application Layer',
          ],
          correctAnswerIndex: 0,
          explanation:
              'The Transport Layer divides large data into smaller segments, ensuring efficient transmission and correct reassembly at the destination.',
        ),
      ),
    ];
  }
}
