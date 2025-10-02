import 'package:flutter/material.dart';

class ModuleNavigationCoordinator {
  // Handle module completion with appropriate navigation
  static Future<void> handleModuleCompletion({
    required BuildContext context,
    required int currentIndex,
    required int totalModules,
    required VoidCallback? onNextModule,
  }) async {
    // Show completion message
    _showCompletionSnackBar(context);

    // Wait a moment before navigating
    await Future.delayed(const Duration(milliseconds: 500));

    if (!context.mounted) return;

    // Navigate based on module position
    if (currentIndex < totalModules - 1) {
      // There's a next module available
      onNextModule?.call();
    } else {
      // This is the last module - show course completion
      _showCourseCompletionMessage(context);
    }
  }

  // Show snackbar for individual module completion
  static void _showCompletionSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chapter completed!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Show snackbar for complete course completion
  static void _showCourseCompletionMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Congratulations! You have completed all modules!'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  // Navigate to next module if user is already on a completed module
  static void moveToNextModule({
    required int currentIndex,
    required int totalModules,
    required VoidCallback? onNextModule,
  }) {
    if (currentIndex < totalModules - 1) {
      onNextModule?.call();
    }
  }

  // Check if this is the last module in the course
  static bool isLastModule(int currentIndex, int totalModules) {
    return currentIndex >= totalModules - 1;
  }
}
