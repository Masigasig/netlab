import 'package:netlab/temp/homie/widgets/study_section/features/study_content/models/content_block.dart';

class MonitoringTrafficContent implements ModuleContent {
  @override
  String get moduleId => 'monitoring_traffic';

  @override
  List<ContentBlock> getContent() {
    return [
      // ContentBlock(
      //   type: ContentBlockType.image,
      //   title: 'Traffic monitoring tools',
      //   content: 'assets/tutorials/monitoring_traffic.png',
      // ),
      ContentBlock(
        type: ContentBlockType.numberedList,
        content: [
          'Open the packet tracer tool from the simulation panel',
          'Select packets in the network to analyze their details',
          'View packet headers, content, and routing information',
          'Track packet paths through the network',
          'Use filters to focus on specific types of traffic',
        ],
      ),
      ContentBlock(
        type: ContentBlockType.definition,
        content: [
          {
            'term': 'Packet Analysis',
            'definition':
                'The process of examining network packets to understand their content, behavior, and flow through the network.',
          },
          {
            'term': 'Packet Path',
            'definition':
                'The route a packet takes through the network, including all intermediate devices and interfaces.',
          },
        ],
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            'Pro Tip: Watch how packets are routed through different paths when network conditions change.',
      ),
      ContentBlock(
        type: ContentBlockType.warning,
        content:
            'Keep in mind that complex networks may have multiple possible paths for packets. The actual path taken depends on routing protocols and network conditions.',
      ),
    ];
  }
}
