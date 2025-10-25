import 'package:flutter/material.dart';
import '../models/tutorial_item.dart';
import 'package:netlab/temp/core/constants/app_text.dart';

class TutorialItemTile extends StatelessWidget {
  final TutorialItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const TutorialItemTile({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? cs.primaryContainer.withAlpha(80)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 16,
                  color: isSelected ? cs.primary : cs.onSurface.withAlpha(153),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.title,
                    style: isSelected
                        ? AppTextStyles.forPrimary(
                            AppTextStyles.buttonSmall,
                            context,
                          ).copyWith(fontWeight: FontWeight.w600)
                        : AppTextStyles.forSurface(
                            AppTextStyles.bodySmall,
                            context,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
