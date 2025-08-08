import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netlab/simulation/sim_object/sim_object.dart';

import 'package:netlab/simulation/sim_screen_state/sim_screen_state.dart';

void main() {
  late ProviderContainer container;
  late HostNotifier hostNotifier;
  late ConnectionNotifier connectionNotifier;
  late MessageNotifier messageNotifier;
  late String hostId1;
  late String hostId2;
  late String conId;
  late String messageId;

  setUp(() {
    container = ProviderContainer();
    hostNotifier = container.read(hostProvider.notifier);
    messageNotifier = container.read(messageProvider.notifier);
    connectionNotifier = container.read(connectionProvider.notifier);

    final host1 = SimObjectType.host.createSimObject(
      posX: 100,
      posY: 100,
      name: 'Host_1',
    );

    hostId1 = host1.id;
    hostNotifier.state = {hostId1: host1 as Host};

    final host2 = SimObjectType.host.createSimObject(
      posX: 200,
      posY: 200,
      name: 'Host_2',
    );

    hostId2 = host2.id;
    hostNotifier.state = {...hostNotifier.state, hostId2: host2 as Host};

    final connection = SimObjectType.connection.createSimObject(
      conAId: hostId1,
      conBId: hostId2,
      conAmac: hostNotifier.state[hostId1]!.macAddress,
      conBmac: hostNotifier.state[hostId2]!.macAddress,
    );

    conId = connection.id;
    connectionNotifier.state = {conId: connection as Connection};

    final message = SimObjectType.message.createSimObject(
      srcId: hostId1,
      dstId: hostId2,
    );

    messageId = message.id;
    messageNotifier.state = {messageId: message as Message};

    messageNotifier.updateCurrentPlaceId(messageId, hostId1);

    final dataLinkLayer = {
      'src': hostNotifier.state[hostId1]!.macAddress,
      'dst': hostNotifier.state[hostId2]!.macAddress,
      'type': 'IPv4',
    };

    messageNotifier.pushLayer(messageId, dataLinkLayer);
  });

  tearDown(() {
    container.dispose();
  });

  test('receiveMessage and sendMessage should work properly', () {
    final message = messageNotifier.state[messageId]!;

    expect(messageNotifier.state[messageId]!.currentPlaceId, hostId1);

    connectionNotifier.receiveMessage(conId, message);

    expect(messageNotifier.state[messageId]!.currentPlaceId, hostId2);

    messageNotifier.popLayer(messageId);
    final dataLinkLayer = {
      'src': hostNotifier.state[hostId2]!.macAddress,
      'dst': hostNotifier.state[hostId1]!.macAddress,
      'type': 'IPv4',
    };
    messageNotifier.pushLayer(messageId, dataLinkLayer);

    final updatedMessage = messageNotifier.state[messageId]!;

    expect(messageNotifier.state[messageId]!.currentPlaceId, hostId2);

    connectionNotifier.receiveMessage(conId, updatedMessage);

    expect(messageNotifier.state[messageId]!.currentPlaceId, hostId1);
  });
}
