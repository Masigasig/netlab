import 'package:netlab/temp/homie/widgets/study_section/features/study_content/models/content_block.dart';

class RunningSimulationsContent implements ModuleContent {
  @override
  String get moduleId => 'running_simulations';

  @override
  List<ContentBlock> getContent() {
    return [
      // ContentBlock(
      //   type: ContentBlockType.image,
      //   title: 'Network simulation in action',
      //   content: 'assets/tutorials/running_simulations.png',
      // ),
      ContentBlock(
        type: ContentBlockType.numberedList,
        content: [
          'Click the play button to start the simulation',
          'Watch packets flow through the network in real-time',
          'Use the pause button to freeze the simulation',
          'Inspect the current network state while paused',
          'Adjust simulation speed as needed',
        ],
      ),
      ContentBlock(
        type: ContentBlockType.definition,
        content: [
          {
            'term': 'Real-time Simulation',
            'definition':
                'A simulation mode that shows network behavior as it happens, allowing you to observe packet flow and routing decisions in action.',
          },
          {
            'term': 'Network State',
            'definition':
                'The current condition of the network, including active connections, routing tables, and device status.',
          },
        ],
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            'Pro Tip: Use different simulation speeds to observe network behavior. Slower speeds are useful for detailed analysis, while faster speeds help verify overall network functionality.',
      ),
      ContentBlock(
        type: ContentBlockType.warning,
        content:
            'Make sure all device configurations are complete and correct before starting a simulation to avoid unexpected behavior.',
      ),
    ];
  }
}
