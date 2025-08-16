// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:netlab/simulation/sim_objects/sim_object.dart';

// import 'package:netlab/simulation/sim_screen_state.dart';

// void main() {
//   late ProviderContainer container;
//   late MessageNotifier notifier;
//   const messageId = 'messageId';

//   setUp(() {
//     container = ProviderContainer();

//     const message = Message(
//       id: messageId,
//       srcId: 'srcId',
//       dstId: 'dstId',
//       currentPlaceId: 'srcId',
//       layerStack: [
//         {'src': 'Ipsrc', 'dst': 'Ipdst'},
//       ],
//     );

//     container.read(messageMapProvider.notifier).addSimObject(message);
//     notifier = container.read(messageProvider(messageId).notifier);
//   });

//   tearDown(() {
//     container.dispose();
//   });

//   test('pushLayer and popLayer should work properly', () {
//     final newLayer = {'foo': 'bar'};
//     notifier.pushLayer(newLayer);

//     expect(notifier.state.layerStack.last, equals(newLayer));
//     expect(notifier.state.layerStack.length, equals(2));

//     final popedLayer = notifier.popLayer();

//     expect(popedLayer, equals(newLayer));
//     expect(notifier.state.layerStack[0]['src'], equals('Ipsrc'));
//     expect(notifier.state.layerStack.length, equals(1));
//   });

//   test('updateCurrentPlaceId should work properly', () {
//     expect(notifier.state.currentPlaceId, equals('srcId'));

//     notifier.updateCurrentPlaceId('updatedId');

//     expect(notifier.state.currentPlaceId, equals('updatedId'));
//   });
// }
