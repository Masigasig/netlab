import '../../../models/content_block.dart';
import '../../../models/quiz_data.dart';
import '../../../../quiz/helpers/topic_quiz_manager.dart';
import '../chapter_quiz/switching_routing_chapter_quiz/intro_to_switching_quiz.dart';
import '../chapter_quiz/switching_routing_chapter_quiz/mac_address_table_quiz.dart';
import '../chapter_quiz/switching_routing_chapter_quiz/switch_operations_quiz.dart';
import '../chapter_quiz/switching_routing_chapter_quiz/introduction_to_routing_quiz.dart';
import '../chapter_quiz/switching_routing_chapter_quiz/router_vs_host_quiz.dart';
import '../chapter_quiz/switching_routing_chapter_quiz/router_network_connections_quiz.dart';
import '../chapter_quiz/switching_routing_chapter_quiz/routing_table_quiz.dart';
import '../chapter_quiz/switching_routing_chapter_quiz/routing_types_quiz.dart';

class SwitchingRoutingTopicQuiz implements ModuleContent {
  final TopicQuizManager _quizManager = TopicQuizManager();

  @override
  String get moduleId => 'sr_topic_quiz';

  @override
  List<ContentBlock> getContent() {
    final chapterQuizzes = [
      IntroToSwitchingQuiz().getContent(),
      MacAddressTableQuiz().getContent(),
      SwitchOperationsQuiz().getContent(),
      IntroductionToRoutingQuiz().getContent(),
      RouterVsHostQuiz().getContent(),
      RouterNetworkConnectionsQuiz().getContent(),
      RoutingTableQuiz().getContent(),
      RoutingTypesQuiz().getContent(),
    ];

    final topicSpecificQuestions = [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'How do switches and routers work together to enable network communication?',
          options: [
            'Switches manage data across networks, routers forward data within a single LAN',
            'Routers connect multiple networks, while switches forward frames within a local network',
            'Both perform routing functions using IP addresses',
            'Routers and switches operate at the same OSI layer',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Switches forward data within the same LAN using MAC addresses (Layer 2), while routers connect multiple networks using IP addresses (Layer 3).',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What is the primary advantage of using switches and routers together in a network?',
          options: [
            'They reduce network speed but increase reliability',
            'They allow for efficient data transmission and scalable network communication',
            'They eliminate the need for IP addressing',
            'They only work in small LAN setups',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Using both switches and routers allows efficient local communication (via switching) and global connectivity (via routing), making networks scalable and efficient.',
        ),
      ),
    ];

    // Combine all quizzes with topic-specific ones
    return _quizManager.createTopicQuiz(
      chapterQuizzes: chapterQuizzes,
      topicSpecificQuestions: topicSpecificQuestions,
      totalQuestions: 10,
      questionsPerChapter: 1,
    );
  }
}
