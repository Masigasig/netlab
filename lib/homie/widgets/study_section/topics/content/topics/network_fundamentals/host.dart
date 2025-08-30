import '../../models/content_block.dart';

class HostContent implements ModuleContent {
  @override
  String get moduleId => 'nf_host';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.header,
        title: 'Host',
        content: '',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'A host is a computer or other device that connects to other hosts on a network. '
            'Clients and servers that deliver or receive data, services, and applications are referred to as hosts in the network. '
            'For example: Computers, Phones, Printers, Servers, etc.',
      ),
      ContentBlock(
        type: ContentBlockType.bulletList,
        content: [
          'Any device that sends or receives traffic over a network is considered a host.',
          'Hosts can be one of two categories: Clients or Servers.',
          'Clients initiate requests, Servers respond to requests.',
          'Roles can be relative depending on the specific communication.',
        ],
      ),
      ContentBlock(
        type: ContentBlockType.image,
        content: 'assets/images/content_image/host_example.png',
        title: 'Examples of hosts',
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            'Remember: every device on the network that can send or receive data is a host.',
      ),
    ];
  }
}
