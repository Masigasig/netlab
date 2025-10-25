import 'package:netlab/temp/homie/widgets/study_section/features/study_content/models/content_block.dart';

class SettingUpSwitchesContent implements ModuleContent {
  @override
  String get moduleId => 'setting_up_switches';

  @override
  List<ContentBlock> getContent() {
    return [
      // ContentBlock(
      //   type: ContentBlockType.image,
      //   title: 'Switch configuration panel',
      //   content: 'assets/tutorials/setting_up_switches.png',
      // ),
      ContentBlock(
        type: ContentBlockType.numberedList,
        content: [
          'Open the switch configuration panel',
          'Configure VLANs and assign ports',
          'Set up port settings (speed, duplex, etc.)',
          'Configure spanning tree protocol',
          'Apply and save configuration',
        ],
      ),
      ContentBlock(
        type: ContentBlockType.definition,
        content: [
          {
            'term': 'VLAN (Virtual LAN)',
            'definition':
                'A logical network that groups devices together, regardless of their physical location, improving network security and performance.',
          },
          {
            'term': 'STP (Spanning Tree Protocol)',
            'definition':
                'A protocol that prevents network loops in networks with redundant paths while maintaining backup paths for failover.',
          },
        ],
      ),
      ContentBlock(
        type: ContentBlockType.warning,
        content:
            'Incorrect VLAN configuration can isolate devices and prevent communication. Double-check your VLAN assignments and trunk port settings.',
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            'Pro Tip: Use VLAN tagging on trunk ports when connecting switches to ensure proper VLAN traffic flow between switches.',
      ),
    ];
  }
}
