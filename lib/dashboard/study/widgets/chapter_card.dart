import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:netlab/core/routing/go_router.dart';

class ChapterCard extends ConsumerWidget {
  final String chapterId;
  final Map<String, dynamic> chapterData;

  const ChapterCard({
    super.key,
    required this.chapterId,
    required this.chapterData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final progress = 20 / 100; //* TODO :riverpod value

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow.withAlpha(179),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.secondary.withAlpha(52), width: 1),
        boxShadow: [
          BoxShadow(
            color: cs.onSurface.withAlpha(13),
            blurRadius: 4,
            offset: const Offset(2, 4),
          ),
          BoxShadow(
            color: cs.secondary.withAlpha(26),
            blurRadius: 15,
            offset: const Offset(-5, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: cs.secondary.withAlpha(52),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedBookBookmark02,
                      size: 16,
                      color: cs.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${chapterData['lessons'].length} lessons',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              _buildProgressIndicator(progress: progress, colorScheme: cs),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            chapterData['title'],
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            chapterData['subtitle'],
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: cs.onSurface.withAlpha(190),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            chapterData['description'],
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: cs.onSurface.withAlpha(150),
            ),
          ),

          const SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {
                  context.go('${Routes.study}/$chapterId');
                },
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                ),
                child: Text(
                  progress >= 1.0
                      ? 'Review'
                      : progress > 0
                      ? 'Continue'
                      : 'Start',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator({
    required double progress,
    required ColorScheme colorScheme,
  }) {
    final displayProgress = progress.clamp(0.0, 1.0);
    final percentage = '${(displayProgress * 100).round()}%';

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            value: displayProgress,
            strokeWidth: 3,
            backgroundColor: colorScheme.surfaceContainerLowest,
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
          ),
        ),
        Text(
          percentage,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.normal,
            fontSize: 10,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
