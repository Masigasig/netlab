import '../../models/content_block.dart';

class Sample implements ModuleContent {
  @override
  String get moduleId => 'nf_tcpip';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.header,
        title: 'What is a Computer Network?',
        content: 'Understanding the basics of computer networking',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content: 'A computer network is a group of computers and other devices that are connected together to share resources and communicate with each other.',
      ),
      ContentBlock(
        type: ContentBlockType.bulletList,
        content: [
          'Share resources like files and printers',
          'Enable communication between users',
          'Allow centralized data storage',
          'Provide access to the internet',
        ],
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content: 'Networks can range from small home networks to large enterprise networks that span globally.',
      ),
      ContentBlock(
        type: ContentBlockType.divider,
        content: '',
      ),
      ContentBlock(
        type: ContentBlockType.header,
        title: 'Types of Networks',
        content: 'Different categories of networks based on size and scope',
      ),
      ContentBlock(
        type: ContentBlockType.image,
        content: 'assets/images/network_types.png',
        title: 'Different types of networks and their scope',
      ),
      ContentBlock(
        type: ContentBlockType.definition,
        content: [
          {
            'term': 'LAN (Local Area Network)',
            'definition': 'Connects devices in a limited area like home, school, or office building.'
          },
          {
            'term': 'WAN (Wide Area Network)',
            'definition': 'Connects networks over large geographical distances.'
          },
          {
            'term': 'MAN (Metropolitan Area Network)',
            'definition': 'Covers a larger area than LAN but smaller than WAN, typically a city.'
          },
        ],
      ),
    ];
  }
}
