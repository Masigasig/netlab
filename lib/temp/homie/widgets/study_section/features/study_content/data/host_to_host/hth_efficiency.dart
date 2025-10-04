import '../../models/content_block.dart';
import 'package:netlab/core/constants/app_image.dart';

class HostToHostEfficiencyContent implements ModuleContent {
  @override
  String get moduleId => 'h2h_efficiency';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.header,
        title: 'Subsequent Communication',
        content: '',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'Subsequent communication is faster because the hosts already have each other’s IP-to-MAC mappings in their ARP caches, '
            'eliminating the need for another ARP Request until the cache entries expire.',
      ),
      ContentBlock(
        type: ContentBlockType.image,
        content: ContentImage.hostToHost4,
        title: 'Cached ARP entries improve communication efficiency',
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            'Once ARP caches are populated, devices can communicate directly without repeating the ARP request process.',
      ),
    ];
  }
}
