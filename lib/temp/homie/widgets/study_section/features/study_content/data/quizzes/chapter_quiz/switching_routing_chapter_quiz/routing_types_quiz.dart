import '../../../../models/content_block.dart';
import '../../../../models/quiz_data.dart';

class RoutingTypesQuiz implements ModuleContent {
  @override
  String get moduleId => 'sr_routing_types_quiz';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What are the two main types of routing?',
          options: [
            'Manual and Automatic Routing',
            'Static and Dynamic Routing',
            'Direct and Indirect Routing',
            'LAN and WAN Routing',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Routing is categorized into Static Routing (manually configured) and Dynamic Routing (automatically learned through routing protocols).',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'Which statement best describes static routing?',
          options: [
            'Routes are automatically updated using routing protocols',
            'Routes are manually configured and remain constant until changed by an administrator',
            'Routes depend on MAC address lookups',
            'Routes are temporary and deleted after every restart',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Static routing requires manual configuration and does not change automatically, providing predictable and stable routing paths.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What is a key advantage of using dynamic routing over static routing?',
          options: [
            'It requires no configuration at all',
            'It automatically updates routes when network topology changes',
            'It uses less memory and CPU resources',
            'It is more secure by default',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Dynamic routing automatically updates and recalculates routes when network changes occur, providing greater flexibility in larger or changing networks.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'True or False: Static routing is more suitable for small, stable networks.',
          options: ['True', 'False'],
          correctAnswerIndex: 0,
          explanation:
              'True — static routing works best in smaller, fixed networks where routes rarely change, making it simple and reliable.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Which of the following is an example of a dynamic routing protocol?',
          options: ['DNS', 'OSPF', 'ARP', 'HTTP'],
          correctAnswerIndex: 1,
          explanation:
              'OSPF (Open Shortest Path First) is a dynamic routing protocol that allows routers to share route information and automatically update paths based on network conditions.',
        ),
      ),
    ];
  }
}
