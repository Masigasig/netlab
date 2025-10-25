import 'package:flutter/material.dart';
import '../models/tutorial_section.dart';
import '../models/tutorial_item.dart';
import 'content/basics/add_device_content.dart';
import 'content/basics/connecting_devices_content.dart';
import 'content/basics/organizing_network_content.dart';
import 'content/config/configuring_routers_content.dart';
import 'content/config/setting_up_switches_content.dart';
import 'content/config/managing_firewall_content.dart';
import 'content/simulation/running_simulations_content.dart';
import 'content/simulation/monitoring_traffic_content.dart';
import 'content/simulation/analyzing_performance_content.dart';

class TutorialData {
  static List<TutorialSection> getSections() {
    return [
      TutorialSection(
        id: 'basics',
        title: 'Getting Started',
        description: 'Learn the basics of building network topologies',
        icon: Icons.lightbulb_outline,
        items: [
          TutorialItem(
            title: 'Adding Devices to Canvas',
            description:
                'Drag devices from the toolbar onto the canvas. Select from routers, switches, computers, and other network equipment. Position them anywhere you want.',
            icon: Icons.add_circle_outline,
            content: AddDevicesContent(),
          ),
          TutorialItem(
            title: 'Connecting Your Devices',
            description:
                'Click on one device, then click on another to create a connection. Cables automatically route between devices. Reconnect or delete connections anytime.',
            icon: Icons.cable_outlined,
            content: ConnectingDevicesContent(),
          ),
          TutorialItem(
            title: 'Organizing Your Network',
            description:
                'Drag devices to reposition them. Use grid snap to align devices neatly. Zoom in and out to view your entire network topology.',
            icon: Icons.grid_on_outlined,
            content: OrganizingNetworkContent(),
          ),
        ],
      ),
      TutorialSection(
        id: 'config',
        title: 'Configuration',
        description: 'Configure network devices and settings',
        icon: Icons.tune,
        items: [
          TutorialItem(
            title: 'Configuring Routers',
            description:
                'Double-click any router to open its configuration panel. Set IP addresses, subnet masks, and routing protocols like OSPF or RIP. Save settings to apply.',
            icon: Icons.router_outlined,
            content: ConfiguringRoutersContent(),
          ),
          TutorialItem(
            title: 'Setting Up Switches',
            description:
                'Configure VLANs, port settings, and spanning tree protocol. Create logical network segments. Assign specific ports to VLANs for better organization.',
            icon: Icons.settings_ethernet_outlined,
            content: SettingUpSwitchesContent(),
          ),
          TutorialItem(
            title: 'Managing Firewall Rules',
            description:
                'Set up firewall policies to control traffic. Create rules for inbound and outbound connections. Define allowed protocols and ports to secure your network.',
            icon: Icons.security_outlined,
            content: ManagingFirewallContent(),
          ),
        ],
      ),
      TutorialSection(
        id: 'simulation',
        title: 'Simulation',
        description: 'Run simulations and analyze network performance',
        icon: Icons.science_outlined,
        items: [
          TutorialItem(
            title: 'Running Simulations',
            description:
                'Click the play button to start simulation. Watch packets flow through your network in real-time. Pause anytime to inspect the current network state.',
            icon: Icons.play_arrow_outlined,
            content: RunningSimulationsContent(),
          ),
          TutorialItem(
            title: 'Monitoring Network Traffic',
            description:
                'Use packet tracer to follow data paths. Click any packet to see its journey and contents. View routing decisions made at each network hop.',
            icon: Icons.monitor_heart_outlined,
            content: MonitoringTrafficContent(),
          ),
          TutorialItem(
            title: 'Analyzing Performance',
            description:
                'View statistics, latency measurements, and throughput data. Check analytics panel for performance metrics. Identify bottlenecks and optimize your design.',
            icon: Icons.analytics_outlined,
            content: AnalyzingPerformanceContent(),
          ),
        ],
      ),
    ];
  }
}
