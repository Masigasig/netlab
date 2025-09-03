import 'package:flutter/material.dart';
import '../models/study_topic.dart';
import 'package:netlab/core/constants/app_text.dart';

class TopicCard extends StatelessWidget {
  final StudyTopic topic;
  final VoidCallback onTap;

  const TopicCard({
    super.key,
    required this.topic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              topic.cardColor,
              topic.cardColor.withOpacity(0.8),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: topic.cardColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    child: Icon(
                      topic.icon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  
                  const Spacer(),

                  Text(
                    topic.title,
                    style: AppTextStyles.headerSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 6),
                  
                  Text(
                    topic.description,
                    style: AppTextStyles.secondaryCustom(
                      fontSize: 12,
                      color: const Color(0xCCFFFFFF),
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}