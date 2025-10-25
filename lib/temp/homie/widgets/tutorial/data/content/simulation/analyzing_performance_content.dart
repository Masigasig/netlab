import 'package:netlab/temp/homie/widgets/study_section/features/study_content/models/content_block.dart';

class AnalyzingPerformanceContent implements ModuleContent {
  @override
  String get moduleId => 'analyzing_performance';

  @override
  List<ContentBlock> getContent() {
    return [
      // ContentBlock(
      //   type: ContentBlockType.image,
      //   title: 'Network analytics dashboard',
      //   content: 'assets/tutorials/analyzing_performance.png',
      // ),
      ContentBlock(
        type: ContentBlockType.numberedList,
        content: [
          'Access the analytics panel from the simulation interface',
          'Review key performance metrics and statistics',
          'Identify potential bottlenecks and congestion points',
          'Analyze bandwidth utilization and latency',
          'Implement optimizations based on analysis results',
        ],
      ),
      ContentBlock(
        type: ContentBlockType.definition,
        content: [
          {
            'term': 'Network Bottleneck',
            'definition':
                'A point in the network where traffic flow is constrained, leading to reduced performance or delays.',
          },
          {
            'term': 'Performance Metrics',
            'definition':
                'Measurable indicators of network performance, including bandwidth utilization, latency, packet loss, and throughput.',
          },
        ],
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            'Pro Tip: Regular performance analysis helps identify potential issues before they impact network users.',
      ),
      ContentBlock(
        type: ContentBlockType.warning,
        content:
            'Performance bottlenecks can have multiple causes. Always analyze the complete network path before making optimizations.',
      ),
    ];
  }
}
