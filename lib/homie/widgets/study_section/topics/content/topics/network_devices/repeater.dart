import '../../models/content_block.dart';

class RepeaterContent implements ModuleContent {
  @override
  String get moduleId => 'nd_repeater';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.header,
        title: 'Repeater',
        content: '',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'When data moves through a cable, it weakens over distance. '
            'This weakening of the signal is called signal decay or attenuation. '
            'If the signal becomes too weak, the receiving computer cannot understand it.',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'A repeater’s main function is to amplify or regenerate the signal over the same network '
            'before the signal becomes too weak or corrupted. '
            'This extends the distance over which data can be transmitted in the same network.',
      ),
      ContentBlock(
        type: ContentBlockType.image,
        content: 'assets/images/content_image/repeater_example.png',
        title: 'A repeater extends network signal strength across longer distances',
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            'Repeaters regenerate signals — they don’t interpret data, just strengthen it.',
      ),
    ];
  }
}