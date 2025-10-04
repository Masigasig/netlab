import 'package:flutter/material.dart';
import '../helpers/module_button_helper.dart';
import '../.././quiz/controllers/quiz_controller.dart';

class ModuleCompletionButton extends StatelessWidget {
  final bool isCompleted;
  final bool isLastModule;
  final bool hasQuizzes;
  final ModuleQuizController? quizController;
  final VoidCallback onPressed;

  const ModuleCompletionButton({
    super.key,
    required this.isCompleted,
    required this.isLastModule,
    required this.hasQuizzes,
    this.quizController,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // If has quizzes, wrap in ListenableBuilder to hide until submitted
    if (hasQuizzes && quizController != null) {
      return ListenableBuilder(
        listenable: quizController!,
        builder: (context, _) {
          if (!quizController!.isSubmitted) {
            return const SizedBox.shrink();
          }
          return _buildButton(cs);
        },
      );
    }

    // No quizzes, show button directly
    return _buildButton(cs);
  }

  Widget _buildButton(ColorScheme cs) {
    return Column(
      children: [
        Center(
          child: FilledButton.icon(
            onPressed:
                ModuleButtonHelper.isButtonDisabled(
                  isCompleted: isCompleted,
                  isLastModule: isLastModule,
                )
                ? null
                : onPressed,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                ModuleButtonHelper.getButtonColor(
                  isCompleted: isCompleted,
                  isLastModule: isLastModule,
                  colorScheme: cs,
                ),
              ),
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            icon: Icon(
              ModuleButtonHelper.getButtonIcon(
                isCompleted: isCompleted,
                isLastModule: isLastModule,
              ),
              color: cs.onPrimary,
            ),
            label: Text(
              ModuleButtonHelper.getButtonText(
                isCompleted: isCompleted,
                isLastModule: isLastModule,
              ),
              style: TextStyle(
                color: cs.onPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        _buildHelperText(cs),
      ],
    );
  }

  Widget _buildHelperText(ColorScheme cs) {
    final helperText = ModuleButtonHelper.getHelperText(
      isCompleted: isCompleted,
      isLastModule: isLastModule,
    );

    if (helperText == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Center(
        child: Text(
          helperText,
          style: TextStyle(
            fontSize: 12,
            color: cs.onSurfaceVariant,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
