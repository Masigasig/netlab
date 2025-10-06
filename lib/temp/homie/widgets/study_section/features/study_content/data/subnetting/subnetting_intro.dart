import '../../models/content_block.dart';

class SubnettingIntroContent implements ModuleContent {
  @override
  String get moduleId => 'sub_intro';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.header,
        title: 'Introduction to Subnetting',
        content: '',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'Subnetting is the process of dividing one large IP network into smaller, more manageable segments called subnets. '
            'Each subnet acts as a separate portion of the larger network, allowing for better control, efficiency, and organization.',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'By subnetting, network administrators can assign IP addresses more efficiently, reduce unnecessary traffic, and improve overall performance. '
            'It also enhances security by isolating sections of a network, making management and troubleshooting easier.',
      ),
      ContentBlock(
        type: ContentBlockType.bulletList,
        content: [
          'Subnetting divides a large network into smaller logical networks.',
          'It improves performance and reduces broadcast traffic.',
          'It enhances network security and simplifies management.',
          'Routers use subnet information to determine efficient data paths.',
        ],
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            'Subnetting is a foundational concept in networking that ensures efficient IP address usage and structured data communication across networks.',
      ),
    ];
  }
}
