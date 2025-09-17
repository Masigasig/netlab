import 'package:flutter/material.dart';
import '../models/study_topic.dart';

class TopicCard extends StatefulWidget {
  final StudyTopic topic;
  final VoidCallback onTap;

  const TopicCard({super.key, required this.topic, required this.onTap});

  @override
  State<TopicCard> createState() => _TopicCardState();
}

class _TopicCardState extends State<TopicCard> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.fromLTRB(32, 0, 32, 24),
      elevation: 0,
      color: cs.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cs.outlineVariant, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lessons count + Progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: cs.outlineVariant, width: 1),
                    borderRadius: BorderRadius.circular(20),
                    color: cs.surfaceContainerLow,
                  ),
                  child: Text(
                    '${widget.topic.lessonCount} lessons',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ),

                // Progress / Completion
                if (widget.topic.isCompleted)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: cs.secondaryContainer,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        // ignore: deprecated_member_use
                        color: cs.secondaryContainer.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.check,
                      size: 16,
                      color: cs.onSecondaryContainer,
                    ),
                  )
                else if (widget.topic.progress > 0)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          value: widget.topic.progress / 100,
                          strokeWidth: 3,
                          backgroundColor: cs.surfaceContainerLowest,
                          valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                        ),
                      ),
                      Text(
                        '${widget.topic.progress.round()}%',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface,
                        ),
                      ),
                    ],
                  ),
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
                color: cs.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              widget.topic.description,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                // ignore: deprecated_member_use
                color: cs.onSurface.withOpacity(0.7),
              ),
            ),

            const SizedBox(height: 20),

            // Metadata row
            Text(
              widget.topic.readTime,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: cs.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // Start button (right aligned)
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: widget.onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  widget.topic.isCompleted
                      ? 'Review'
                      : widget.topic.progress > 0
                      ? 'Continue'
                      : 'Start',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
