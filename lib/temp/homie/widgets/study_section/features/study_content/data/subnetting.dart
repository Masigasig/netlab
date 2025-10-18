import 'package:flutter/material.dart';
import 'package:netlab/temp/homie/widgets/study_section/widgets/base_topic_content.dart';
import 'package:netlab/temp/homie/widgets/study_section/core/models/content_module.dart';

class SubnettingContent extends BaseTopicContent {
  const SubnettingContent({
    super.key,
    required super.topic,
    super.initialModuleId,
  });

  @override
  List<ContentModule> getContentModules() {
    return [
      ContentModule(
        id: 'sub_intro',
        title: 'Introduction to Subnetting',
        description:
            'Understand what subnetting is and why it is used to divide large networks into smaller, manageable ones.',
        icon: Icons.account_tree,
        duration: 15,
        type: ContentType.reading,
      ),
      ContentModule(
        id: 'sub_attributes',
        title: 'Subnet Attributes',
        description:
            'Learn the seven key subnet attributes: Number of IPs, CIDR/Mask, Network ID, Broadcast IP, First Host, Last Host, and Next Network.',
        icon: Icons.list_alt,
        duration: 20,
        type: ContentType.reading,
      ),
      ContentModule(
        id: 'sub_cidr',
        title: 'CIDR and Subnet Mask',
        description:
            'Explore how CIDR notation relates to subnet masks and how binary conversion defines network size.',
        icon: Icons.calculate,
        duration: 25,
        type: ContentType.video,
      ),
      ContentModule(
        id: 'sub_example',
        title: 'Subnetting Example',
        description:
            'Step-by-step subnetting example using 142.2.0.0/25 — see how to calculate increments, group sizes, and subnet ranges.',
        icon: Icons.school,
        duration: 35,
        type: ContentType.lab,
      ),
      ContentModule(
        id: 'sub_practice',
        title: 'Subnetting Practice',
        description:
            'Interactive practice exercises for calculating subnets, masks, and usable host ranges.',
        icon: Icons.memory,
        duration: 40,
        type: ContentType.interactive,
      ),
      ContentModule(
        id: 'sub_quiz',
        title: 'Subnetting Quiz',
        description:
            'Test your understanding of subnetting concepts with real-world scenario-based questions.',
        icon: Icons.quiz,
        duration: 10,
        type: ContentType.quiz,
      ),
    ];
  }
}
