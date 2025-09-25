// ALready done It works with a bit if tweak and modified the main function
// Hard to unit test with Time asynchronous

// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:netlab/simulation/sim_objects/sim_object.dart';
// import 'package:netlab/simulation/sim_screen_state.dart';

// class FakeClock implements Clock {
//   DateTime _now;

//   FakeClock([DateTime? initialTime]) : _now = initialTime ?? DateTime(2025);

//   @override
//   DateTime now() => _now;

//   void advance(Duration duration) {
//     _now = _now.add(duration);
//   }
// }

// void main() {
//   late ProviderContainer container;
//   late FakeClock fakeClock;
//   late HostNotifier host1Notifier;
//   late HostNotifier host2Notifier;
//   late HostNotifier host3Notifier;
//   late MessageNotifier message1Notifier;
//   late MessageNotifier message2Notifier;
//   late MessageNotifier message3Notifier;
//   late MessageNotifier message4Notifier;

//   late String host1Id;
//   late String host2Id;
//   late String host3Id;
//   late String connectionId;
//   late String message1Id;
//   late String message2Id;
//   late String message3Id;
//   late String message4Id;

//   setUp(() {
//     fakeClock = FakeClock();
//     container = ProviderContainer(
//       overrides: [
//         hostProvider.overrideWithProvider((id) {
//           return StateNotifierProvider.autoDispose<HostNotifier, Host>(
//             (ref) => HostNotifier(ref, id, clock: fakeClock),
//           );
//         }),
//       ],
//     );
//     final host1 =
//         SimObjectType.host.createSimObject(posX: 100, posY: 100, name: 'Host_1')
//             as Host;

//     host1Id = host1.id;
//     container.read(hostMapProvider.notifier).addSimObject(host1);
//     host1Notifier = container.read(hostProvider(host1Id).notifier);
//     host1Notifier.updateIpAddress('192.168.1.2');
//     host1Notifier.updateSubnetMask('/24');
//     host1Notifier.updateDefaultGateway('192.168.1.1');

//     final host2 =
//         SimObjectType.host.createSimObject(posX: 200, posY: 200, name: 'Host_2')
//             as Host;

//     host2Id = host2.id;
//     container.read(hostMapProvider.notifier).addSimObject(host2);
//     host2Notifier = container.read(hostProvider(host2Id).notifier);
//     host2Notifier.updateIpAddress('192.168.1.3');
//     host2Notifier.updateSubnetMask('/24');
//     host2Notifier.updateDefaultGateway('192.168.1.1');

//     final host3 =
//         SimObjectType.host.createSimObject(posX: 300, posY: 300, name: 'Host_3')
//             as Host;

//     host3Id = host3.id;
//     container.read(hostMapProvider.notifier).addSimObject(host3);
//     host3Notifier = container.read(hostProvider(host3Id).notifier);
//     host3Notifier.updateIpAddress('192.168.2.4');
//     host3Notifier.updateSubnetMask('/24');
//     host3Notifier.updateDefaultGateway('192.168.2.1');

//     final connection = SimObjectType.connection.createSimObject(
//           conAId: host1Id,
//           conBId: host2Id,
//           conAmac: host1Notifier.state.macAddress,
//           conBmac: host2Notifier.state.macAddress,
//         ) as Connection;

//     connectionId = connection.id;
//     container.read(connectionMapProvider.notifier).addSimObject(connection);

//     host1Notifier.updateConnectionId(connectionId);
//     host2Notifier.updateConnectionId(connectionId);

//     final message1 = SimObjectType.message.createSimObject(
//       srcId: host1Id,
//       dstId: host2Id
//     ) as Message;

//     message1Id = message1.id;
//     container.read(messageMapProvider.notifier).addSimObject(message1);
//     message1Notifier = container.read(messageProvider(message1Id).notifier);
//     message1Notifier.updateCurrentPlaceId(host1Id);

//     final message2 = SimObjectType.message.createSimObject(
//       srcId: host1Id,
//       dstId: host2Id
//     ) as Message;

//     message2Id = message2.id;
//     container.read(messageMapProvider.notifier).addSimObject(message2);
//     message2Notifier = container.read(messageProvider(message2Id).notifier);
//     message2Notifier.updateCurrentPlaceId(host1Id);

//     final message3 = SimObjectType.message.createSimObject(
//       srcId: host2Id,
//       dstId: host1Id
//     ) as Message;

//     message3Id = message3.id;
//     container.read(messageMapProvider.notifier).addSimObject(message3);
//     message3Notifier = container.read(messageProvider(message3Id).notifier);
//     message3Notifier.updateCurrentPlaceId(host2Id);

//     final message4 = SimObjectType.message.createSimObject(
//       srcId: host2Id,
//       dstId: host1Id
//     ) as Message;

//     message4Id = message4.id;
//     container.read(messageMapProvider.notifier).addSimObject(message4);
//     message4Notifier = container.read(messageProvider(message4Id).notifier);
//     message4Notifier.updateCurrentPlaceId(host3Id);

//     host1Notifier.enqueueMessage(message1Id);
//     host1Notifier.enqueueMessage(message2Id);
//     host2Notifier.enqueueMessage(message3Id);
//     host2Notifier.enqueueMessage(message4Id);
//   });

//   tearDown(() {
//     container.dispose();
//   });

//   test('host should timeout ARP request after 10 seconds', () async {
//     host1Notifier.startMessageProcessing();
//     host2Notifier.startMessageProcessing();

//     expect(container.read(messageMapProvider.notifier).state.length, equals(0 ));
//   });
// }
