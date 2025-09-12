import '../../models/content_block.dart';

class NetworkInternetContent implements ModuleContent {
  @override
  String get moduleId => 'nf_internet';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.header,
        title: 'A global system of interconnected networks',
        content: '',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'The Internet is a very large group of interconnected networks that allows devices all over the world to communicate and share information.',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'For example, I can use the internet to access school resources without connecting directly to the student network.',
      ),
      ContentBlock(
        type: ContentBlockType.image,
        content: 'assets/images/internet_network.png',
        title: 'The Internet connects multiple networks together',
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            'Think of the Internet as a “network of networks” – it links together millions of private, public, academic, business, and government networks.',
      ),
    ];
  }
}
