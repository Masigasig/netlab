import '../models/content_block.dart';

import '../data/network_fundamentals/network_intro_content.dart';
import '../data/network_fundamentals/network_internet.dart';
import '../data/network_fundamentals/host.dart';
import '../data/network_fundamentals/network_network.dart';
import '../data/network_fundamentals/network_ip.dart';
import '../data/network_fundamentals/network_osi.dart';

import '../data/quizzes/chapter_quiz/network_fudamentals_chapter_quiz/host_quiz.dart';
import '../data/quizzes/chapter_quiz/network_fudamentals_chapter_quiz/network_fundamentals_quiz.dart';
import '../data/quizzes/chapter_quiz/network_fudamentals_chapter_quiz/internet_quiz.dart';
import '../data/quizzes/chapter_quiz/network_fudamentals_chapter_quiz/network_quiz.dart';
import '../data/quizzes/chapter_quiz/network_fudamentals_chapter_quiz/network_ip_quiz.dart';
import '../data/quizzes/chapter_quiz/network_fudamentals_chapter_quiz/osi_quiz.dart';

import '../data/quizzes/topic_quiz/network_fundamentals_topic_quiz.dart';

import '../data/network_devices/repeater.dart';
import '../data/network_devices/hub.dart';
import '../data/network_devices/bridge.dart';
import '../data/network_devices/switch.dart';
import '../data/network_devices/router.dart';

import '../data/quizzes/chapter_quiz/network_devices_chapter_quiz/repeater_quiz.dart';
import '../data/quizzes/chapter_quiz/network_devices_chapter_quiz/hub_quiz.dart';
import '../data/quizzes/chapter_quiz/network_devices_chapter_quiz/bridge_quiz.dart';
import '../data/quizzes/chapter_quiz/network_devices_chapter_quiz/switch_quiz.dart';
import '../data/quizzes/chapter_quiz/network_devices_chapter_quiz/router_quiz.dart';

import '../data/quizzes/topic_quiz/network_devices_topic_quiz.dart';

import '../data/subnetting/subnetting_intro.dart';
import '../data/subnetting/subnetting_attributes.dart';
import '../data/subnetting/subnetting_cidr.dart';
import '../data/subnetting/subnetting_example.dart';
import '../data/subnetting/subnetting_practice.dart';

import '../data/host_to_host/hth_overview.dart';
import '../data/host_to_host/hth_preparing.dart';
import '../data/host_to_host/hth_arp.dart';
import '../data/host_to_host/hth_packet_flow.dart';
import '../data/host_to_host/hth_efficiency.dart';
import '../data/host_to_host/hth_summary.dart';
import '../data/host_to_host/hth_quiz.dart';

import '../data/quizzes/chapter_quiz/host_to_host_chapter_quiz/host_overview_quiz.dart';
import '../data/quizzes/chapter_quiz/host_to_host_chapter_quiz/preparing_to_send_data_quiz.dart';
import '../data/quizzes/chapter_quiz/host_to_host_chapter_quiz/address_resolution_protocol_quiz.dart';
import '../data/quizzes/chapter_quiz/host_to_host_chapter_quiz/packet_transmission_reception_quiz.dart';
import '../data/quizzes/chapter_quiz/host_to_host_chapter_quiz/subsequent_communication_quiz.dart';

import '../data/quizzes/topic_quiz/host_to_host_topic_quiz.dart';

import '../data/switching_routing/intro_switching.dart';
import '../data/switching_routing/mac_address_table.dart';
import '../data/switching_routing/switch_operation.dart';
import '../data/switching_routing/switch_frame_types.dart';
import '../data/switching_routing/intro_routing.dart';
import '../data/switching_routing/host_router.dart';
import '../data/switching_routing/router_connection.dart';
import '../data/switching_routing/routing_table.dart';
import '../data/switching_routing/routing_types.dart';
import '../data/switching_routing/switching_routing_quiz.dart';

class ContentRegistry {
  static final Map<String, ModuleContent> _contents = {
    // network fundamentals
    'nf_intro': NetworkIntroContent(),
    'nf_host': HostContent(),
    'nf_internet': NetworkInternetContent(),
    'nf_network': NetworkContent(),
    'nf_ip': NetworkIPContent(),
    'nf_osi': NetworkOSIContent(),

    // network fundamentals chapter quizzes
    'nf_quiz': NFQuiz(),
    'nf_host_quiz': HostQuiz(),
    'nf_internet_quiz': InternetQuiz(),
    'nf_network_quiz': NetworkQuiz(),
    'nf_network_ip_quiz': NetworkIpQuiz(),
    'nf_osi_model_quiz': OsiModelQuiz(),

    // network fundamentals topic quiz
    'nf_topic_quiz': NetworkFundamentalsTopicQuiz(),

    // network devices
    'nd_repeater': RepeaterContent(),
    'nd_hub': HubContent(),
    'nd_bridge': BridgeContent(),
    'nd_switch': SwitchContent(),
    'nd_router': RouterContent(),

    // network devices chapter quizzes
    'nd_repeater_quiz': RepeaterQuiz(),
    'nd_hub_quiz': HubQuiz(),
    'nd_bridge_quiz': BridgeQuiz(),
    'nd_switch_quiz': SwitchQuiz(),
    'nd_router_quiz': RouterQuiz(),

    // network devices topic quiz
    'nd_topic_quiz': NetworkDevicesTopicQuiz(),

    // subnetting
    'sub_intro': SubnettingIntroContent(),
    'sub_attributes': SubnettingAttributesContent(),
    'sub_cidr': SubnettingCidrContent(),
    'sub_example': SubnettingExampleContent(),
    'sub_practice': SubnettingPracticeContent(),

    // host to host
    'h2h_overview': HostToHostOverviewContent(),
    'h2h_preparing': HostToHostPreparingContent(),
    'h2h_arp': HostToHostArpContent(),
    'h2h_packet_flow': HostToHostPacketFlowContent(),
    'h2h_efficiency': HostToHostEfficiencyContent(),
    'h2h_summary': HostToHostSummaryContent(),
    'h2h_quiz': H2HQuiz(),

    // host to host chapter quiz
    'hh_host_overview_quiz': HostOverviewQuiz(),
    'hh_preparing_quiz': PreparingToSendDataQuiz(),
    'hh_arp_quiz': AddressResolutionProtocolQuiz(),
    'hh_packet_transmission_quiz': PacketTransmissionReceptionQuiz(),
    'hh_subsequent_communication_quiz': SubsequentCommunicationQuiz(),

    // host to host topic quiz
    'hh_topic_quiz': HostToHostTopicQuiz(),

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
    'sr_quiz': RoutingSwitchingQuiz(),
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

  static List<String> getAllModuleIds() {
    return _contents.keys.toList();
  }

  static bool hasModule(String moduleId) {
    return _contents.containsKey(moduleId);
  }
}
