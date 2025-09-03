import '../../models/content_block.dart';

class SwitchingFrameTypesContent implements ModuleContent {
  @override
  String get moduleId => 'sr_frame_types';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.header,
        title: 'Frame Types',
        content: '',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            '  A switch sends the frame to all ports if it does not know where the destination MAC Address is. '
            'That frame is called a **Unicast Frame** when it is meant for one device.',
      ),
      ContentBlock(
        type: ContentBlockType.definition,
        content: [
          {
            'term': 'Unicast Frame',
            'definition':
                '  One-to-one communication. Flooding happens only until the switch learns where the device is. '
                'Once the destination MAC is known (in the MAC table), the switch forwards directly to that port.'
          },
          {
            'term': 'Broadcast Frame',
            'definition':
                '  One-to-all communication. The switch always floods the frame to all ports, regardless of its MAC Address Table.'
          },
        ],
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            '  When a host sends an “ARP Request”, it uses a Broadcast Frame. '
            'The destination MAC address is set to all F’s (FF:FF:FF:FF:FF:FF), a reserved address meaning the frame must be delivered to every host in the local network.',
      ),
    ];
  }
}