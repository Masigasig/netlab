import '../models/content_block.dart';
import '../models/quiz_data.dart';
import '../../quiz/helpers/topic_quiz_manager.dart';
import 'network_fundamentals/network_fundamentals_quiz.dart';
import 'network_fundamentals/host_quiz.dart';

class NetworkFundamentalsTopicQuiz implements ModuleContent {
  final TopicQuizManager _quizManager = TopicQuizManager();

  @override
  String get moduleId => 'nf_topic_quiz';

  @override
  List<ContentBlock> getContent() {
    final chapterQuizzes = [NFQuiz().getContent(), HostQuiz().getContent()];

    final topicSpecificQuestions = [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Which combination of networking concepts work together to enable end-to-end communication?',
          options: [
            'Only IP addresses',
            'Networks, hosts, and IP addresses',
            'Only physical connections',
            'Only network protocols',
          ],
          correctAnswerIndex: 1,
          explanation:
              'End-to-end communication requires the combination of networks, hosts, and IP addresses working together.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'How do the different layers of the OSI model contribute to network communication?',
          options: [
            'Only the physical layer matters',
            'Each layer works independently',
            'Layers work together in a hierarchical manner',
            'Only application layer is important',
          ],
          correctAnswerIndex: 2,
          explanation:
              'The OSI model layers work together hierarchically, each providing specific services to the layer above and using services from the layer below.',
        ),
      ),
    ];

    // Create topic quiz with combined questions
    return _quizManager.createTopicQuiz(
      chapterQuizzes: chapterQuizzes,
      topicSpecificQuestions: topicSpecificQuestions,
      totalQuestions: 10,
      questionsPerChapter: 4,
    );
  }
}
