import 'models/content_block.dart';
import 'topics/network_fundamentals/network_intro_content.dart';
import 'topics/network_fundamentals/network_osi_content.dart';

class ContentRegistry {
  static final Map<String, ModuleContent> _contents = {
    'nf_intro': NetworkIntroContent(),
    'nf_osi': NetworkOsiContent(),
    // Add more content modules here
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
