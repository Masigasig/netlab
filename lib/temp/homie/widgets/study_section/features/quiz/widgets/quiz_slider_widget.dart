import 'package:flutter/material.dart';
import 'package:netlab/temp/homie/widgets/study_section/features/study_content/models/quiz_data.dart';
import 'package:netlab/temp/core/constants/app_text.dart';
import '../controllers/quiz_controller.dart';
import 'quiz_widget.dart';

class QuizSliderWidget extends StatefulWidget {
  final List<QuizData> quizDataList;
  final ModuleQuizController quizController;

  const QuizSliderWidget({
    super.key,
    required this.quizDataList,
    required this.quizController,
  });

  @override
  State<QuizSliderWidget> createState() => _QuizSliderWidgetState();
}

class _QuizSliderWidgetState extends State<QuizSliderWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Register all questions with the controller
    for (int i = 0; i < widget.quizDataList.length; i++) {
      widget.quizController.registerQuestion(
        i,
        widget.quizDataList[i].correctAnswerIndex,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < widget.quizDataList.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Page indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            // color: cs.onSurfaceVariant.withAlpha(77),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${_currentPage + 1} of ${widget.quizDataList.length}',
                style: AppTextStyles.subtitleMedium.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: List.generate(
                  widget.quizDataList.length,
                  (index) => Container(
                    margin: const EdgeInsets.only(left: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? cs.primary
                          : cs.onSurfaceVariant.withAlpha(77),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Quiz content
        SizedBox(
          height: 450,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.quizDataList.length,
            itemBuilder: (context, index) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: QuizWidget(
                  quizData: widget.quizDataList[index],
                  quizController: widget.quizController,
                  questionIndex: index,
                ),
              );
            },
          ),
        ),

        // Navigation buttons
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            // color: cs.onSurfaceVariant.withAlpha(26),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous button
              TextButton.icon(
                onPressed: _currentPage > 0 ? _previousPage : null,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Previous'),
                style: TextButton.styleFrom(foregroundColor: cs.primary),
              ),

              // Next button
              TextButton.icon(
                onPressed: _currentPage < widget.quizDataList.length - 1
                    ? _nextPage
                    : null,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Next'),
                iconAlignment: IconAlignment.end,
                style: TextButton.styleFrom(foregroundColor: cs.primary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
