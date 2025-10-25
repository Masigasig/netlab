import 'package:netlab/temp/homie/widgets/study_section/features/study_content/models/content_block.dart';
import 'package:netlab/core/constants/app_image.dart';

class AddDevicesContent implements ModuleContent {
  @override
  String get moduleId => 'add_devices';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.image,
        title: 'Device toolbar and canvas workspace',
        content: ContentImage.host,
      ),
      ContentBlock(
        type: ContentBlockType.numberedList,
        content: [
          'Select a device from the toolbar',
          'Click anywhere on the canvas to place it',
          'Repeat to add more devices',
        ],
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            'Pro Tip: Use the grid snapping feature to align your devices perfectly. Enable it from the toolbar for precise placement.',
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            'Each device type has different configuration options. After placing a device, you can double-click it to access its settings.',
      ),
    ];
  }
}
