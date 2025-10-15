import '../../../models/content_block.dart';
import '../../../models/quiz_data.dart';
import '../../../../quiz/helpers/topic_quiz_manager.dart';
import '../chapter_quiz/network_devices_chapter_quiz/repeater_quiz.dart';
import '../chapter_quiz/network_devices_chapter_quiz/hub_quiz.dart';
import '../chapter_quiz/network_devices_chapter_quiz/bridge_quiz.dart';
import '../chapter_quiz/network_devices_chapter_quiz/switch_quiz.dart';
import '../chapter_quiz/network_devices_chapter_quiz/router_quiz.dart';

class NetworkDevicesTopicQuiz implements ModuleContent {
  final TopicQuizManager _quizManager = TopicQuizManager();

  @override
  String get moduleId => 'nd_topic_quiz';

  @override
  List<ContentBlock> getContent() {
    final chapterQuizzes = [
      RepeaterQuiz().getContent(),
      HubQuiz().getContent(),
      BridgeQuiz().getContent(),
      SwitchQuiz().getContent(),
      RouterQuiz().getContent(),
    ];

    final topicSpecificQuestions = [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'How do different network devices such as hubs, switches, and routers work together in a network?',
          options: [
            'They all perform the same function at different speeds',
            'They operate at different OSI layers to handle data transmission efficiently',
            'They are used only in wireless communication',
            'They replace each other depending on bandwidth',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Each device functions at a specific OSI layer — hubs at Layer 1, switches at Layer 2, and routers at Layer 3 — allowing efficient and organized data handling across a network.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Which statement best describes how switches and routers differ?',
          options: [
            'Switches connect networks, routers connect devices',
            'Routers operate at the Network layer while switches work at the Data Link layer',
            'Routers are slower because they amplify signals',
            'Switches use IP addresses while routers use MAC addresses',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Switches function mainly at the Data Link layer (Layer 2), using MAC addresses, while routers operate at the Network layer (Layer 3), directing data using IP addresses.',
        ),
      ),
    ];

    // Combine and limit total questions
    return _quizManager.createTopicQuiz(
      chapterQuizzes: chapterQuizzes,
      topicSpecificQuestions: topicSpecificQuestions,
      totalQuestions: 10,
      questionsPerChapter: 1,
    );
  }
}
