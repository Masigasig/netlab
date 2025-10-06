import 'package:flutter/material.dart';
import 'package:netlab/temp/core/constants/app_text.dart';

class QuickActionsSection extends StatelessWidget {
  final VoidCallback? onContinueLearning;
  final VoidCallback? onBrowseTopics;

  const QuickActionsSection({
    super.key,
    this.onContinueLearning,
    this.onBrowseTopics,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Quick Actions', cs),
        const SizedBox(height: 12),
        _buildActionButton(
          icon: Icons.play_arrow,
          label: 'Continue Learning',
          color: cs.primary,
          onTap: onContinueLearning,
        ),
        const SizedBox(height: 10),
        _buildActionButton(
          icon: Icons.search,
          label: 'Browse Topics',
          color: cs.secondary,
          onTap: onBrowseTopics,
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, ColorScheme cs) {
    return Builder(
      builder: (context) => Text(
        title,
        style: AppTextStyles.forSurface(AppTextStyles.headerSmall, context),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Builder(
      builder: (context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 10),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.forPrimary(
                  AppTextStyles.buttonMedium,
                  context,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
