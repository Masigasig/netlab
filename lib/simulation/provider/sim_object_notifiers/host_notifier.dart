part of 'sim_object_notifier.dart';

final hostProvider = NotifierProvider.family<HostNotifier, Host, String>(
  HostNotifier.new,
);

final hostMapProvider = NotifierProvider<HostMapNotifier, Map<String, Host>>(
  HostMapNotifier.new,
);

final hostWidgetsProvider =
    NotifierProvider<HostWidgetsNotifier, Map<String, HostWidget>>(
      HostWidgetsNotifier.new,
    );

class HostNotifier extends DeviceNotifier<Host> {
  final String arg;
  HostNotifier(this.arg);

  @override
  Host build() {
    return ref.read(hostMapProvider)[arg]!;
  }

  @override
  List<Map<String, String>> getAllConnectionInfo() {
    return [
      {
        ConnInfoKey.name.name: Eth.eth0.name,
        ConnInfoKey.conId.name: state.connectionId,
      },
    ];
  }

  void updateIpAddress(String ipAddress) =>
      state = state.copyWith(ipAddress: ipAddress);

  void updateSubnetMask(String subnetMask) =>
      state = state.copyWith(subnetMask: subnetMask);

  void updateDefaultGateway(String defaultGateway) =>
      state = state.copyWith(defaultGateway: defaultGateway);

  void updateConnectionId(String connectionId) =>
      state = state.copyWith(connectionId: connectionId);

  // void _updateArpTable(String ipAddress, String macAddress) {
  //   final newArpTable = Map<String, String>.from(state.arpTable);
  //   newArpTable[ipAddress] = macAddress;
  //   state = state.copyWith(arpTable: newArpTable);
  // }

  void enqueueMessage(String messageId) {
    final newMessageIds = List<String>.from(state.messageIds)..add(messageId);
    state = state.copyWith(messageIds: newMessageIds);
  }

  // String _dequeueMessage() {
  //   if (state.messageIds.isEmpty) return '';
  //   final messageIds = List<String>.from(state.messageIds);
  //   final messageId = messageIds.removeAt(0);
  //   state = state.copyWith(messageIds: messageIds);
  //   return messageId;
  // }
}

class HostMapNotifier extends DeviceMapNotifier<Host> {}

class HostWidgetsNotifier extends DeviceWidgetsNotifier<HostWidget> {}
