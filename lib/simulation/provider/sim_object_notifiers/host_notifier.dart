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
  void removeSelf() {
    removeConnectionById(state.connectionId);

    if (state.messageIds.isNotEmpty) {
      final messageIds = state.messageIds;
      for (final messageId in messageIds) {
        ref.read(messageProvider(messageId).notifier).removeSelf();
      }
    }

    ref.read(hostMapProvider.notifier).removeAllState(state.id);
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

  void enqueueMessage(String messageId) {
    final newMessageIds = List<String>.from(state.messageIds)..add(messageId);
    state = state.copyWith(messageIds: newMessageIds);
  }

  void removeMessage(String messageId) {
    final newMessageIds = List<String>.from(state.messageIds)
      ..remove(messageId);
    state = state.copyWith(messageIds: newMessageIds);
  }
}

class HostMapNotifier extends DeviceMapNotifier<Host> {
  HostMapNotifier()
    : super(
        mapProvider: hostMapProvider,
        objectProvider: hostProvider,
        widgetsProvider: hostWidgetsProvider,
      );
}

class HostWidgetsNotifier extends DeviceWidgetsNotifier<HostWidget> {}
