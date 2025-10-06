import '../../models/content_block.dart';

class SubnettingPracticeContent implements ModuleContent {
  @override
  String get moduleId => 'sub_practice';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.header,
        title: 'Subnetting Practice',
        content: '',
      ),

      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'Subnetting requires understanding how to divide a network address space into smaller segments. '
            'This practice section will help reinforce the steps used when performing subnet calculations.',
      ),

      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'Each exercise focuses on identifying subnet masks, network IDs, host ranges, and broadcast addresses. '
            'Try to perform the calculations manually before verifying your answers using network tools or a calculator.',
      ),

      ContentBlock(
        type: ContentBlockType.bulletList,
        content: [
          'Determine the subnet mask and CIDR prefix for a given network requirement.',
          'Calculate the number of possible subnets and hosts per subnet.',
          'Identify the network ID, first host, last host, and broadcast address.',
          'Verify the results by checking that all ranges do not overlap.',
        ],
      ),

      ContentBlock(
        type: ContentBlockType.note,
        content:
            'Consistent practice is essential to mastering subnetting. '
            'Focus on understanding the binary representation of subnet masks and how each bit affects the total number of hosts and networks.',
      ),
    ];
  }
}
