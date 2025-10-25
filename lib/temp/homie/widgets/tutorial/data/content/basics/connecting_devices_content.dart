import 'package:netlab/temp/homie/widgets/study_section/features/study_content/models/content_block.dart';

class ConnectingDevicesContent implements ModuleContent {
  @override
  String get moduleId => 'connecting_devices';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.image,
        title: 'Device connection example',
        content: 'assets/images/content_image/network_devices/hub.gif',
      ),
      ContentBlock(
        type: ContentBlockType.numberedList,
        content: [
          'Click the first device to connect',
          'Click the second device to create connection',
          'Configure connection properties if needed',
        ],
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            'Pro Tip: The connection line automatically routes between devices, finding the best path to avoid obstacles.',
      ),
      ContentBlock(
        type: ContentBlockType.warning,
        content:
            'Make sure to configure the correct interface types and speeds for your connections. Mismatched settings can cause network issues.',
      ),
    ];
  }
}
