import '../../models/content_block.dart';

class SubnettingExampleContent implements ModuleContent {
  @override
  String get moduleId => 'sub_example';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.header,
        title: 'Subnetting Example',
        content: '',
      ),

      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'To understand how subnetting works, let us go through an example using the network 142.2.0.0/25. '
            'The goal is to divide this network into four smaller subnets with at least twenty usable IP addresses each.',
      ),

      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'First, identify the subnet mask for the given CIDR. A /25 network has a subnet mask of 255.255.255.128. '
            'In binary form, this is 11111111.11111111.11111111.10000000. '
            'Since the remaining bits can still be divided, we can create additional subnets.',
      ),

      ContentBlock(
        type: ContentBlockType.bulletList,
        content: [
          'Convert the subnet mask to binary to identify available host bits.',
          'Determine the required number of bits to create at least four subnets.',
          'Calculate the new subnet mask by borrowing bits from the host portion.',
          'List all subnet ranges using the calculated increment value.',
        ],
      ),

      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'After calculation, each subnet has a group size of 32 addresses, which provides 30 usable host IPs. '
            'The resulting subnets are as follows:',
      ),

      ContentBlock(
        type: ContentBlockType.table,
        content: [
          ['Subnet', 'Range'],
          ['First Subnet', '142.2.0.0 – 142.2.0.31'],
          ['Second Subnet', '142.2.0.32 – 142.2.0.63'],
          ['Third Subnet', '142.2.0.64 – 142.2.0.95'],
          ['Fourth Subnet', '142.2.0.96 – 142.2.0.127'],
        ],
        additionalData: {
          'headers': ['Subnet', 'Range'],
        },
      ),

      ContentBlock(
        type: ContentBlockType.note,
        content:
            'Subnetting involves converting CIDR to a subnet mask, calculating increments, and determining address ranges. '
            'Always verify that the number of usable IPs meets the network requirements before finalizing the design.',
      ),
    ];
  }
}
