import 'models/content_block.dart';
import 'topics/network_fundamentals/network_intro_content.dart';
//import 'topics/network_fundamentals/network_osi_content.dart';
import 'topics/network_fundamentals/network_internet.dart';
import 'topics/network_fundamentals/dummy.dart';
import 'topics/network_fundamentals/network_network.dart';
import 'topics/network_fundamentals/network_ip.dart';
import 'topics/network_fundamentals/network_osi.dart';

class ContentRegistry {
  static final Map<String, ModuleContent> _contents = {

    // network fundamentals
    'nf_intro': NetworkIntroContent(),
    'nf_internet': NetworkInternetContent(),
    'nf_network': NetworkContent(),
    'nf_ip': NetworkIPContent(),
    'nf_osi': NetworkOSIContent(),
    'nf_tcpip': Sample(),
  };

  static List<ContentBlock> getContent(String moduleId) {
    final content = _contents[moduleId];
    if (content != null) {
      return content.getContent();
    }
    return [
      ContentBlock(
        type: ContentBlockType.paragraph,
        content: 'Content coming soon...',
      ),
    ];
  }
}
