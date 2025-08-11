import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/simulation/sim_objects/sim_object.dart';
import 'package:netlab/simulation/sim_screen_state.dart';

void main() {
  late ProviderContainer container;
  late HostNotifier hostNotifier;
  late ConnectionNotifier connectionNotifier;
  // late MessageNotifier messageNotifier;

  late String hostId;
  late String hostId2;
  late String conId;
  // late String msgId;

  setUp(() {
    container = ProviderContainer();
    final host =
        SimObjectType.host.createSimObject(posX: 100, posY: 100, name: 'Host_1')
            as Host;

    hostId = host.id;
    container.read(hostMapProvider.notifier).addSimObject(host);
    hostNotifier = container.read(hostProvider(hostId).notifier);

    final host2 =
        SimObjectType.host.createSimObject(posX: 200, posY: 200, name: 'Host_2')
            as Host;

    hostId2 = host2.id;
    container.read(hostMapProvider.notifier).addSimObject(host2);

    final connection =
        SimObjectType.connection.createSimObject(
              conAId: hostId,
              conBId: host2.id,
              conAmac: hostNotifier.state.macAddress,
              conBmac: host2.macAddress,
            )
            as Connection;

    conId = connection.id;
    container.read(connectionMapProvider.notifier).addSimObject(connection);
    connectionNotifier = container.read(connectionProvider(conId).notifier);

    hostNotifier.updateConnectionId(conId);
    hostNotifier.updateIpAddress('192.165.3.13');

    // final message =
    //     SimObjectType.message.createSimObject(srcId: hostId, dstId: host2.id)
    //         as Message;

    // msgId = message.id;
    // container.read(messageMapProvider.notifier).addSimObject(message);
    // messageNotifier = container.read(messageProvider(msgId).notifier);
    // messageNotifier.updateCurrentPlaceId(hostId);
  });

  tearDown(() {
    container.dispose();
  });

  test('updateConnectionId should update ConnectionId', () {
    hostNotifier.updateConnectionId('sdfas');
    expect(hostNotifier.state.connectionId, equals('sdfas'));
  });

  test('updateIpAdress should update IPAddress', () {
    hostNotifier.updateIpAddress('asdf');
    expect(hostNotifier.state.ipAddress, equals('asdf'));
  });

  /* 
  * make the method _updateArp Table and _getMacFromArpTable public to run the test
  test('updateArpTable and getMacFromArpTable should work properly', () {
    expect(hostNotifier.state.arpTable, equals({}));

    hostNotifier.updateArpTable('192.168.3.2', 'someMacAddress');

    expect(
      hostNotifier.state.arpTable,
      equals({'192.168.3.2': 'someMacAddress'}),
    );

    hostNotifier.updateArpTable('192.168.3.32', 'newMac');

    expect(hostNotifier.getMacFromArpTable('192.168.3.32'), equals('newMac'));
    expect(hostNotifier.getMacFromArpTable('asdfe'), equals(''));
    expect(
      hostNotifier.state.arpTable,
      equals({'192.168.3.2': 'someMacAddress', '192.168.3.32': 'newMac'}),
    );
  });

  * make the _sendArpRqst method public to run the test
  test('sendArpRqst should send Arp Request Correct', () {
    hostNotifier.sendArpRqst('192.168.45.32');

    final messageId = container
        .read(messageMapProvider.notifier)
        .state
        .keys
        .first;

    final messageNotifier = container.read(messageProvider(messageId).notifier);

    expect(messageNotifier.state.srcId, equals(hostNotifier.state.id));

    expect(
      messageNotifier.state.dstId,
      equals('${DataLinkLayerType.arp.name} ${OperationType.request.name}'),
    );

    expect(
      messageNotifier.state.currentPlaceId,
      equals(connectionNotifier.state.id),
    );

    expect(
      messageNotifier.state.layerStack,
      equals([
        {
          MessageKey.operation.name: OperationType.request.name,
          MessageKey.senderIp.name: hostNotifier.state.ipAddress,
          MessageKey.targetIp.name: '192.168.45.32',
        },
        {
          MessageKey.source.name: hostNotifier.state.macAddress,
          MessageKey.destination.name: MacAddressManager.broadcastMacAddress,
          MessageKey.type.name: DataLinkLayerType.arp.name,
        },
      ]),
    );
  });
  */
}
