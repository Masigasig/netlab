import '../../../../models/content_block.dart';
import '../../../../models/quiz_data.dart';

class MacAddressTableQuiz implements ModuleContent {
  @override
  String get moduleId => 'sr_mac_address_table_quiz';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What is the main purpose of the MAC address table in a switch?',
          options: [
            'To store IP address-to-port mappings',
            'To map device MAC addresses to specific switch ports',
            'To keep a list of connected routers',
            'To assign MAC addresses to new devices',
          ],
          correctAnswerIndex: 1,
          explanation:
              'The MAC address table records which device (by MAC address) is connected to which port, allowing the switch to forward frames accurately.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'How does a switch learn which MAC addresses are connected to which ports?',
          options: [
            'By manually configuring them',
            'By analyzing the source MAC address of incoming frames',
            'By reading the IP header of packets',
            'By receiving routing updates from other switches',
          ],
          correctAnswerIndex: 1,
          explanation:
              'A switch learns MAC addresses dynamically by checking the source MAC address of each incoming frame and recording the port it arrived on.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What does a switch do when it receives a frame with a destination MAC address not found in its MAC table?',
          options: [
            'Drops the frame immediately',
            'Sends the frame to all ports except the incoming one (flooding)',
            'Requests the IP address from a DHCP server',
            'Sends an error message to the sender',
          ],
          correctAnswerIndex: 1,
          explanation:
              'When a destination MAC is unknown, the switch floods the frame to all ports except the source port, ensuring it reaches the intended recipient.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'When a switch successfully forwards a frame to a destination MAC address, what happens next?',
          options: [
            'The entry for that MAC address is deleted from the table',
            'The MAC table entry is updated or refreshed for that port',
            'The MAC table is cleared entirely',
            'The switch creates a new VLAN for the device',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Once the switch successfully delivers the frame, it refreshes the MAC address entry to maintain accurate mappings for future transmissions.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What happens when a switch’s MAC address table becomes full?',
          options: [
            'It stops learning new addresses',
            'It starts overwriting the oldest entries as new ones arrive',
            'It automatically resets all connections',
            'It begins assigning random MAC addresses',
          ],
          correctAnswerIndex: 1,
          explanation:
              'When the MAC table is full, the switch may overwrite the oldest or least recently used entries with new ones, depending on the configuration.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'True or False: The MAC address table is permanently stored in the switch’s memory.',
          options: ['True', 'False'],
          correctAnswerIndex: 1,
          explanation:
              'False — the MAC address table is stored in volatile memory (RAM) and is cleared when the switch is powered off or restarted.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What type of traffic is sent when a switch does not yet know the destination MAC address?',
          options: ['Unicast', 'Broadcast', 'Multicast', 'Flooded'],
          correctAnswerIndex: 3,
          explanation:
              'The switch floods the frame out of all ports (except the source port), which is sometimes called a "flooded" frame, until the MAC address is learned.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'Why do switches periodically age out MAC address entries?',
          options: [
            'To save storage space by removing inactive devices',
            'To increase broadcast traffic',
            'To block unused ports automatically',
            'To convert old MAC addresses into IP addresses',
          ],
          correctAnswerIndex: 0,
          explanation:
              'Aging out removes entries that haven’t been used for a while, freeing memory and ensuring the table only contains active device mappings.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What information does each entry in the MAC address table contain?',
          options: [
            'Device IP address and VLAN ID',
            'Device MAC address and corresponding switch port',
            'Hostname and subnet mask',
            'Switch serial number and interface speed',
          ],
          correctAnswerIndex: 1,
          explanation:
              'Each MAC address table entry links a device’s MAC address to the specific switch port where it’s connected, enabling direct frame delivery.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'True or False: The MAC address table is also known as the forwarding database (FDB).',
          options: ['True', 'False'],
          correctAnswerIndex: 0,
          explanation:
              'True — the MAC address table is often referred to as the forwarding database because it stores forwarding information for each MAC address.',
        ),
      ),
    ];
  }
}
