import '../../models/content_block.dart';

class RouterContent implements ModuleContent {
  @override
  String get moduleId => 'nd_router';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.header,
        title: 'Router',
        content: '',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'A router is a device like a switch, but it routes data packets based on their IP addresses. '
            'It connects different networks together and decides the best path for data to travel.',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'Routers normally connect LANs and WANs and use a dynamically updating routing table '
            'to make forwarding decisions. Routers also create the hierarchy in networks and power the entire internet.',
      ),
      ContentBlock(
        type: ContentBlockType.bulletList,
        content: [
          'Gateway – each host’s way out of its local network.',
        ],
      ),
      ContentBlock(
        type: ContentBlockType.image,
        content: 'assets/images/content_image/router_example.png',
        title: 'Routers connect different networks using IP addresses',
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content: 'Routers connect networks and choose the best path for data.',
      ),
    ];
  }
}
