import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/simulation/sim_objects/sim_object.dart';
import 'package:netlab/simulation/sim_screen_state.dart';

void main() {
  late ProviderContainer container;
  late HostNotifier hostNotifier;
  late HostNotifier hostNotifier2;
  late HostNotifier hostNotifier3;

  late String hostId;
  late String hostId2;
  late String hostId3;
  late String conId;

  setUp(() {
    container = ProviderContainer();
    final host =
        SimObjectType.host.createSimObject(posX: 100, posY: 100, name: 'Host_1')
            as Host;

    hostId = host.id;
    container.read(hostMapProvider.notifier).addSimObject(host);
    hostNotifier = container.read(hostProvider(hostId).notifier);
    hostNotifier.updateIpAddress('192.165.3.13');

    final host2 =
        SimObjectType.host.createSimObject(posX: 200, posY: 200, name: 'Host_2')
            as Host;

    hostId2 = host2.id;
    container.read(hostMapProvider.notifier).addSimObject(host2);
    hostNotifier2 = container.read(hostProvider(hostId2).notifier);
    hostNotifier2.updateIpAddress('192.165.3.19');

    final host3 =
        SimObjectType.host.createSimObject(posX: 200, posY: 200, name: 'Host_2')
            as Host;

    hostId3 = host3.id;
    container.read(hostMapProvider.notifier).addSimObject(host3);
    hostNotifier3 = container.read(hostProvider(hostId3).notifier);
    hostNotifier3.updateIpAddress('192.165.3.32');

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
    hostNotifier.updateConnectionId(conId);
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

  group('reciveMessage and processArpMsg', () {
    late String arpReqMsgId;
    late MessageNotifier arpReqNotifier;
    late String arpReplyMsgId;
    late MessageNotifier arpReplyNotifier;

    setUp(() {
      final arpReqMessage =
          SimObjectType.message.createSimObject(
                srcId: hostId2,
                dstId:
                    '${DataLinkLayerType.arp.name} ${OperationType.request.name}',
              )
              as Message;

      arpReqMsgId = arpReqMessage.id;
      container.read(messageMapProvider.notifier).addSimObject(arpReqMessage);
      arpReqNotifier = container.read(messageProvider(arpReqMsgId).notifier);

      arpReqNotifier.updateCurrentPlaceId(hostId2);

      final arpLayer = {
        MessageKey.operation.name: OperationType.request.name,
        MessageKey.senderIp.name: hostNotifier2.state.ipAddress,
        MessageKey.targetIp.name: hostNotifier.state.ipAddress,
      };

      arpReqNotifier.pushLayer(arpLayer);

      final dataLinkLayer = {
        MessageKey.source.name: hostNotifier2.state.macAddress,
        MessageKey.destination.name: MacAddressManager.broadcastMacAddress,
        MessageKey.type.name: DataLinkLayerType.arp.name,
      };

      arpReqNotifier.pushLayer(dataLinkLayer);

      final arpReplyMessage =
          SimObjectType.message.createSimObject(
                srcId: hostId,
                dstId:
                    '${DataLinkLayerType.arp.name} ${OperationType.reply.name}',
              )
              as Message;

      arpReplyMsgId = arpReplyMessage.id;
      container.read(messageMapProvider.notifier).addSimObject(arpReplyMessage);
      arpReplyNotifier = container.read(
        messageProvider(arpReplyMsgId).notifier,
      );
      arpReqNotifier.updateCurrentPlaceId(hostId);

      final newArpLayer = {
        MessageKey.operation.name: OperationType.reply.name,
        MessageKey.senderIp.name: hostNotifier.state.ipAddress,
        MessageKey.targetIp.name: hostNotifier2.state.ipAddress,
      };

      arpReplyNotifier.pushLayer(newArpLayer);

      final newDataLinkLayer = {
        MessageKey.source.name: hostNotifier.state.macAddress,
        MessageKey.destination.name: hostNotifier3.state.macAddress,
        MessageKey.type.name: DataLinkLayerType.arp.name,
      };

      arpReplyNotifier.pushLayer(newDataLinkLayer);
    });

    test('Recieve ARP Req Message and Send an ARP Reply', () {
      hostNotifier.receiveMessage(arpReqMsgId);

      expect(
        hostNotifier.state.arpTable,
        equals({hostNotifier2.state.ipAddress: hostNotifier2.state.macAddress}),
      );

      expect(
        container.read(messageMapProvider.notifier).state.length,
        equals(2),
      );

      final arpReplyId = container
          .read(messageMapProvider.notifier)
          .state
          .keys
          .last;
      final arpReplyNotifier = container.read(
        messageProvider(arpReplyId).notifier,
      );

      expect(arpReplyNotifier.state.currentPlaceId, equals(conId));
      expect(
        arpReplyNotifier.state.layerStack,
        equals([
          {
            MessageKey.operation.name: OperationType.reply.name,
            MessageKey.senderIp.name: hostNotifier.state.ipAddress,
            MessageKey.targetIp.name: hostNotifier2.state.ipAddress,
          },
          {
            MessageKey.source.name: hostNotifier.state.macAddress,
            MessageKey.destination.name: hostNotifier2.state.macAddress,
            MessageKey.type.name: DataLinkLayerType.arp.name,
          },
        ]),
      );
    });

    test('Recieve ARP Req Message and Drop ', () {
      hostNotifier3.receiveMessage(arpReqMsgId);

      expect(
        hostNotifier3.state.arpTable,
        equals({hostNotifier2.state.ipAddress: hostNotifier2.state.macAddress}),
      );

      expect(
        container.read(messageMapProvider.notifier).state.length,
        equals(1),
      );
    });

    test('Recieve ARP Reply Message and Drop ', () {
      hostNotifier3.receiveMessage(arpReplyMsgId);

      expect(
        hostNotifier3.state.arpTable,
        equals({hostNotifier.state.ipAddress: hostNotifier.state.macAddress}),
      );

      expect(
        container.read(messageMapProvider.notifier).state.length,
        equals(1),
      );
    });
  });

  /* 
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
      equals(conId),
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
  */
}
