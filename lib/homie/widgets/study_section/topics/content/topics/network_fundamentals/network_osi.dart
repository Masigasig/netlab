import '../../models/content_block.dart';

class NetworkOSIContent implements ModuleContent {
  @override
  String get moduleId => 'nf_osi';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.header,
        title: 'A conceptual framework of how data moves across a network',
        content: '',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'The OSI Model is a conceptual framework that explains how computers and devices communicate over a network. '
            'It is mainly used as a teaching and troubleshooting tool. '
            'In real-world networking, the TCP/IP Model is used for implementation, but OSI is still useful for understanding the concepts.',
      ),
      ContentBlock(
        type: ContentBlockType.image,
        content: 'assets/images/osi_layers.png',
        title: 'The 7 layers of the OSI Model',
      ),
      ContentBlock(
        type: ContentBlockType.bulletList,
        content: [
          'Layer 1: Physical – Transmits raw bits (1s and 0s) as electrical signals, light, or radio waves using cables, fiber optics, or Wi-Fi. Devices: repeaters, hubs.',
          'Layer 2: Data Link – Organizes bits into frames, adds MAC addresses, checks for errors, ensures devices on the same local network can communicate.',
          'Layer 3: Network – Uses IP addresses to identify devices and routes packets across multiple networks.',
          'Layer 4: Transport – Ensures correct service-to-service delivery using ports. TCP provides reliability, UDP provides efficiency.',
          'Layers 5–7: Application – Session, Presentation, and Application layers. Today these are usually combined into a single Application layer that handles user-facing apps, data formatting, and connections.',
        ],
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            'The OSI Model is not implemented directly, but it provides a structured way to understand and troubleshoot network communication.',
      ),
    ];
  }
}