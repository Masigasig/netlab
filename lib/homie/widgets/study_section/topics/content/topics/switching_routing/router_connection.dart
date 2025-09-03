import '../../models/content_block.dart';

class RoutingNetworkConnectionsContent implements ModuleContent {
  @override
  String get moduleId => 'rt_network_connections';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.header,
        title: 'Router Network Connections',
        content: '',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            '  A router is designed to connect two or more separate networks together. '
            'To do this, it must have a unique identity on each network it participates in. '
            'Just like a host, a router uses both an IP address and a MAC address to communicate.',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            '  However, because a router acts as a bridge between different networks, it cannot share the same address across all of them. '
            'Instead, the router must have one IP address and one MAC address for every network interface it is connected to.',
      ),
      ContentBlock(
        type: ContentBlockType.image,
        content: 'assets/images/content_image/sample.gi',
        title: 'this is sample description',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            '  This is why a router is often described as having “multiple interfaces” or “multiple faces” — one for each network it is attached to. '
            'Each interface serves as the router’s unique identity within that specific network, allowing it to transfer data between otherwise separate systems.',
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            '  Each router interface must have its own IP and MAC address. '
            'This is what allows the router to act as a link between different networks.',
      ),
    ];
  }
}