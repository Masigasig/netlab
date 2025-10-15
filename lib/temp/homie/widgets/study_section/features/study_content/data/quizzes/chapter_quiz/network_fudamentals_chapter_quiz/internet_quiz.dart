import '../../../../models/content_block.dart';
import '../../../../models/quiz_data.dart';

class InternetQuiz implements ModuleContent {
  @override
  String get moduleId => 'nf_internet_quiz';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What is the Internet?',
          options: [
            'A single large computer',
            'A vast collection of interconnected networks',
            'A type of web browser',
            'A local area network',
          ],
          correctAnswerIndex: 1,
          explanation:
              'The Internet is a global system of interconnected computer networks that communicate using standard protocols.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What does the Internet enable devices around the world to do?',
          options: [
            'Store files locally',
            'Communicate and share information',
            'Disconnect from networks',
            'Block access to data',
          ],
          correctAnswerIndex: 1,
          explanation:
              'The Internet allows devices worldwide to connect, communicate, and exchange information.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'True or False: The Internet only connects computers within the same local network.',
          options: ['True', 'False'],
          correctAnswerIndex: 1,
          explanation:
              'False — the Internet connects millions of devices across different networks globally, not just local ones.',
        ),
      ),
      // ContentBlock(
      //   type: ContentBlockType.quiz,
      //   content: QuizData(
      //     question:
      //         'Which of the following best describes how the Internet works?',
      //     options: [
      //       'It connects all devices using a single wire',
      //       'It links many smaller networks together',
      //       'It requires a direct cable between every device',
      //       'It only works through satellites',
      //     ],
      //     correctAnswerIndex: 1,
      //     explanation:
      //         'The Internet links thousands of smaller networks together to form a global communication system.',
      //   ),
      // ),
      // ContentBlock(
      //   type: ContentBlockType.quiz,
      //   content: QuizData(
      //     question: 'What does the Internet allow users to access?',
      //     options: [
      //       'Only files on their own computer',
      //       'Resources from different networks',
      //       'Data from USB drives only',
      //       'Offline databases',
      //     ],
      //     correctAnswerIndex: 1,
      //     explanation:
      //         'Through the Internet, users can access resources and data from remote servers or networks.',
      //   ),
      // ),
      // ContentBlock(
      //   type: ContentBlockType.quiz,
      //   content: QuizData(
      //     question:
      //         'Do devices need to be on the same local network to communicate through the Internet?',
      //     options: ['Yes', 'No'],
      //     correctAnswerIndex: 1,
      //     explanation:
      //         'No — devices can communicate over the Internet even if they are on different local networks.',
      //   ),
      // ),
      // ContentBlock(
      //   type: ContentBlockType.quiz,
      //   content: QuizData(
      //     question:
      //         'Which of the following is an example of using the Internet?',
      //     options: [
      //       'Sending an email',
      //       'Browsing a website',
      //       'Watching an online video',
      //       'All of the above',
      //     ],
      //     correctAnswerIndex: 3,
      //     explanation:
      //         'All of these are examples of Internet use — they all require online data transmission.',
      //   ),
      // ),
      // ContentBlock(
      //   type: ContentBlockType.quiz,
      //   content: QuizData(
      //     question:
      //         'True or False: The Internet connects millions of networks and devices across the globe.',
      //     options: ['True', 'False'],
      //     correctAnswerIndex: 0,
      //     explanation:
      //         'True — the Internet connects countless devices and networks worldwide, enabling global communication.',
      //   ),
      // ),
    ];
  }
}
