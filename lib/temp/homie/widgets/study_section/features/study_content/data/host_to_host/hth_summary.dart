import '../../models/content_block.dart';

class HostToHostSummaryContent implements ModuleContent {
  @override
  String get moduleId => 'h2h_summary';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.header,
        title: 'Key Takeaways',
        content: '',
      ),
      ContentBlock(
        type: ContentBlockType.bulletList,
        content: [
          'ARP maps IP addresses to MAC addresses within a local network.',
          'It operates at the link layer, enabling communication between devices on the same subnet.',
          'Understanding ARP tables helps troubleshoot IP conflicts and connectivity issues.',
          'Gratuitous ARP helps detect IP duplication and announce interface changes.',
        ],
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            'Efficient communication relies on accurate IP-to-MAC mapping and ARP cache management.',
      ),
    ];
  }
}
