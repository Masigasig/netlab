import '../../models/content_block.dart';

class RoutingTableContent implements ModuleContent {
  @override
  String get moduleId => 'sr_routing_table';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.header,
        title: 'Routing Table',
        content: '',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            '  For a router to know where to send packets, it maintains an internal reference called the routing table. '
            'You can think of the routing table as the router’s personal map of all the networks it is aware of. '
            'Each entry in the routing table is called a route, and each route contains instructions that tell the router which network exists and which interface should be used to reach that network.',
      ),
      ContentBlock(
        type: ContentBlockType.image,
        content: 'assets/images/content_image/sample.gi',
        title: 'this is sample description',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            '  In real-world devices, router interfaces often have technical names such as “FastEthernet0/1 (fa0/1)” or “GigabitEthernet0/2 (gig0/2)” rather than simple labels like “left” or “right.” '
            'But the idea is the same: each entry in the routing table maps a destination network to the correct interface on the router.',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            '  Because the routing table serves as the router’s guide for forwarding packets, keeping it accurate and up to date is critical. '
            'If a route is missing, the router will not know how to reach the destination network, and packets will be dropped. '
            'In this way, the routing table is central to the routing process, determining whether data is successfully delivered or lost.',
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            'Think of the routing table as the router’s “cheat sheet.” It quickly tells the router which path to take whenever it receives a packet.',
      ),
    ];
  }
}