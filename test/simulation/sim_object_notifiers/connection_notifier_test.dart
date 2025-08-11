import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netlab/simulation/sim_objects/sim_object.dart';

import 'package:netlab/simulation/sim_screen_state.dart';

void main() {
  late ProviderContainer container;
  late HostNotifier host1Notifier;
  late HostNotifier host2Notifier;
  late ConnectionNotifier connectionNotifier;
  late MessageNotifier messageNotifier;

  late String host1Id;
  late String host2Id;
  late String conId;
  late String messageId;

  setUp(() {
    container = ProviderContainer();
    final host1 =
        SimObjectType.host.createSimObject(posX: 100, posY: 100, name: 'Host_1')
            as Host;

    host1Id = host1.id;
    container.read(hostMapProvider.notifier).addSimObject(host1);
    host1Notifier = container.read(hostProvider(host1Id).notifier);

    final host2 =
        SimObjectType.host.createSimObject(posX: 200, posY: 200, name: 'Host_2')
            as Host;

    host2Id = host2.id;
    container.read(hostMapProvider.notifier).addSimObject(host2);
    host2Notifier = container.read(hostProvider(host2Id).notifier);

    final connection =
        SimObjectType.connection.createSimObject(
              conAId: host1Id,
              conBId: host2Id,
              conAmac: host1Notifier.state.macAddress,
              conBmac: host2Notifier.state.macAddress,
            )
            as Connection;

    conId = connection.id;
    container.read(connectionMapProvider.notifier).addSimObject(connection);
    connectionNotifier = container.read(connectionProvider(conId).notifier);

    final message =
        SimObjectType.message.createSimObject(srcId: host1Id, dstId: host2Id)
            as Message;

    messageId = message.id;
    container.read(messageMapProvider.notifier).addSimObject(message);
    messageNotifier = container.read(messageProvider(messageId).notifier);

    messageNotifier.updateCurrentPlaceId(host1Id);

    final dataLinkLayer = {
      MessageKey.source.name: host1Notifier.state.macAddress,
      MessageKey.destination.name: host2Notifier.state.macAddress,
      MessageKey.type.name: DataLinkLayerType.ipv4.name,
    };

    messageNotifier.pushLayer(dataLinkLayer);
  });

  tearDown(() {
    container.dispose();
  });

  test('receiveMessage and sendMessage should work properly', () {
    expect(messageNotifier.state.currentPlaceId, equals(host1Id));

    connectionNotifier.receiveMessage(messageId);

    expect(messageNotifier.state.currentPlaceId, equals(conId));

    connectionNotifier.sendMessage(messageId);

    expect(messageNotifier.state.currentPlaceId, equals(host2Id));

    final dataLinkLayer = {
      MessageKey.source.name: host2Notifier.state.macAddress,
      MessageKey.destination.name: host1Notifier.state.macAddress,
      MessageKey.type.name: DataLinkLayerType.ipv4.name,
    };

    messageNotifier.pushLayer(dataLinkLayer);

    expect(messageNotifier.state.currentPlaceId, equals(host2Id));

    connectionNotifier.receiveMessage(messageId);

    expect(messageNotifier.state.currentPlaceId, equals(conId));

    connectionNotifier.sendMessage(messageId);

    expect(messageNotifier.state.currentPlaceId, equals(host1Id));
  });
}
