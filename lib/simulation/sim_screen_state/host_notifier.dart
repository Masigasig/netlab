part of 'sim_object_notifier.dart';

final hostMapProvider =
    StateNotifierProvider<HostMapNotifier, Map<String, Host>>(
      (ref) => HostMapNotifier(),
    );

final hostProvider = StateNotifierProvider.family
    .autoDispose<HostNotifier, Host, String>(
      (ref, id) => HostNotifier(ref, id),
    );

class HostMapNotifier extends DeviceMapNotifier<Host> {}

class HostNotifier extends DeviceNotifier<Host> {
  HostNotifier(Ref ref, String id) : super(ref.read(hostMapProvider)[id]!, ref);

  // void receiveMessage(String hostId, String messageId) {
  //   messageNotifier.updateCurrentPlaceId(messageId, hostId);
  //   final dataLinkLayer = messageNotifier.popLayer(messageId);

  //   switch (dataLinkLayer['type']) {
  //     case DataLinkLayerType.arp:
  //       processArpMsg(hostId, messageId, dataLinkLayer);
  //   }
  // }

  // void processArpMsg(
  //   String hostId,
  //   String messageId,
  //   Map<String, dynamic> dataLinkLayer,
  // ) {
  //   final arpLayer = messageNotifier.popLayer(messageId);

  //   updateArpTable(hostId, arpLayer['senderIp'], dataLinkLayer['source']);

  //   if (arpLayer['operation'] == OperationType.request) {
  //     if (arpLayer['targetIp'] == state[hostId]!.ipAddress) {
  //       messageNotifier.dropMessage(messageId);
  //       final message = SimObjectType.message.createSimObject(
  //         srcId: hostId,
  //         dstId: '${DataLinkLayerType.arp.name} ${OperationType.reply.name}',
  //       );
  //       messageNotifier.addSimObject(message as Message);
  //       messageNotifier.updateCurrentPlaceId(message.id, hostId);

  //       final arpLayerReply = {
  //         'operation': OperationType.reply,
  //         'senderIp': state[hostId]!.ipAddress,
  //       };

  //       final dataLinkLayer = {
  //         'source': state[hostId]!.macAddress,
  //         'destination': getMacFromArpTable(hostId, arpLayer['senderIp']),
  //         'type': DataLinkLayerType.arp,
  //       };

  //       messageNotifier.pushLayer(message.id, arpLayerReply);
  //       messageNotifier.pushLayer(message.id, dataLinkLayer);
  //       sendToConnection(state[hostId]!.connectionId, message.id);
  //     } else {
  //       messageNotifier.dropMessage(messageId);
  //     }
  //   }
  // }

  // void sendArpRqst(String hostId, String targetIp) {
  //   final message = SimObjectType.message.createSimObject(
  //     srcId: hostId,
  //     dstId: '${DataLinkLayerType.arp.name} ${OperationType.request.name}',
  //   );
  //   messageNotifier.addSimObject(message as Message);
  //   messageNotifier.updateCurrentPlaceId(message.id, hostId);

  //   final arpLayer = {
  //     'operation': OperationType.request,
  //     'senderIp': state[hostId]!.ipAddress,
  //     'targetIp': targetIp,
  //   };

  //   final dataLinkLayer = {
  //     'source': state[hostId]!.macAddress,
  //     'destination': MacAddressManager.broadcastMacAddress,
  //     'type': DataLinkLayerType.arp,
  //   };

  //   messageNotifier.pushLayer(message.id, arpLayer);
  //   messageNotifier.pushLayer(message.id, dataLinkLayer);
  //   sendToConnection(state[hostId]!.connectionId, message.id);
  // }

  // void updateArpTable(String hostId, String ipAddress, String macAddress) {
  //   final host = state[hostId]!;

  //   final newArpTable = Map<String, String>.from(host.arpTable);

  //   newArpTable[ipAddress] = macAddress;

  //   state = {...state, hostId: host.copyWith(arpTable: newArpTable)};
  // }

  // String getMacFromArpTable(String hostId, String ipAddress) {
  //   return state[hostId]!.arpTable[ipAddress]!;
  // }
}

final hostWidgetProvider =
    StateNotifierProvider<HostWidgetNotifier, Map<String, HostWidget>>(
      (ref) => HostWidgetNotifier(),
    );

class HostWidgetNotifier extends DeviceWidgetNotifier<HostWidget> {}
