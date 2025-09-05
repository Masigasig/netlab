import '../../models/content_block.dart';

class BridgeContent implements ModuleContent {
  @override
  String get moduleId => 'nd_bridge';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(type: ContentBlockType.header, title: 'Bridge', content: ''),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'A bridge is like a repeater, but with the added ability to filter traffic '
            'by reading the MAC addresses of the source and destination.',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'It is often used to interconnect two LANs that operate on the same protocol. '
            'Each port on a bridge is typically connected to a different segment, and the bridge learns which hosts are on which segment.',
      ),
      ContentBlock(
        type: ContentBlockType.image,
        content: 'assets/images/content_image/bridge_example.png',
        title: 'A bridge connects two network segments and filters traffic',
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            'Unlike hubs, bridges can filter traffic based on MAC addresses.',
      ),
    ];
  }
}
