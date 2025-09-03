import '../../models/content_block.dart';

class NetworkIPContent implements ModuleContent {
  @override
  String get moduleId => 'nf_ip';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.header,
        title: 'The unique identifier of a device on a network',
        content: '',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'An IP address is like a phone number or a house address for your device. '
            'Every host (laptop, phone, smart TV, computer, server) needs one to communicate. '
            'Without an IP address, hosts cannot send or receive data.',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'Every data packet on the network has a Source IP and a Destination IP. '
            'This is how devices know where the data is coming from and where it should go.',
      ),
      ContentBlock(
        type: ContentBlockType.image,
        content: 'assets/images/ip_address_example.png',
        title: 'Each packet contains a Source IP and Destination IP',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'IP addresses are 32-bit numbers written as 4 octets (for example, 192.168.1.1). '
            'Each octet ranges from 0 to 255.',
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            'IP addresses can be assigned hierarchically using a process called subnetting.',
      ),
    ];
  }
}