import '../../../../models/content_block.dart';
import '../../../../models/quiz_data.dart';

class RepeaterQuiz implements ModuleContent {
  @override
  String get moduleId => 'nd_repeater_quiz';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What is the main function of a repeater?',
          options: [
            'To connect multiple networks together',
            'To regenerate and amplify signals in a network',
            'To convert digital signals into analog signals',
            'To filter data packets based on addresses',
          ],
          correctAnswerIndex: 1,
          explanation:
              'A repeater regenerates and amplifies weak or distorted signals to extend the distance a signal can travel over a network.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'At which layer of the OSI model does a repeater operate?',
          options: [
            'Physical layer',
            'Data Link layer',
            'Network layer',
            'Transport layer',
          ],
          correctAnswerIndex: 0,
          explanation:
              'A repeater operates at the Physical layer (Layer 1) because it deals with signal transmission and regeneration, not data interpretation.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'Why are repeaters used in a network?',
          options: [
            'To increase the number of connected users',
            'To extend the range of a network by boosting signals',
            'To provide wireless access points',
            'To convert protocols between two networks',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Repeaters are used to extend the reach of a network by boosting or regenerating signals that weaken over long distances.',
        ),
      ),
      // ContentBlock(
      //   type: ContentBlockType.quiz,
      //   content: QuizData(
      //     question:
      //         'True or False: A repeater can filter or interpret the data being transmitted.',
      //     options: ['True', 'False'],
      //     correctAnswerIndex: 1,
      //     explanation:
      //         'False — repeaters simply regenerate signals; they do not interpret, filter, or inspect the data being transmitted.',
      //   ),
      // ),
      // ContentBlock(
      //   type: ContentBlockType.quiz,
      //   content: QuizData(
      //     question:
      //         'What happens if too many repeaters are used in a single network segment?',
      //     options: [
      //       'It reduces signal strength further',
      //       'It can cause signal timing and collision issues',
      //       'It improves performance continuously',
      //       'It automatically creates subnetworks',
      //     ],
      //     correctAnswerIndex: 1,
      //     explanation:
      //         'Using too many repeaters can cause network delays and collisions due to timing problems, especially in Ethernet-based networks.',
      //   ),
      // ),
      // ContentBlock(
      //   type: ContentBlockType.quiz,
      //   content: QuizData(
      //     question:
      //         'Which of the following best describes a limitation of repeaters?',
      //     options: [
      //       'They only work in wireless networks',
      //       'They cannot regenerate digital signals',
      //       'They do not filter traffic or segment networks',
      //       'They require a static IP configuration',
      //     ],
      //     correctAnswerIndex: 2,
      //     explanation:
      //         'Repeaters cannot filter traffic or divide networks; they simply extend the same collision domain by regenerating signals.',
      //   ),
      // ),
    ];
  }
}
