import '../../models/content_block.dart';

class NetworkOsiContent implements ModuleContent {
  @override
  String get moduleId => 'nf_osi';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.header,
        title: 'The OSI Model',
        content: 'Understanding the 7 layers of network communication',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content: 'The OSI (Open Systems Interconnection) model is a conceptual framework used to understand network interactions in seven different layers.',
      ),
      ContentBlock(
        type: ContentBlockType.image,
        content: 'assets/images/osi_model.png',
        title: 'The 7 layers of the OSI model',
      ),
      ContentBlock(
        type: ContentBlockType.numberedList,
        content: [
          'Physical Layer (Layer 1): Hardware transmission',
          'Data Link Layer (Layer 2): Physical addressing',
          'Network Layer (Layer 3): Path determination and logical addressing',
          'Transport Layer (Layer 4): End-to-end connections and reliability',
          'Session Layer (Layer 5): Interhost communication',
          'Presentation Layer (Layer 6): Data representation and encryption',
          'Application Layer (Layer 7): End-user services',
        ],
      ),
      ContentBlock(
        type: ContentBlockType.divider,
        content: '',
      ),
      ContentBlock(
        type: ContentBlockType.header,
        title: 'Layer Details',
        content: 'Detailed explanation of each layer',
      ),
      ContentBlock(
        type: ContentBlockType.table,
        content: [
          ['Physical', 'Cables, switches, network interface cards'],
          ['Data Link', 'MAC addresses, switches'],
          ['Network', 'IP addresses, routers'],
          ['Transport', 'TCP/UDP, ports'],
          ['Session', 'Session establishment, management'],
          ['Presentation', 'Data formatting, encryption'],
          ['Application', 'HTTP, FTP, SMTP'],
        ],
        additionalData: {
          'headers': ['Layer', 'Key Components'],
        },
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content: 'Remember: All People Seem To Need Data Processing - a mnemonic to remember the layers from Layer 1 to 7!',
      ),
      ContentBlock(
        type: ContentBlockType.warning,
        content: 'The OSI model is theoretical. In practice, many protocols don\'t strictly follow these layer boundaries.',
      ),
    ];
  }
}
