import '../../models/content_block.dart';

class SubnettingCidrContent implements ModuleContent {
  @override
  String get moduleId => 'sub_cidr';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.header,
        title: 'CIDR and Subnet Mask',
        content: '',
      ),

      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'CIDR, or Classless Inter-Domain Routing, is a way of representing an IP address and its network mask. '
            'It defines how many bits in the IP address are used for the network portion and how many are used for hosts.',
      ),

      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'A subnet mask works together with CIDR to determine which part of an IP address identifies the network and which part identifies the host. '
            'The subnet mask is written in dotted-decimal form, while CIDR uses a prefix length notation (for example, /25).',
      ),

      ContentBlock(
        type: ContentBlockType.bulletList,
        content: [
          'CIDR notation (e.g., 192.168.1.0/24) shows the number of bits used for the network portion.',
          'Subnet mask (e.g., 255.255.255.0) is the dotted-decimal equivalent of the CIDR prefix.',
          'The more bits used for the network, the fewer IP addresses available for hosts.',
          'Binary representation helps visualize which bits belong to the network and which to the host.',
        ],
      ),

      ContentBlock(
        type: ContentBlockType.note,
        content:
            'CIDR and subnet masks are essential for defining network boundaries. '
            'They control how devices recognize whether another IP address belongs to the same network or a different one.',
      ),
    ];
  }
}
