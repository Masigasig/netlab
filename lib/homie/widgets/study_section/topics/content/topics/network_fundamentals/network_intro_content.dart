import '../../models/content_block.dart';

class NetworkIntroContent implements ModuleContent {
  @override
  String get moduleId => 'nf_intro';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.header,
        title: 'Understanding the fundamentals of computer networking',
        content: '',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'Computer Network is a system that connects different devices like computers, servers, printers, so they can share resources and exchange information. '
            'This makes it possible to do things like sending emails, sharing files, or browse the internet.',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'So basically networking started with one computer wanting to share data with another. '
            'It can be simple as two computers connected with a cable.',
      ),
      ContentBlock(
        type: ContentBlockType.image,
        content: 'assets/images/content_image/sample.gif',
        title: 'Simple network: Two computers connected with a cable',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'And it is possible to connect more devices and link multiple networks together with switches, routers, and other devices.',
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            'At its core, networking is about “sharring and communication”. '
            'What began as two computers exchanging data has now scaled into the global Internet that connects billions of devices.',
      ),
    ];
  }
}
