import '../../models/content_block.dart';

class SwitchingMacTableContent implements ModuleContent {
  @override
  String get moduleId => 'sr_mac_table';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.header,
        title: 'MAC Address Table',
        content: '',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'Switches use and maintain a “MAC Address Table” to facilitate communication in the network. '
            'The MAC Address Table keeps track of which MAC address is connected to which switch port.',
      ),
      ContentBlock(
        type: ContentBlockType.table,
        content: [
          ['Port 3', '8A:00:AA:23:B3:4E', 'Host A'],
        ],
        additionalData: {
          'headers': ['Port', 'MAC Address', 'Device'],
        },
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'When a switch is first powered on, its MAC Address Table is empty. '
            'The switch learns MAC addresses dynamically as devices send data through it. '
            'Over time, the table is populated so the switch knows exactly which port to forward data to.',
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            'This process is called “MAC learning”. It allows switches to send frames only to the correct device instead of broadcasting everywhere.',
      ),
    ];
  }
}
