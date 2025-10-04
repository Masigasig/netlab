import '../../models/content_block.dart';
import '../../models/quiz_data.dart';

class NFQuiz implements ModuleContent {
  @override
  String get moduleId => 'nf_quiz';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What is the main purpose of a computer network?',
          options: [
            'To play games only',
            'To connect devices and share resources',
            'To keep devices isolated',
            'To store electricity',
          ],
          correctAnswerIndex: 1,
          explanation:
              'A computer network allows devices to connect and share resources like files, printers, and internet connections.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'Which of the following is considered a host?',
          options: ['Router', 'Switch', 'Printer', 'Cable'],
          correctAnswerIndex: 2,
          explanation:
              'A host is any device connected to a network that can send or receive data. A printer is an example of a host.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'A device that initiates a request for resources is called a:',
          options: ['Server', 'Client', 'Switch', 'Router'],
          correctAnswerIndex: 1,
          explanation:
              'The client initiates requests for resources, while the server responds to them.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Which device responds to requests and provides resources or services?',
          options: ['Router', 'Client', 'Server', 'Switch'],
          correctAnswerIndex: 2,
          explanation:
              'The server provides resources or services to clients in a network.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'An IP address is similar to:',
          options: [
            'A password for your device',
            'A cable connector',
            'A house address or phone number for your device',
            'A security code',
          ],
          correctAnswerIndex: 2,
          explanation:
              'An IP address uniquely identifies a device logically across networks, similar to a house address.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'How many bits are in an IPv4 address?',
          options: ['8 bits', '16 bits', '32 bits', '64 bits'],
          correctAnswerIndex: 2,
          explanation:
              'IPv4 addresses are 32 bits long, allowing for over 4 billion unique addresses.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'Which networking device connects two different networks?',
          options: ['Switch', 'Router', 'Hub', 'Printer'],
          correctAnswerIndex: 1,
          explanation:
              'Routers are responsible for forwarding packets between different networks.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What allows a large network to be divided into smaller, logical groups?',
          options: ['Router', 'Subnetting', 'Cabling', 'Switching'],
          correctAnswerIndex: 1,
          explanation:
              'Subnetting divides a network into smaller, manageable subnets, improving performance and organization.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'Which statement about a network is TRUE?',
          options: [
            'A network only works with two computers',
            'A network allows devices to communicate and share data',
            'A network is the same as the Internet',
            'A network cannot have servers',
          ],
          correctAnswerIndex: 1,
          explanation:
              'A network enables devices to communicate and share data; it is not limited to two devices.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'The Internet is best described as:',
          options: [
            'One single network',
            'A group of devices in a home',
            'A vast collection of interconnected networks worldwide',
            'A private company’s internal system',
          ],
          correctAnswerIndex: 2,
          explanation:
              'The Internet is a massive network of networks connecting millions of devices globally.',
        ),
      ),
    ];
  }
}
