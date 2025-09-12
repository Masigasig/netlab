import '../../models/content_block.dart';

class SwitchingIntroContent implements ModuleContent {
  @override
  String get moduleId => 'sr_intro_switching';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.header,
        title: 'Introduction to Switching',
        content: '',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'A switch is a device that moves (switches) data between devices inside the same network (LAN). '
            'Unlike a router, which connects different networks, a switch only works within one network. '
            'It uses MAC addresses (the hardware addresses of network cards) to figure out which device should receive the data.',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'Every device (host) has two key addresses: '
            'an IP Address at Layer 3 (Network Layer) for identifying devices across different networks, '
            'and a MAC Address at Layer 2 (Data Link Layer) for identifying devices inside the same network. '
            'Switches only care about the MAC Address. From the switch’s perspective, the IP Address is just data inside the packet.',
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            'In short: “Routers care about IP addresses”, while “Switches care about MAC addresses”.',
      ),
    ];
  }
}
