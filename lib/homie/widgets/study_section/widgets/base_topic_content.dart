import 'package:flutter/material.dart';
import 'package:netlab/core/constants/app_colors.dart';
import '../models/study_topic.dart';
import '../models/content_module.dart';
import 'components/topic_header.dart';
import 'components/sidebar_module_list.dart';
import 'components/welcome_content_view.dart';
import 'components/module_content_view.dart';

abstract class BaseTopicContent extends StatefulWidget {
  final StudyTopic topic;

  const BaseTopicContent({
    super.key,
    required this.topic,
  });

  List<ContentModule> getContentModules();
  
  // Virtual method that can be overridden by subclasses
  void onModuleTap(BuildContext context, ContentModule module) {
    // Default behavior - show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening: ${module.title}'),
        backgroundColor: Colors.white.withOpacity(0.2),
      ),
    );
  }

  @override
  State<BaseTopicContent> createState() => _BaseTopicContentState();
}

class _BaseTopicContentState extends State<BaseTopicContent> {
  int? selectedModuleIndex;

  List<ContentModule> getContentModules() => widget.getContentModules();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header Bar
            TopicHeader(
              topic: widget.topic,
              onBackPressed: () => Navigator.pop(context),
            ),
            
            // Main Content Area with Sidebar Layout
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sidebar
                  SidebarModuleList(
                    modules: getContentModules(),
                    selectedModuleIndex: selectedModuleIndex,
                    topic: widget.topic,
                    onModuleTap: _onSidebarModuleTap,
                  ),
                  
                  // Main Content Area
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      child: selectedModuleIndex != null 
                          ? ModuleContentView(
                              module: getContentModules()[selectedModuleIndex!],
                              topic: widget.topic,
                            )
                          : WelcomeContentView(topic: widget.topic),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSidebarModuleTap(int index, ContentModule module) {
    setState(() {
      selectedModuleIndex = index;
    });
    widget.onModuleTap(context, module);
  }
}