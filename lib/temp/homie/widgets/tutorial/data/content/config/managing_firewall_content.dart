import 'package:netlab/temp/homie/widgets/study_section/features/study_content/models/content_block.dart';

class ManagingFirewallContent implements ModuleContent {
  @override
  String get moduleId => 'managing_firewall';

  @override
  List<ContentBlock> getContent() {
    return [
      // ContentBlock(
      //   type: ContentBlockType.image,
      //   title: 'Firewall configuration interface',
      //   content: 'assets/tutorials/managing_firewall.png',
      // ),
      ContentBlock(
        type: ContentBlockType.numberedList,
        content: [
          'Access the firewall configuration panel',
          'Create inbound and outbound traffic rules',
          'Define allowed protocols and ports',
          'Set up access control lists (ACLs)',
          'Test and verify rule effectiveness',
        ],
      ),
      ContentBlock(
        type: ContentBlockType.definition,
        content: [
          {
            'term': 'ACL (Access Control List)',
            'definition':
                'A set of rules that control which traffic is allowed or denied through the firewall based on source, destination, protocol, and ports.',
          },
          {
            'term': 'Stateful Inspection',
            'definition':
                'A firewall feature that tracks the state of network connections and makes filtering decisions based on context rather than just static rules.',
          },
        ],
      ),
      ContentBlock(
        type: ContentBlockType.warning,
        content:
            'Be careful when configuring firewall rules. Overly restrictive rules can block legitimate traffic, while overly permissive rules can compromise security.',
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            'Pro Tip: Always test firewall rules in a controlled environment before implementing them in a production network.',
      ),
      ContentBlock(
        type: ContentBlockType.table,
        title: 'Common Port Numbers',
        content: [
          ['Service', 'Port', 'Protocol'],
          ['HTTP', '80', 'TCP'],
          ['HTTPS', '443', 'TCP'],
          ['SSH', '22', 'TCP'],
          ['DNS', '53', 'TCP/UDP'],
        ],
        additionalData: {
          'headers': ['Service', 'Port', 'Protocol'],
        },
      ),
    ];
  }
}
