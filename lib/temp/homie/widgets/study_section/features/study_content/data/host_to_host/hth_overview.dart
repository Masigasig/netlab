import '../../models/content_block.dart';

class HostToHostOverviewContent implements ModuleContent {
  @override
  String get moduleId => 'h2h_overview';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.header,
        title: 'Host-to-Host Communication',
        content: '',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'A host is any device connected to a network that can send or receive data.',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'Each host has a Network Interface Card (NIC) with a unique MAC address for '
            'identification at the hardware level, and an IP address for logical identification across networks.',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'The subnet mask works with the IP address to determine whether another device is '
            'on the same local network or on a different one.',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'If the target is on the same subnet, the host communicates directly. '
            'If it is on a different subnet, communication must be passed through a router.',
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            'Hosts rely on both IP addresses (logical) and MAC addresses (physical) for communication.',
      ),
    ];
  }
}
