import '../../models/content_block.dart';
import '../../models/quiz_data.dart';

class NetworkingDevicesQuiz implements ModuleContent {
  @override
  String get moduleId => 'nd_quiz';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What is the main purpose of a repeater?',
          options: [
            'To connect different networks',
            'To amplify or regenerate signals',
            'To assign IP addresses',
            'To store data',
          ],
          correctAnswerIndex: 1,
          explanation:
              'A repeater amplifies or regenerates signals to extend the reach of a network.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What happens when data travels too far through a cable without a repeater?',
          options: [
            'It speeds up',
            'It becomes stronger',
            'It weakens (signal decay/attenuation)',
            'It gets encrypted',
          ],
          correctAnswerIndex: 2,
          explanation:
              'Without a repeater, signals weaken over long distances due to attenuation.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'A hub is also known as:',
          options: [
            'A multi-port repeater',
            'A filtering device',
            'A switch replacement',
            'A router',
          ],
          correctAnswerIndex: 0,
          explanation:
              'A hub is essentially a multi-port repeater, sending incoming signals to all ports.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'How does a hub send data?',
          options: [
            'Directly to the correct port using IP addresses',
            'To all connected devices, regardless of the destination',
            'Only to the device it was intended for',
            'By encrypting the signal first',
          ],
          correctAnswerIndex: 1,
          explanation:
              'A hub broadcasts incoming data to all connected devices regardless of the destination.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'A bridge improves on a repeater by also being able to:',
          options: [
            'Translate IP addresses',
            'Filter data using MAC addresses',
            'Assign subnet masks',
            'Encrypt communications',
          ],
          correctAnswerIndex: 1,
          explanation:
              'A bridge can filter traffic based on MAC addresses, unlike a simple repeater.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What is a common use of a bridge?',
          options: [
            'Extending the Internet',
            'Connecting two LANs working on the same network',
            'Assigning IP addresses to hosts',
            'Filtering data by IP address',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Bridges are commonly used to connect two LANs that operate on the same protocol.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'A switch learns where to send data by looking at:',
          options: [
            'IP addresses',
            'MAC addresses',
            'Device names',
            'Cable length',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Switches use MAC addresses to forward frames only to the intended device.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'How does a switch improve over a hub?',
          options: [
            'It sends data only to the correct device instead of all devices',
            'It encrypts all signals',
            'It uses repeaters internally',
            'It connects different networks',
          ],
          correctAnswerIndex: 0,
          explanation:
              'Switches forward data only to the correct destination, reducing unnecessary network traffic.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'A router is mainly responsible for:',
          options: [
            'Filtering data inside the same LAN',
            'Connecting different networks and routing packets based on IP addresses',
            'Regenerating weak signals',
            'Managing MAC addresses',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Routers connect different networks and route packets based on their IP addresses.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What is a gateway in networking?',
          options: [
            'A backup switch',
            'A host’s way out of the local network',
            'Another name for a hub',
            'A security firewall',
          ],
          correctAnswerIndex: 1,
          explanation:
              'A gateway provides hosts a way to communicate with devices outside their local network.',
        ),
      ),
    ];
  }
}
