import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../core/models/study_topic.dart';
import '../core/services/progress_service.dart';
import '../features/study_content/services/module_registry.dart';
import 'package:netlab/core/themes/app_theme.dart';
import 'package:netlab/temp/core/constants/app_text.dart';

class TopicCard extends StatefulWidget {
  final StudyTopic topic;
  final VoidCallback onTap;
  final List<String> orderedTopicIds;

  const TopicCard({
    super.key,
    required this.topic,
    required this.onTap,
    required this.orderedTopicIds,
  });

  @override
  State<TopicCard> createState() => _TopicCardState();
}

class _TopicCardState extends State<TopicCard> {
  double _progress = 0.0;
  int _totalChapters = 0;

  @override
  void initState() {
    super.initState();
    _setTotalChapters();
    _loadProgress();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadProgress();
  }

  void _setTotalChapters() {
    _totalChapters = ModuleRegistry.getLessonCount(widget.topic.id);
  }

  Future<void> _loadProgress() async {
    final completedChapters = await ProgressService.getCompletedChaptersByTopic(
      widget.topic.id,
    );

    if (mounted) {
      setState(() {
        _progress = _totalChapters > 0
            ? completedChapters.length / _totalChapters
            : 0.0;
      });
    }
  }

  @override
  void didUpdateWidget(TopicCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.topic.id != widget.topic.id ||
        !listEquals(oldWidget.orderedTopicIds, widget.orderedTopicIds)) {
      _setTotalChapters();
      _loadProgress();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppStyles.cardMargin,
      padding: AppStyles.cardPadding,
      decoration: AppStyles.surfaceCard(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lessons count + Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Lessons count chipbadge - now shows dynamic count
              AppStyles.chipBadge(
                context: context,
                text: '$_totalChapters lessons',
                icon: Icons.book_outlined,
              ),

              _buildProgressIndicator(),
            ],
          ),

          const SizedBox(height: 20),

          // Title
          Text(
            widget.topic.title,
            style: AppTextStyles.forSurface(
              AppTextStyles.headerMedium,
              context,
            ),
          ),

          const SizedBox(height: 8),

          // Subtitle
          Text(
            widget.topic.subtitle,
            style: AppTextStyles.withOpacity(
              AppTextStyles.forSurface(AppTextStyles.bodyMedium, context),
              0.7,
            ),
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            widget.topic.description,
            style: AppTextStyles.withOpacity(
              AppTextStyles.forSurface(AppTextStyles.bodySmall, context),
              0.5,
            ),
          ),

          const SizedBox(height: 20),

          // Metadata row
          Text(
            widget.topic.readTime,
            style: AppTextStyles.withOpacity(
              AppTextStyles.forSurface(AppTextStyles.subtitleSmall, context),
              0.5,
            ),
          ),

          const SizedBox(height: 24),

          // Start button (right aligned)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: widget.onTap,
                style: AppButtonStyles.opacityButton(context).copyWith(
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                ),
                child: Text(
                  _progress >= 1.0
                      ? 'Review'
                      : _progress > 0
                      ? 'Continue'
                      : 'Start',
                  style: AppTextStyles.label,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final cs = Theme.of(context).colorScheme;

    if (_progress >= 1.0) {
      // Completed badge
      return AppStyles.badge(
        context: context,
        text: 'Completed',
        type: BadgeType.secondary,
        icon: Icon(Icons.check, size: 16, color: cs.onSecondaryContainer),
      );
    } else if (_progress > 0) {
      // Progress indicator
      return Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              value: _progress,
              strokeWidth: 3,
              backgroundColor: cs.surfaceContainerLowest,
              valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
            ),
          ),
          Text(
            '${(_progress * 100).round()}%',
            style: AppTextStyles.forSurface(AppTextStyles.caption, context),
          ),
        ],
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            value: 0,
            strokeWidth: 3,
            backgroundColor: cs.surfaceContainerLowest,
            valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
          ),
        ),
        Text(
          '0%',
          style: AppTextStyles.forSurface(AppTextStyles.caption, context),
        ),
      ],
    );
  }
}
