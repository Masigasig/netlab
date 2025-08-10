part of 'sim_object_notifier.dart';

final hostProvider = StateNotifierProvider.family
    .autoDispose<HostNotifier, Host, String>(
      (ref, id) => HostNotifier(ref, id),
    );

class HostNotifier extends DeviceNotifier<Host> {
  HostNotifier(Ref ref, String id) : super(ref.read(hostMapProvider)[id]!, ref);

  void receiveMessage(String messageId) {
    messageNotifier(messageId).updateCurrentPlaceId(state.id);
    final dataLinkLayer = messageNotifier(messageId).popLayer();

    final type = dataLinkLayer[MessageKey.type.name];

    if (type == DataLinkLayerType.arp.name) {
      processArpMsg(messageId, dataLinkLayer);
    }
  }

  void processArpMsg(String messageId, Map<String, String> dataLinkLayer) {
    final arpLayer = messageNotifier(messageId).popLayer();

    updateArpTable(
      arpLayer[MessageKey.senderIp.name]!,
      dataLinkLayer[MessageKey.source.name]!,
    );

    if (arpLayer[MessageKey.operation.name] == OperationType.request.name) {
      if (arpLayer[MessageKey.targetIp.name] == state.ipAddress) {
        messageNotifier(messageId).dropMessage();
        final message =
            SimObjectType.message.createSimObject(
                  srcId: state.id,
                  dstId:
                      '${DataLinkLayerType.arp.name} ${OperationType.reply.name}',
                )
                as Message;
        messageMapNotifier.addSimObject(message);
        messageNotifier(message.id).updateCurrentPlaceId(state.id);

        final newArpLayer = {
          MessageKey.operation.name: OperationType.reply.name,
          MessageKey.senderIp.name: state.ipAddress,
        };

        messageNotifier(message.id).pushLayer(newArpLayer);

        final newDataLinkLayer = {
          MessageKey.source.name: state.macAddress,
          MessageKey.destination.name: dataLinkLayer[MessageKey.source.name]!,
        };

        messageNotifier(message.id).pushLayer(newDataLinkLayer);
        sendMessageToConnection(state.connectionId, message.id);
      } else {
        messageNotifier(messageId).dropMessage();
      }
    } else if (arpLayer[MessageKey.operation.name] ==
        OperationType.reply.name) {
      messageNotifier(messageId).dropMessage(); //TODO: add some success notif
    } else {
      messageNotifier(messageId).dropMessage();
    }
  }

  void sendArpRqst(String targetIp) {
    final message =
        SimObjectType.message.createSimObject(
              srcId: state.id,
              dstId:
                  '${DataLinkLayerType.arp.name} ${OperationType.request.name}',
            )
            as Message;

    messageMapNotifier.addSimObject(message);
    messageNotifier(message.id).updateCurrentPlaceId(state.id);

    final arpLayer = {
      MessageKey.operation.name: OperationType.request.name,
      MessageKey.senderIp.name: state.ipAddress,
      MessageKey.targetIp.name: targetIp,
    };

    messageNotifier(message.id).pushLayer(arpLayer);

    final dataLinkLayer = {
      MessageKey.source.name: state.macAddress,
      MessageKey.destination.name: MacAddressManager.broadcastMacAddress,
      MessageKey.type.name: DataLinkLayerType.arp.name,
    };

    messageNotifier(message.id).pushLayer(dataLinkLayer);
    sendMessageToConnection(state.connectionId, message.id);
  }

  void updateArpTable(String ipAddress, String macAddress) {
    final newArpTable = Map<String, String>.from(state.arpTable);

    newArpTable[ipAddress] = macAddress;

    state = state.copyWith(arpTable: newArpTable);
  }

  String getMacFromArpTable(String ipAddress) {
    return state.arpTable[ipAddress] ?? '';
  }
}

final hostMapProvider =
    StateNotifierProvider<HostMapNotifier, Map<String, Host>>(
      (ref) => HostMapNotifier(),
    );

class HostMapNotifier extends DeviceMapNotifier<Host> {}

final hostWidgetProvider =
    StateNotifierProvider<HostWidgetNotifier, Map<String, HostWidget>>(
      (ref) => HostWidgetNotifier(),
    );

class HostWidgetNotifier extends DeviceWidgetNotifier<HostWidget> {}
