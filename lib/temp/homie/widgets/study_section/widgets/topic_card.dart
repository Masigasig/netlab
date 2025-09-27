import 'package:flutter/material.dart';
import '../models/study_topic.dart';
import '../services/progress_service.dart';
import 'package:netlab/core/components/app_theme.dart';

class TopicCard extends StatefulWidget {
  final StudyTopic topic;
  final VoidCallback onTap;

  const TopicCard({super.key, required this.topic, required this.onTap});

  @override
  State<TopicCard> createState() => _TopicCardState();
}

class _TopicCardState extends State<TopicCard> {
  double _progress = 0.0;
  int _totalChapters = 0; // This will be set based on topic

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
    _totalChapters = widget.topic.lessonCount;
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
    if (oldWidget.topic.id != widget.topic.id) {
      _setTotalChapters();
      _loadProgress();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

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
              // Lessons count chipbadge
              AppStyles.chipBadge(
                context: context,
                text: '${widget.topic.lessonCount} lessons',
                icon: Icons.book_outlined,
              ),

              _buildProgressIndicator(),
            ],
          ),

          const SizedBox(height: 20),

          // Title
          Text(
            widget.topic.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),

          const SizedBox(height: 8),

          // Subtitle
          Text(
            widget.topic.subtitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: cs.onSurface.withAlpha(179),
            ),
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            widget.topic.description,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: cs.onSurface.withAlpha(128),
            ),
          ),

          const SizedBox(height: 20),

          // Metadata row
          Text(
            widget.topic.readTime,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: cs.onSurface.withAlpha(128),
            ),
          ),

          const SizedBox(height: 24),

          // Start button (right aligned)
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
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
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
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
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
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
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }
}
