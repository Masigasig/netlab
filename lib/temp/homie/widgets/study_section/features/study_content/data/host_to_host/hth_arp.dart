import '../../models/content_block.dart';
import 'package:netlab/core/constants/app_image.dart';

class HostToHostArpContent implements ModuleContent {
  @override
  String get moduleId => 'h2h_arp';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.header,
        title: 'Address Resolution Protocol (ARP)',
        content: '',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'To map IP addresses to MAC addresses, the host uses the Address Resolution Protocol (ARP).',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'An ARP Request is broadcast to all devices on the local network, asking which device owns a specific IP address.',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'The correct device responds with its MAC address in an ARP Reply. Both devices then store the mapping in their ARP caches for faster communication in the future.',
      ),
      ContentBlock(
        type: ContentBlockType.image,
        content: ContentImage.hostToHost2,
        title:
            'ARP maps IP addresses to MAC addresses through requests and replies',
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            'ARP is essential for discovering the physical MAC address associated with a given IP address.',
      ),
    ];
  }
}
