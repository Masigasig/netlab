import '../../models/content_block.dart';

class SubnettingAttributesContent implements ModuleContent {
  @override
  String get moduleId => 'sub_attributes';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.header,
        title: 'Subnet Attributes',
        content: '',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'Each subnet has specific attributes that define its size, range, and usable IP addresses. '
            'Understanding these attributes helps network administrators design and manage networks more efficiently.',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'These values tell us which IPs can be assigned to devices, which are reserved for the network itself, and which are used for broadcasting. '
            'Knowing how to identify and calculate these attributes is essential when dividing or configuring networks.',
      ),
      ContentBlock(
        type: ContentBlockType.bulletList,
        content: [
          'Number of IP Addresses – Total number of IP addresses within the subnet.',
          'CIDR Notation & Subnet Mask – Defines the subnet size using prefix length (e.g., /25) and dotted-decimal form (255.255.255.128).',
          'Network ID – The first address that identifies the subnet itself (not assignable to a host).',
          'Broadcast IP – The last address in the subnet, used to send data to all hosts in that subnet.',
          'First Host IP – The first usable IP address available for devices.',
          'Last Host IP – The last usable IP before the broadcast address.',
          'Next Network – The starting network ID of the following subnet.',
        ],
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            'Each subnet attribute plays a role in defining network structure. '
            'Understanding how to calculate them ensures accurate network planning and efficient IP allocation.',
      ),
    ];
  }
}
