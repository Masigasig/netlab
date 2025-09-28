import '../../models/content_block.dart';
import 'package:netlab/core/constants/app_image.dart';  

class NetworkContent implements ModuleContent {
  @override
  String get moduleId => 'nf_network';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.header,
        title: 'A group of hosts that communicate with each other',
        content: '',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'A network is a group of hosts that communicate with each other, requiring similar connectivity. '
            'For example, in my house we have Wi-Fi and all my devices like computers and phones connect to it. '
            'My neighbor also has their own Wi-Fi for their devices — that makes it a separate network.',
      ),
      ContentBlock(
        type: ContentBlockType.image,
        content: ContentImage.network,
        title: 'Home Wi-Fi vs. Neighbor Wi-Fi (separate networks)',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'Networks can also contain other networks, called subnets. '
            'For example, in a school there might be a main network, but it is divided into two sub-networks: '
            'one for Faculty and another for Students. Devices in each group connect to their respective subnet.',
      ),
      ContentBlock(
        type: ContentBlockType.image,
        content: 'assets/images/school_subnets.png',
        title: 'School network divided into Faculty and Student subnets',
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            'Even if networks are separated (like Faculty and Students), they can still belong to a larger parent network (the School Network).',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            'But what if I am at home and I want to access a resource from the student network? '
            'I cannot directly connect my home network to theirs — instead, I would use the Internet.',
      ),
    ];
  }
}
