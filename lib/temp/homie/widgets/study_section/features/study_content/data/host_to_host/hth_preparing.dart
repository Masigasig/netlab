import '../../models/content_block.dart';
import 'package:netlab/core/constants/app_image.dart';

class HostToHostPreparingContent implements ModuleContent {
  @override
  String get moduleId => 'h2h_preparing';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.header,
        title: 'Preparing to Send Data',
        content: '',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'When preparing to send data, the host first constructs an IP header (Layer 3), '
            'which contains the source and destination IP addresses.',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'This ensures end-to-end delivery. However, because IP addresses cannot directly interact '
            'with the physical network, the host also needs a MAC address for delivery at the data link layer (Layer 2).',
      ),
      ContentBlock(
        type: ContentBlockType.image,
        content: ContentImage.hostToHost1,
        title: 'IP and MAC addresses work together to deliver data',
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            'IP handles logical addressing (Layer 3), while MAC handles physical delivery (Layer 2).',
      ),
    ];
  }
}
