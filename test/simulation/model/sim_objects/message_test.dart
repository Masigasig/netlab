import 'package:flutter_test/flutter_test.dart';

import 'package:netlab/simulation/model/sim_objects/sim_object.dart';

void main() {
  late Message message;

  setUp(() {
    message = const Message(
      id: 'messageId',
      name: 'Message_1',
      posX: 50,
      posY: 100,
      duration: Duration(seconds: 0),
      srcId: 'someSrcId',
      dstId: 'someDstId',
      currentPlaceId: 'someCrntId',
      layerStack: [
        {'lvl3src': 'someIPsrc', 'lvl3dst': 'someIPdst'},
        {'lvl2src': 'someMACsrc', 'lvl2dst': 'someMACdst'},
        {'lvl1src': 'someConnsrc', 'lvl1dst': 'someConndst'},
      ],
    );
  });

  test('copyWith creates a new Message with updated properties', () {
    final updatedMessage = message.copyWith(
      posX: 75,
      posY: 125,
      duration: const Duration(seconds: 5),
      currentPlaceId: 'newsomeCrntId',
      layerStack: [
        {'newlvl4src': 'newsomePortsrc', 'newlvl4dst': 'newsomePortdst'},
        {'newlvl3src': 'newsomeIPsrc', 'newlvl3dst': 'newsomeIPdst'},
      ],
    );

    expect(updatedMessage.id, message.id);
    expect(updatedMessage.name, message.name);
    expect(updatedMessage.posX, 75);
    expect(updatedMessage.posY, 125);
    expect(updatedMessage.duration, const Duration(seconds: 5));
    expect(updatedMessage.srcId, message.srcId);
    expect(updatedMessage.dstId, message.dstId);
    expect(updatedMessage.currentPlaceId, 'newsomeCrntId');
    expect(updatedMessage.layerStack, [
      {'newlvl4src': 'newsomePortsrc', 'newlvl4dst': 'newsomePortdst'},
      {'newlvl3src': 'newsomeIPsrc', 'newlvl3dst': 'newsomeIPdst'},
    ]);
  });

  test('toMap and fromMap work correctly', () {
    final map = message.toMap();
    final newMessage = Message.fromMap(map);

    expect(newMessage.id, message.id);
    expect(newMessage.name, message.name);
    expect(newMessage.posX, message.posX);
    expect(newMessage.posY, message.posY);
    expect(newMessage.duration, message.duration);
    expect(newMessage.srcId, message.srcId);
    expect(newMessage.dstId, message.dstId);
    expect(newMessage.currentPlaceId, message.currentPlaceId);
    expect(newMessage.layerStack, message.layerStack);
    expect(newMessage.type, message.type);
  });
}
