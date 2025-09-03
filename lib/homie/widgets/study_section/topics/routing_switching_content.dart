import '../widgets/base_topic_content.dart';
import '../models/content_module.dart';
import 'package:hugeicons/hugeicons.dart';

class RoutingSwitchingContent extends BaseTopicContent {
  const RoutingSwitchingContent({
    super.key,
    required super.topic,
  });

  @override
  List<ContentModule> getContentModules() {
    return [
      ContentModule(
        id: 'sr_intro_switching',
        title: 'Introduction to Switching',
        description: '',
        icon: HugeIcons.strokeRoundedStartUp02,
        duration: 20,
        type: ContentType.video,
      ),
      ContentModule(
        id: 'sr_mac_table',
        title: 'MAC Address Table',
        description: '',
        icon: HugeIcons.strokeRoundedEditTable,
        duration: 25,
        type: ContentType.reading,
      ),
      ContentModule(
        id: 'sr_operations',
        title: 'Switch Operations',
        description: '',
        icon: HugeIcons.strokeRoundedShuffle,
        duration: 35,
        type: ContentType.interactive,
      ),
      ContentModule(
        id: 'sr_frame_types',
        title: 'Switch Frame Types',
        description: '',
        icon: HugeIcons.strokeRoundedExchange01,
        duration: 30,
        type: ContentType.video,
      ),
      ContentModule(
        id: 'sr_intro',
        title: 'Introduction to Routing',
        description: '',
        icon: HugeIcons.strokeRoundedStartUp02,
        duration: 40,
        type: ContentType.lab,
      ),
      ContentModule(
        id: 'sr_host_vs_router',
        title: 'Host vs Router',
        description: '',
        icon: HugeIcons.strokeRoundedGitCompare,
        duration: 15,
        type: ContentType.quiz,
      ),
      ContentModule(
        id: 'sr_network_connections',
        title: 'Router Network Connections',
        description: '',
        icon: HugeIcons.strokeRoundedFlowConnection,
        duration: 25,
        type: ContentType.reading,
      ),
      ContentModule(
        id: 'sr_routing_table',
        title: 'Routing Table',
        description: '',
        icon: HugeIcons.strokeRoundedLayoutTable01,
        duration: 25,
        type: ContentType.reading,
      ),
      ContentModule(
        id: 'sr_routing_types',
        title: 'Routing Types',
        description: '',
        icon: HugeIcons.strokeRoundedRoute01,
        duration: 25,
        type: ContentType.reading,
      ),
    ];
  }
}