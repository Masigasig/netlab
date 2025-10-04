import '../../models/content_block.dart';
import 'package:netlab/core/constants/app_image.dart';

class HostToHostPacketFlowContent implements ModuleContent {
  @override
  String get moduleId => 'h2h_packet_flow';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.header,
        title: 'Packet Transmission and Reception',
        content: '',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'Once the MAC address is known, the host completes the packet by adding both Layer 3 (IP) and Layer 2 (MAC) headers around the data.',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'When the packet arrives at the destination, the receiving host checks the Layer 2 header first, discards it after verification, then checks the Layer 3 header and discards it as well.',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'The remaining payload is then delivered to the appropriate application for processing.',
      ),
      ContentBlock(
        type: ContentBlockType.image,
        content: ContentImage.hostToHost3,
        title:
            'Packets are encapsulated and decapsulated across network layers',
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            'Each network layer adds or removes its own header information to ensure proper delivery and interpretation of data.',
      ),
    ];
  }
}
