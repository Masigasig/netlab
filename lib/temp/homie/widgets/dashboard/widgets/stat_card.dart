import 'package:flutter/material.dart';
import 'package:netlab/temp/core/constants/app_text.dart';

class StatCard extends StatelessWidget {
  final dynamic
  icon; // Changed from IconData to dynamic to accept both IconData and Widget
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget iconWidget;
    if (icon is IconData) {
      iconWidget = Icon(icon as IconData, color: color, size: 10);
    } else if (icon is Widget) {
      iconWidget = icon as Widget;
    } else {
      iconWidget = Icon(Icons.error, color: color, size: 10);
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow.withAlpha(179),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(26), width: 1),
        boxShadow: [
          BoxShadow(
            color: cs.onSurface.withAlpha(13),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withAlpha(51),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: iconWidget,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.forSurface(AppTextStyles.label, context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Value and subtitle
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: AppTextStyles.forSurface(
                  AppTextStyles.headerSmall,
                  context,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTextStyles.withOpacity(
                  AppTextStyles.forSurface(AppTextStyles.caption, context),
                  0.75,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
