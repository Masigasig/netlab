import 'package:flutter/material.dart';
import 'package:netlab/core/constants/app_colors.dart';
import '../models/study_topic.dart';
import '../models/content_module.dart';
import 'content_module_item.dart';

abstract class BaseTopicContent extends StatelessWidget {
  final StudyTopic topic;

  const BaseTopicContent({
    super.key,
    required this.topic,
  });

  List<ContentModule> getContentModules();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    topic.cardColor,
                    topic.cardColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    topic.icon,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topic.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          topic.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Content Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Course Content',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${getContentModules().length} modules',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Content modules
                    Expanded(
                      child: ListView.builder(
                        itemCount: getContentModules().length,
                        itemBuilder: (context, index) {
                          return ContentModuleItem(
                            module: getContentModules()[index],
                            onTap: () => onModuleTap(context, getContentModules()[index]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onModuleTap(BuildContext context, ContentModule module) {
    // Override this method in subclasses for custom behavior
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening: ${module.title}'),
        backgroundColor: Colors.white.withOpacity(0.2),
      ),
    );
  }
}