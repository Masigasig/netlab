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
          question:
              'Which OSI layer is responsible for routing packets between networks?',
          options: [
            'Physical Layer',
            'Data Link Layer',
            'Network Layer',
            'Transport Layer',
          ],
          correctAnswerIndex: 2,
          explanation:
              'The Network Layer (Layer 3) is responsible for logical addressing and routing packets across different networks.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Which OSI layer ensures error detection and organizes bits into frames?',
          options: [
            'Physical Layer',
            'Data Link Layer',
            'Transport Layer',
            'Application Layer',
          ],
          correctAnswerIndex: 1,
          explanation:
              'The Data Link Layer (Layer 2) is responsible for error detection and framing of data for reliable delivery on the same network.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'Which OSI layer transmits raw bits as signals over physical media?',
          options: [
            'Application Layer',
            'Physical Layer',
            'Network Layer',
            'Presentation Layer',
          ],
          correctAnswerIndex: 1,
          explanation:
              'The Physical Layer (Layer 1) deals with raw transmission of bits over physical media like cables, fiber optics, or wireless signals.',
        ),
      ),
    ];
  }
}
