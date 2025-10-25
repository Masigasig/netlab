import 'package:netlab/temp/homie/widgets/study_section/features/study_content/models/content_block.dart';

class OrganizingNetworkContent implements ModuleContent {
  @override
  String get moduleId => 'organizing_network';

  @override
  List<ContentBlock> getContent() {
    return [
      // ContentBlock(
      //   type: ContentBlockType.image,
      //   title: 'Network organization example',
      //   content: 'assets/tutorials/organizing_network.png',
      // ),
      ContentBlock(
        type: ContentBlockType.numberedList,
        content: [
          'Drag devices to reposition them on the canvas',
          'Use grid snap feature for precise device alignment',
          'Zoom in/out to manage your workspace effectively',
          'Group related devices together for better organization',
        ],
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            'Pro Tip: Use keyboard shortcuts (Ctrl + mouse wheel) to quickly zoom in and out of your network topology.',
      ),
      ContentBlock(
        type: ContentBlockType.definition,
        content: [
          {
            'term': 'Grid Snap',
            'definition':
                'A feature that automatically aligns devices to a grid, making it easier to create neat and organized layouts.',
          },
          {
            'term': 'Zoom Level',
            'definition':
                'Adjust the zoom level to either see the entire network topology or focus on specific areas in detail.',
          },
        ],
      ),
    ];
  }
}
