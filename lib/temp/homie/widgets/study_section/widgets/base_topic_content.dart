import 'package:flutter/material.dart';
import '../models/study_topic.dart';
import '../models/content_module.dart';
import 'components/topic_header.dart';
import 'components/sidebar_module_list.dart';
import 'components/welcome_content_view.dart';
import 'components/module_content_view.dart';

// ignore_for_file: deprecated_member_use
abstract class BaseTopicContent extends StatefulWidget {
  final StudyTopic topic;

  const BaseTopicContent({super.key, required this.topic});

  List<ContentModule> getContentModules();

  void onModuleTap(BuildContext context, ContentModule module) {}

  @override
  State<BaseTopicContent> createState() => _BaseTopicContentState();
}

class _BaseTopicContentState extends State<BaseTopicContent> {
  int? selectedModuleIndex;

  List<ContentModule> getContentModules() => widget.getContentModules();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            TopicHeader(
              topic: widget.topic,
              onBackPressed: () => Navigator.pop(context),
            ),

            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SidebarModuleList(
                    modules: getContentModules(),
                    selectedModuleIndex: selectedModuleIndex,
                    topic: widget.topic,
                    onModuleTap: _onSidebarModuleTap,
                  ),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      color: cs.surface,
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
