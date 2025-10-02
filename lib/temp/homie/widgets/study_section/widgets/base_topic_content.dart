import 'package:flutter/material.dart';
import '../core/models/study_topic.dart';
import '../core/models/content_module.dart';
import '../features/topic/widgets/topic_header.dart';
import '../features/sidebar/widgets/sidebar_module_list.dart';
import '../features/topic/widgets/welcome_content_view.dart';
import '../features/modules/widgets/module_content_view.dart';

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
                              totalModules: getContentModules().length,
                              currentModuleIndex: selectedModuleIndex!,
                              onNextModule: _moveToNextModule,
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

  void _moveToNextModule() {
    final modules = getContentModules();
    if (selectedModuleIndex != null &&
        selectedModuleIndex! < modules.length - 1) {
      setState(() {
        selectedModuleIndex = selectedModuleIndex! + 1;
      });
    }
  }
}
