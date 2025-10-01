import 'package:flutter/material.dart';
import 'package:netlab/temp/homie/widgets/study_section/widgets/base_topic_content.dart';
import 'package:netlab/temp/homie/widgets/study_section/core/models/content_module.dart';

class ArpContent extends BaseTopicContent {
  const ArpContent({
    super.key,
    required super.topic,
  });

  @override
  List<ContentModule> getContentModules() {
    return [
      ContentModule(
        id: 'arp_intro',
        title: 'Introduction to ARP',
        description: 'Understanding the Address Resolution Protocol',
        icon: Icons.swap_horiz,
        type: ContentType.reading,
        duration: 3,
      ),
      ContentModule(
        id: 'arp_tables',
        title: 'ARP Tables',
        description: 'Working with ARP tables and address mapping',
        icon: Icons.table_chart,
        type: ContentType.reading,
        duration: 2,
      ),
    ];
  }
}