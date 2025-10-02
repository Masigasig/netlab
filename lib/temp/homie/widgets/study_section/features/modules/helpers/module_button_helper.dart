import 'package:flutter/material.dart';

class ModuleButtonHelper {
  static String getButtonText({
    required bool isCompleted,
    required bool isLastModule,
  }) {
    if (!isCompleted) {
      return isLastModule ? 'Complete Course' : 'Complete & Next Module';
    } else {
      return isLastModule ? 'Course Completed' : 'Go to Next Module';
    }
  }

  static IconData getButtonIcon({
    required bool isCompleted,
    required bool isLastModule,
  }) {
    if (!isCompleted) {
      return isLastModule ? Icons.check_circle : Icons.arrow_forward;
    } else {
      return isLastModule ? Icons.check_circle : Icons.arrow_forward;
    }
  }

  // Get button background color based on state
  static Color getButtonColor({
    required bool isCompleted,
    required bool isLastModule,
    required ColorScheme colorScheme,
  }) {
    if (isLastModule && isCompleted) {
      return colorScheme.primary.withAlpha(153);
    } else if (isCompleted) {
      return colorScheme.secondary;
    } else {
      return colorScheme.primary;
    }
  }

  // Check if button should be disabled
  static bool isButtonDisabled({
    required bool isCompleted,
    required bool isLastModule,
  }) {
    return isLastModule && isCompleted;
  }

  // Get helper text to show below the button
  static String? getHelperText({
    required bool isCompleted,
    required bool isLastModule,
  }) {
    if (!isLastModule && !isCompleted) {
      return 'Complete this module to unlock the next one';
    }
    return null;
  }
}
