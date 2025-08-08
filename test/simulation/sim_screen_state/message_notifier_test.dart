import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netlab/simulation/sim_object/sim_object.dart';

import 'package:netlab/simulation/sim_screen_state/sim_screen_state.dart';

void main() {
  late ProviderContainer container;
  late MessageNotifier notifier;
  const messageId = 'messageId';

  setUp(() {
    container = ProviderContainer();
    notifier = container.read(messageProvider.notifier);

    const message = Message(
      id: messageId,
      srcId: 'srcId',
      dstId: 'dstId',
      currentPlaceId: 'crntId',
      layerStack: [
        {'src': 'Ipsrc', 'dst': 'Ipdst'},
      ],
    );

    notifier.state = {messageId: message};
  });

  tearDown(() {
    container.dispose();
  });

  group('Inherited method', () {
    test('addSimObject in MessageNotifier should add new message in state', () {
      expect(notifier.state.length, 1);

      const newMessage = Message(
        id: 'newMessageId',
        srcId: 'srcId',
        dstId: 'dstId',
        currentPlaceId: 'crntId',
        layerStack: [
          {'src': 'Ipsrc', 'dst': 'Ipdst'},
        ],
      );

      notifier.addSimObject(newMessage);
      expect(notifier.state.length, 2);
    });
  });

  group('Main method', () {
    test('pushLayer and popLayer should work properly', () {
      final newLayer = {'foo': 'bar'};
      notifier.pushLayer(messageId, newLayer);

      final updatedMessage = notifier.state[messageId]!;
      expect(updatedMessage.layerStack.last, newLayer);
      expect(updatedMessage.layerStack.length, 2);

      notifier.popLayer(messageId);
      final popedMessage = notifier.state[messageId]!;
      expect(popedMessage.layerStack[0]['src'], 'Ipsrc');
      expect(popedMessage.layerStack.length, 1);
    });

    test('updateCurrentPlaceId should work properly', () {
      expect(notifier.state[messageId]!.currentPlaceId, 'crntId');

      notifier.updateCurrentPlaceId(messageId, 'updatedId');

      expect(notifier.state[messageId]!.currentPlaceId, 'updatedId');
    });

    test('peekLayerStack should return top Layer', () {
      expect(notifier.state[messageId]!.layerStack.last, {
        'src': 'Ipsrc',
        'dst': 'Ipdst',
      });
      expect(notifier.state[messageId]!.layerStack.last['dst'], 'Ipdst');
      expect(notifier.state[messageId]!.layerStack.last['src'], 'Ipsrc');
    });
  });
}
