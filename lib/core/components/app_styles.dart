import 'package:flutter/material.dart';
import '../themes/app_color.dart';
import '../../temp/core/constants/app_text.dart';

class AppStyles {
  // MARK: - Standard Spacing & Dimensions

  static const double cardRadius = 16.0;
  static const double badgeRadius = 20.0;
  static const double chipRadius = 24.0;

  static const EdgeInsets cardPadding = EdgeInsets.all(24);
  static const EdgeInsets cardMargin = EdgeInsets.fromLTRB(32, 0, 32, 24);
  static const EdgeInsets badgePadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 6,
  );
  static const EdgeInsets iconBadgePadding = EdgeInsets.all(8);
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 8,
  );

  // MARK: - Primary Card Decorations

  /// Primary colored card (for stats, highlights)
  static BoxDecoration primaryCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BoxDecoration(
      color: cs.primary,
      borderRadius: BorderRadius.circular(cardRadius),
      boxShadow: [
        BoxShadow(
          color: cs.primary.withAlpha(38), // 15% opacity
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  /// Secondary colored card (for stats, highlights)
  static BoxDecoration secondaryCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BoxDecoration(
      color: cs.secondary,
      borderRadius: BorderRadius.circular(cardRadius),
      boxShadow: [
        BoxShadow(
          color: cs.secondary.withAlpha(38), // 15% opacity
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  /// Surface card with subtle border (for content cards)
  static BoxDecoration surfaceCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BoxDecoration(
      color: cs.surfaceContainerLow.withAlpha(179), // 70% opacity
      borderRadius: BorderRadius.circular(cardRadius),
      border: Border.all(
        color: cs.primary.withAlpha(26), // 10% opacity
        width: 1,
      ),
    );
  }

  // MARK: - Card Variations

  /// Elevated surface card with shadow
  static BoxDecoration elevatedCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BoxDecoration(
      color: cs.surface,
      borderRadius: BorderRadius.circular(cardRadius),
      boxShadow: [
        BoxShadow(
          color: cs.onSurface.withAlpha(20), // 8% opacity
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: cs.onSurface.withAlpha(10), // 4% opacity
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// Outline card with transparent background
  static BoxDecoration outlineCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(cardRadius),
      border: Border.all(
        color: cs.primary.withAlpha(77), // 30% opacity
        width: 2,
      ),
    );
  }

  /// Gradient card with primary/secondary colors
  static BoxDecoration gradientCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      borderRadius: BorderRadius.circular(cardRadius),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [
                cs.primary.withAlpha(204), // 80% opacity
                cs.secondary.withAlpha(153), // 60% opacity
              ]
            : [cs.primary, cs.secondary],
      ),
      boxShadow: [
        BoxShadow(
          color: cs.primary.withAlpha(77), // 30% opacity
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  /// Glass card with frosted effect
  static BoxDecoration glassCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BoxDecoration(
      color: cs.surface.withAlpha(26), // 10% opacity
      borderRadius: BorderRadius.circular(cardRadius),
      border: Border.all(
        color: cs.onSurface.withAlpha(26), // 10% opacity
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: cs.onSurface.withAlpha(13), // 5% opacity
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  // MARK: - Special Purpose Cards

  /// Achievement/success card
  static BoxDecoration achievementCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BoxDecoration(
      color: cs.secondary.withAlpha(26), // 10% opacity
      borderRadius: BorderRadius.circular(cardRadius),
      border: Border.all(
        color: cs.secondary.withAlpha(77), // 30% opacity
        width: 1,
      ),
    );
  }

  /// Warning/alert card
  static BoxDecoration warningCard(BuildContext context) {
    // final cs = Theme.of(context).colorScheme;
    return BoxDecoration(
      color: AppColors.warningColor.withAlpha(26), // 10% opacity
      borderRadius: BorderRadius.circular(cardRadius),
      border: Border.all(
        color: AppColors.warningColor.withAlpha(77), // 30% opacity
        width: 1,
      ),
    );
  }

  /// Info/tip card
  static BoxDecoration infoCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BoxDecoration(
      color: cs.primary.withAlpha(26), // 10% opacity
      borderRadius: BorderRadius.circular(cardRadius),
      border: Border.all(
        color: cs.primary.withAlpha(77), // 30% opacity
        width: 1,
      ),
    );
  }

  /// Error card
  static BoxDecoration errorCard(BuildContext context) {
    // final cs = Theme.of(context).colorScheme;
    return BoxDecoration(
      color: AppColors.errorColor.withAlpha(26), // 10% opacity
      borderRadius: BorderRadius.circular(cardRadius),
      border: Border.all(
        color: AppColors.errorColor.withAlpha(77), // 30% opacity
        width: 1,
      ),
    );
  }

  // MARK: - Badge Decorations

  /// Primary badge decoration
  static BoxDecoration primaryBadge(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BoxDecoration(
      color: cs.primary.withAlpha(51), // 20% opacity
      borderRadius: BorderRadius.circular(badgeRadius),
    );
  }

  /// Secondary badge decoration
  static BoxDecoration secondaryBadge(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BoxDecoration(
      color: cs.secondaryContainer,
      borderRadius: BorderRadius.circular(badgeRadius),
      border: Border.all(
        color: cs.secondaryContainer.withAlpha(128), // 50% opacity
        width: 1,
      ),
    );
  }

  /// Success badge decoration
  static BoxDecoration successBadge(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BoxDecoration(
      color: cs.secondary.withAlpha(51), // 20% opacity
      borderRadius: BorderRadius.circular(badgeRadius),
      border: Border.all(
        color: cs.secondary.withAlpha(77), // 30% opacity
        width: 1,
      ),
    );
  }

  /// Warning badge decoration
  static BoxDecoration warningBadge(BuildContext context) {
    return BoxDecoration(
      color: AppColors.warningColor.withAlpha(51), // 20% opacity
      borderRadius: BorderRadius.circular(badgeRadius),
      border: Border.all(
        color: AppColors.warningColor.withAlpha(77), // 30% opacity
        width: 1,
      ),
    );
  }

  /// Premium gradient badge decoration
  static BoxDecoration premiumBadge(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BoxDecoration(
      borderRadius: BorderRadius.circular(badgeRadius),
      gradient: LinearGradient(colors: [cs.primary, cs.secondary]),
    );
  }

  // MARK: - Widget Builders

  /// Stats card widget
  static Widget statsCard({
    required BuildContext context,
    required String title,
    required String value,
    required String subtitle,
    bool isPrimary = true,
  }) {
    final cs = Theme.of(context).colorScheme;
    final decoration = isPrimary
        ? primaryCard(context)
        : secondaryCard(context);
    final textColor = isPrimary ? cs.onPrimary : cs.onSecondary;

    return Container(
      padding: cardPadding,
      decoration: decoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.withColor(
              AppTextStyles.subtitleMedium,
              textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.withColor(
              AppTextStyles.headerMedium,
              textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyles.withColor(
              AppTextStyles.bodySmall,
              textColor.withAlpha(230), // 90% opacity
            ),
          ),
        ],
      ),
    );
  }

  /// Badge widget with text
  static Widget badge({
    required BuildContext context,
    required String text,
    BadgeType type = BadgeType.primary,
    Widget? icon,
  }) {
    final cs = Theme.of(context).colorScheme;

    BoxDecoration decoration;
    Color textColor;
    EdgeInsets padding;

    switch (type) {
      case BadgeType.primary:
        decoration = primaryBadge(context);
        textColor = cs.primary;
        padding = badgePadding;
        break;
      case BadgeType.secondary:
        decoration = secondaryBadge(context);
        textColor = cs.onSecondaryContainer;
        padding = iconBadgePadding;
        break;
      case BadgeType.success:
        decoration = successBadge(context);
        textColor = cs.secondary;
        padding = badgePadding;
        break;
      case BadgeType.warning:
        decoration = warningBadge(context);
        textColor = AppColors.warningColor;
        padding = badgePadding;
        break;
      case BadgeType.premium:
        decoration = premiumBadge(context);
        textColor = Colors.white;
        padding = badgePadding;
        break;
    }

    return Container(
      padding: padding,
      decoration: decoration,
      child:
          icon ??
          Text(
            text,
            style: AppTextStyles.withColor(AppTextStyles.label, textColor),
          ),
    );
  }

  /// Chip badge with icon and text
  static Widget chipBadge({
    required BuildContext context,
    required String text,
    required IconData icon,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: chipPadding,
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(chipRadius),
        border: Border.all(color: cs.primary.withAlpha(51), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: cs.primary),
          const SizedBox(width: 6),
          Text(
            text,
            style: AppTextStyles.forSurface(
              AppTextStyles.subtitleMedium,
              context,
            ),
          ),
        ],
      ),
    );
  }

  // MARK: - Quick Helper Methods

  /// Get text color for given background color
  static Color getTextColorForBackground(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5
        ? Colors.black87
        : Colors.white;
  }

  /// Get appropriate shadow for elevation level
  static List<BoxShadow> getElevationShadow(BuildContext context, int level) {
    final cs = Theme.of(context).colorScheme;
    final shadowColor = cs.onSurface.withAlpha(26); // 10% opacity

    switch (level) {
      case 1:
        return [
          BoxShadow(
            color: shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ];
      case 2:
        return [
          BoxShadow(
            color: shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ];
      case 3:
        return [
          BoxShadow(
            color: shadowColor,
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ];
      default:
        return [];
    }
  }
}

/// Badge types for different use cases
enum BadgeType {
  primary, // For main actions, counts
  secondary, // For status indicators
  success, // For completion states
  warning, // For alerts, reminders
  premium, // For premium features -- this is gradient
}
