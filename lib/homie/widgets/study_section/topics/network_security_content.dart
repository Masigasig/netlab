// homie/widgets/study_section/topics/network_security_content.dart
import 'package:flutter/material.dart';
import '../widgets/base_topic_content.dart';
import '../models/content_module.dart';

class NetworkSecurityContent extends BaseTopicContent {
  const NetworkSecurityContent({
    super.key,
    required super.topic,
  });

  @override
  List<ContentModule> getContentModules() {
    return [
      ContentModule(
        id: 'ns_fundamentals',
        title: 'Security Fundamentals',
        description: 'Core principles of network security',
        icon: Icons.security,
        duration: 18,
        type: ContentType.video,
      ),
      ContentModule(
        id: 'ns_firewalls',
        title: 'Firewalls',
        description: 'Types and configuration of firewalls',
        icon: Icons.fireplace,
        duration: 28,
        type: ContentType.reading,
      ),
      ContentModule(
        id: 'ns_vpn',
        title: 'VPN Technologies',
        description: 'Virtual Private Network implementation',
        icon: Icons.vpn_lock,
        duration: 35,
        type: ContentType.interactive,
      ),
      ContentModule(
        id: 'ns_encryption',
        title: 'Encryption Methods',
        description: 'Cryptography in network security',
        icon: Icons.enhanced_encryption,
        duration: 25,
        type: ContentType.reading,
      ),
    ];
  }
}