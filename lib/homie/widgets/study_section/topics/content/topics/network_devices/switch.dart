import '../../models/content_block.dart';

class SwitchContent implements ModuleContent {
  @override
  String get moduleId => 'nd_switch';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(type: ContentBlockType.header, title: 'Switch', content: ''),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'A switch is a network device that connects multiple devices within the same network '
            '(computers, printers, phones, etc.) and ensures data only goes where it needs to go.',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'A switch has many ports, like plug-in slots for network cables. '
            'It learns which device is on which port by looking at the device’s MAC address. '
            'When data comes in, the switch checks the MAC address and sends it only to the correct port.',
      ),
      ContentBlock(
        type: ContentBlockType.image,
        content: 'assets/images/content_image/switch_example.png',
        title: 'A switch forwards data only to the intended device',
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            'Switches are smarter than hubs — they forward data only where it belongs.',
      ),
    ];
  }
}
