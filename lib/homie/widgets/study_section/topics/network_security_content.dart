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
        description: 'Core principles of network security: confidentiality, integrity, and availability',
        icon: Icons.security,
        duration: 18,
        type: ContentType.video,
      ),
      ContentModule(
        id: 'ns_threats',
        title: 'Common Security Threats',
        description: 'Identify and understand various network security threats and attack vectors',
        icon: Icons.warning,
        duration: 22,
        type: ContentType.reading,
      ),
      ContentModule(
        id: 'ns_firewalls',
        title: 'Firewalls & Access Control',
        description: 'Types and configuration of firewalls, ACLs, and network access control',
        icon: Icons.fireplace,
        duration: 28,
        type: ContentType.interactive,
      ),
      ContentModule(
        id: 'ns_vpn',
        title: 'VPN Technologies',
        description: 'Virtual Private Network implementation, IPSec, and SSL/TLS VPNs',
        icon: Icons.vpn_lock,
        duration: 35,
        type: ContentType.lab,
      ),
      ContentModule(
        id: 'ns_encryption',
        title: 'Encryption & PKI',
        description: 'Cryptography fundamentals, symmetric/asymmetric encryption, and PKI',
        icon: Icons.enhanced_encryption,
        duration: 25,
        type: ContentType.reading,
      ),
      ContentModule(
        id: 'ns_ids_ips',
        title: 'IDS/IPS Systems',
        description: 'Intrusion Detection and Prevention Systems configuration and management',
        icon: Icons.shield,
        duration: 30,
        type: ContentType.video,
      ),
      ContentModule(
        id: 'ns_wireless_security',
        title: 'Wireless Security',
        description: 'Securing wireless networks: WPA3, enterprise authentication, and best practices',
        icon: Icons.wifi_protected_setup,
        duration: 20,
        type: ContentType.interactive,
      ),
      ContentModule(
        id: 'ns_quiz',
        title: 'Network Security Assessment',
        description: 'Comprehensive assessment of network security concepts and implementations',
        icon: Icons.quiz,
        duration: 20,
        type: ContentType.quiz,
      ),
    ];
  }

  @override
  void onModuleTap(BuildContext context, ContentModule module) {
    switch (module.type) {
      case ContentType.video:
        _showModuleMessage(context, 'Loading security training video: ${module.title}');
        break;
      case ContentType.reading:
        _showModuleMessage(context, 'Opening security documentation: ${module.title}');
        break;
      case ContentType.quiz:
        _showModuleMessage(context, 'Preparing security assessment: ${module.title}');
        break;
      case ContentType.lab:
        _showModuleMessage(context, 'Starting security lab: ${module.title}');
        break;
      case ContentType.interactive:
        _showModuleMessage(context, 'Loading interactive security demo: ${module.title}');
        break;
    }
  }

  void _showModuleMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: topic.cardColor.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}