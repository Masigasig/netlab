import '../models/content_block.dart';
import '../data/network_fundamentals/network_intro_content.dart';
import '../data/network_fundamentals/network_internet.dart';
import '../data/network_fundamentals/host.dart';
import '../data/network_fundamentals/network_network.dart';
import '../data/network_fundamentals/network_ip.dart';
import '../data/network_fundamentals/network_osi.dart';
import '../data/switching_routing/intro_switching.dart';
import '../data/switching_routing/mac_address_table.dart';
import '../data/switching_routing/switch_operation.dart';
import '../data/switching_routing/switch_frame_types.dart';
import '../data/switching_routing/intro_routing.dart';
import '../data/switching_routing/host_router.dart';
import '../data/switching_routing/router_connection.dart';
import '../data/switching_routing/routing_table.dart';
import '../data/switching_routing/routing_types.dart';
import '../data/network_devices/repeater.dart';
import '../data/network_devices/hub.dart';
import '../data/network_devices/bridge.dart';
import '../data/network_devices/switch.dart';
import '../data/network_devices/router.dart';
import '../data/network_fundamentals/sample_quiz.dart';

class ContentRegistry {
  static final Map<String, ModuleContent> _contents = {
    // network fundamentals
    'nf_intro': NetworkIntroContent(),
    'nf_host': HostContent(),
    'nf_internet': NetworkInternetContent(),
    'nf_network': NetworkContent(),
    'nf_ip': NetworkIPContent(),
    'nf_osi': NetworkOSIContent(),
    'nf_quiz': NFQuiz(),

    // switching and routing
    'sr_intro_switching': SwitchingIntroContent(),
    'sr_mac_table': SwitchingMacTableContent(),
    'sr_operations': SwitchingOperationsContent(),
    'sr_frame_types': SwitchingFrameTypesContent(),
    'sr_intro': RoutingIntroContent(),
    'sr_host_vs_router': RoutingHostVsRouterContent(),
    'sr_network_connections': RoutingNetworkConnectionsContent(),
    'sr_routing_table': RoutingTableContent(),
    'sr_routing_types': RoutingTypesContent(),

    // network devices
    'nd_repeater': RepeaterContent(),
    'nd_hub': HubContent(),
    'nd_bridge': BridgeContent(),
    'nd_switch': SwitchContent(),
    'nd_router': RouterContent(),
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
