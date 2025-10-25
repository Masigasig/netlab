import 'package:netlab/temp/homie/widgets/study_section/features/study_content/models/content_block.dart';

class ConfiguringRoutersContent implements ModuleContent {
  @override
  String get moduleId => 'configuring_routers';

  @override
  List<ContentBlock> getContent() {
    return [
      // ContentBlock(
      //   type: ContentBlockType.image,
      //   title: 'Router configuration interface',
      //   content: 'assets/tutorials/configuring_routers.png',
      // ),
      ContentBlock(
        type: ContentBlockType.numberedList,
        content: [
          'Double-click a router to open its configuration panel',
          'Configure IP addresses and subnet masks for each interface',
          'Set up routing protocols (OSPF, RIP, etc.)',
          'Save the configuration to apply changes',
        ],
      ),
      ContentBlock(
        type: ContentBlockType.definition,
        content: [
          {
            'term': 'OSPF (Open Shortest Path First)',
            'definition':
                'A link-state routing protocol that finds the best path for packets using the Shortest Path First algorithm.',
          },
          {
            'term': 'RIP (Routing Information Protocol)',
            'definition':
                'A distance-vector routing protocol that uses hop count as its routing metric.',
          },
        ],
      ),
      ContentBlock(
        type: ContentBlockType.warning,
        content:
            'Make sure to configure unique IP addresses for each interface and ensure proper subnet configuration to avoid address conflicts.',
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            'Pro Tip: Use the "Show Running Config" option to view and verify all your router settings in one place.',
      ),
    ];
  }
}
