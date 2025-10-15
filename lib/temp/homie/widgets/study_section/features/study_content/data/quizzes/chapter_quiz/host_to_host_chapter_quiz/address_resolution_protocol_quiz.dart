import '../../../../models/content_block.dart';
import '../../../../models/quiz_data.dart';

class AddressResolutionProtocolQuiz implements ModuleContent {
  @override
  String get moduleId => 'hh_arp_quiz';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What is the main purpose of the Address Resolution Protocol (ARP)?',
          options: [
            'To translate MAC addresses into IP addresses',
            'To translate IP addresses into MAC addresses',
            'To assign IP addresses automatically to devices',
            'To encrypt data between network hosts',
          ],
          correctAnswerIndex: 1,
          explanation:
              'ARP translates IP addresses into their corresponding MAC addresses so that devices on the same network can communicate at the data link layer.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'When a device wants to send data to another host on the same network, what does it use to find the destination MAC address?',
          options: ['DHCP', 'DNS', 'ARP request', 'ICMP echo'],
          correctAnswerIndex: 2,
          explanation:
              'The device sends an ARP request asking “Who has this IP address?” The host with that IP replies with its MAC address using an ARP reply.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What type of message does a device broadcast when performing an ARP request?',
          options: [
            'A unicast frame',
            'A broadcast frame',
            'A multicast packet',
            'A TCP segment',
          ],
          correctAnswerIndex: 1,
          explanation:
              'An ARP request is sent as a broadcast frame to all devices in the local network segment, allowing the correct host to respond.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'What happens after a device receives an ARP reply?',
          options: [
            'It ignores the response',
            'It adds the IP-to-MAC mapping to its ARP cache',
            'It deletes the MAC address from memory',
            'It sends a new broadcast to confirm',
          ],
          correctAnswerIndex: 1,
          explanation:
              'After receiving an ARP reply, the device stores the mapping of the IP and MAC address in its ARP cache for future communication.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'True or False: ARP operates at the Network Layer of the OSI model.',
          options: ['True', 'False'],
          correctAnswerIndex: 1,
          explanation:
              'False — ARP operates between the Network (Layer 3) and Data Link (Layer 2) layers, linking IP addresses to MAC addresses.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question: 'Which of the following best describes the ARP table?',
          options: [
            'A database that stores IP-to-MAC address mappings',
            'A list of device hostnames on the network',
            'A routing table used for forwarding packets',
            'A list of connected network interfaces',
          ],
          correctAnswerIndex: 0,
          explanation:
              'An ARP table (or cache) stores recently learned IP-to-MAC address pairs, allowing faster communication between local hosts.',
        ),
      ),
      ContentBlock(
        type: ContentBlockType.quiz,
        content: QuizData(
          question:
              'What problem does ARP solve in host-to-host communication?',
          options: [
            'Finding the correct IP address of a website',
            'Mapping a host’s IP address to its physical MAC address',
            'Preventing packet loss during transmission',
            'Encrypting data before sending it',
          ],
          correctAnswerIndex: 1,
          explanation:
              'ARP enables devices to map logical IP addresses to physical MAC addresses, which is essential for sending data within a local network.',
        ),
      ),
    ];
  }
}
