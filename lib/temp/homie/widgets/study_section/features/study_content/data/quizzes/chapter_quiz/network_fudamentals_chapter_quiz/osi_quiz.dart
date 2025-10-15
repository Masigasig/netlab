import '../../../../models/content_block.dart';
import '../../../../models/quiz_data.dart';

class OsiModelQuiz implements ModuleContent {
  @override
  String get moduleId => 'nf_osi_model_quiz';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What does OSI stand for?',
          options: [
            'Open System Interconnection',
            'Operating System Interface',
            'Online Service Integration',
            'Open Signal Interface',
          ],
          correctAnswerIndex: 0,
          explanation:
              'OSI stands for Open System Interconnection — a model that standardizes network communication functions.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'How many layers does the OSI model have?',
          options: ['5', '6', '7', '8'],
          correctAnswerIndex: 2,
          explanation:
              'The OSI model is composed of seven layers, each responsible for a specific aspect of data communication.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Which of the following is the correct order of OSI layers (from top to bottom)?',
          options: [
            'Physical, Data Link, Network, Transport, Session, Presentation, Application',
            'Application, Presentation, Session, Transport, Network, Data Link, Physical',
            'Application, Transport, Network, Data Link, Physical, Session, Presentation',
            'Network, Transport, Session, Application, Data Link, Physical, Presentation',
          ],
          correctAnswerIndex: 1,
          explanation:
              'The OSI layers from top to bottom are: Application, Presentation, Session, Transport, Network, Data Link, and Physical.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Which layer is responsible for end-to-end communication and reliability?',
          options: [
            'Network layer',
            'Session layer',
            'Transport layer',
            'Data Link layer',
          ],
          correctAnswerIndex: 2,
          explanation:
              'The Transport layer handles end-to-end communication, reliability, and flow control (e.g., TCP).',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'At which layer does IP (Internet Protocol) operate?',
          options: [
            'Network layer',
            'Transport layer',
            'Session layer',
            'Data Link layer',
          ],
          correctAnswerIndex: 0,
          explanation:
              'IP operates at the Network layer, which is responsible for logical addressing and routing data packets.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What is the main function of the Data Link layer?',
          options: [
            'To transmit raw bits over physical media',
            'To detect and correct errors from the Physical layer',
            'To manage sessions between applications',
            'To encrypt and compress data',
          ],
          correctAnswerIndex: 1,
          explanation:
              'The Data Link layer ensures reliable transmission by detecting and possibly correcting errors that occur in the Physical layer.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Which OSI layer is responsible for converting data into signals?',
          options: [
            'Transport layer',
            'Network layer',
            'Data Link layer',
            'Physical layer',
          ],
          correctAnswerIndex: 3,
          explanation:
              'The Physical layer handles the transmission of raw bits over a physical medium such as cables or radio waves.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'At which layer do encryption and data formatting typically occur?',
          options: [
            'Session layer',
            'Presentation layer',
            'Network layer',
            'Application layer',
          ],
          correctAnswerIndex: 1,
          explanation:
              'The Presentation layer formats data and handles encryption, compression, and translation between systems.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Which layer provides the interface for the user and applications to access the network?',
          options: [
            'Session layer',
            'Presentation layer',
            'Application layer',
            'Network layer',
          ],
          correctAnswerIndex: 2,
          explanation:
              'The Application layer provides network services directly to user applications such as email, web browsing, and file transfer.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'True or False: The OSI model helps standardize network communication by separating functions into layers.',
          options: ['True', 'False'],
          correctAnswerIndex: 0,
          explanation:
              'True — the OSI model divides communication processes into seven layers to ensure interoperability among different systems and protocols.',
        ),
      ),
    ];
  }
}
