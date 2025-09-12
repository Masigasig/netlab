import '../../models/content_block.dart';

class HubContent implements ModuleContent {
  @override
  String get moduleId => 'nd_hub';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(type: ContentBlockType.header, title: 'Hub', content: ''),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'A hub is a multi-port repeater. A hub connects multiple wires coming from different branches. '
            'When one computer sends data, the hub copies that data and sends it out to all other ports.',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'Hubs cannot filter data, so every connected device receives the same data. '
            'Only the intended device actually uses it — the others just ignore it.',
      ),
      ContentBlock(
        type: ContentBlockType.image,
        content: 'assets/images/content_image/hub_example.png',
        title: 'A hub broadcasts data to all connected devices',
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content: 'Hubs share data with all ports — they cannot filter traffic.',
      ),
    ];
  }
}
