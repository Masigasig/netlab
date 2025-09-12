import '../../models/content_block.dart';

class RoutingIntroContent implements ModuleContent {
  @override
  String get moduleId => 'sr_intro';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.header,
        title: 'Introduction to Routing',
        content: '',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            '  Routing is the process of transferring data from one network to another. '
            'It ensures that information can travel between devices even if they are on completely different networks.',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            '  A “Router” is a device whose primary purpose is to perform routing. '
            'It examines packet IP addresses and decides the best path for forwarding data toward its destination.',
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            '  Unlike switches that operate within a single network (using MAC addresses), routers operate between networks (using IP addresses).',
      ),
    ];
  }
}
