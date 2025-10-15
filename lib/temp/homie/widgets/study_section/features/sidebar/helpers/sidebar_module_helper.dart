import 'package:flutter/material.dart';

class SidebarModuleHelper {
  /// Get icon based on module state
  static IconData getModuleIcon({
    required bool isCompleted,
    required bool isAccessible,
    required IconData moduleIcon,
  }) {
    if (isCompleted) return Icons.check_circle;
    return moduleIcon;
  }

  /// Get icon size based on state
  static double getIconSize({required bool isCompleted}) {
    return isCompleted ? 18 : 16;
  }

  /// Get container color based on state
  static Color getContainerColor({
    required bool isCompleted,
    required bool isAccessible,
    required Color typeColor,
    required ColorScheme colorScheme,
  }) {
    if (isCompleted) return colorScheme.primary.withAlpha(51);
    return typeColor;
  }

  /// Get icon color based on state
  static Color getIconColor({
    required bool isCompleted,
    required bool isAccessible,
    required ColorScheme colorScheme,
  }) {
    if (isCompleted) return colorScheme.primary;
    return colorScheme.onPrimary;
  }

  /// Get title color based on state
  static Color getTitleColor({
    required bool isAccessible,
    required bool isSelected,
    required ColorScheme colorScheme,
  }) {
    return isSelected
        ? colorScheme.onSurface.withAlpha(230)
        : colorScheme.onSurface.withAlpha(204);
  }

  /// Get subtitle color based on state
  static Color getSubtitleColor({
    required bool isAccessible,
    required ColorScheme colorScheme,
  }) {
    return colorScheme.onSurfaceVariant.withAlpha(153);
  }

  /// Get badge background color
  static Color getBadgeColor({
    required bool isAccessible,
    required Color typeColor,
    required ColorScheme colorScheme,
  }) {
    return typeColor;
  }

  /// Get badge text color
  static Color getBadgeTextColor({
    required bool isAccessible,
    required ColorScheme colorScheme,
  }) {
    return colorScheme.onPrimary;
  }

  /// Check if container should have a border
  static BoxBorder? getContainerBorder({
    required bool isCompleted,
    required ColorScheme colorScheme,
  }) {
    return isCompleted
        ? Border.all(color: colorScheme.primary, width: 1.5)
        : null;
  }
}
