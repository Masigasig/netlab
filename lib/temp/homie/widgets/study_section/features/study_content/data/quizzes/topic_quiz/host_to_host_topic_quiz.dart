import '../../../models/content_block.dart';
import '../../../models/quiz_data.dart';
import '../../../../quiz/helpers/topic_quiz_manager.dart';
import '../chapter_quiz/host_to_host_chapter_quiz/host_overview_quiz.dart';
import '../chapter_quiz/host_to_host_chapter_quiz/preparing_to_send_data_quiz.dart';
import '../chapter_quiz/host_to_host_chapter_quiz/address_resolution_protocol_quiz.dart';
import '../chapter_quiz/host_to_host_chapter_quiz/packet_transmission_reception_quiz.dart';
import '../chapter_quiz/host_to_host_chapter_quiz/subsequent_communication_quiz.dart';

class HostToHostTopicQuiz implements ModuleContent {
  final TopicQuizManager _quizManager = TopicQuizManager();

  @override
  String get moduleId => 'h2h_topic_quiz';

  @override
  List<ContentBlock> getContent() {
    final chapterQuizzes = [
      HostOverviewQuiz().getContent(),
      PreparingToSendDataQuiz().getContent(),
      AddressResolutionProtocolQuiz().getContent(),
      PacketTransmissionReceptionQuiz().getContent(),
      SubsequentCommunicationQuiz().getContent(),
    ];

    final topicSpecificQuestions = [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What is the main purpose of host-to-host communication in networking?',
          options: [
            'To store data locally within a single computer',
            'To allow direct data exchange between two end devices over a network',
            'To prevent devices from communicating over different networks',
            'To send messages only through routers',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Host-to-host communication enables two devices to exchange data directly across a network using addressing and protocols for reliable transmission.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'How does the ARP process support host-to-host communication?',
          options: [
            'By translating MAC addresses into IP addresses',
            'By translating IP addresses into MAC addresses for data delivery',
            'By assigning new IP addresses to devices',
            'By encrypting data between hosts',
          ],
          correctAnswerIndex: 1,
          explanation:
              'The ARP process maps IP addresses to their corresponding MAC addresses, ensuring packets are delivered to the correct device on the local network.',
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
