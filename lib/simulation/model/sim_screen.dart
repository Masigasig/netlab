class SimScreen {
  final bool isPlaying;
  final bool isConnectionModeOn;
  final bool isMessageModeOn;
  final bool isDevicePanelOpen;
  final bool isLogPanelOpen;
  final bool isInfoPanelOpen;
  final String selectedDeviceOnConn;
  final String selectedDeviceOnInfo;
  final double messageSpeed;
  final double arpReqTimeout;

  const SimScreen({
    this.isPlaying = false,
    this.isConnectionModeOn = false,
    this.isMessageModeOn = false,
    this.isDevicePanelOpen = false,
    this.isLogPanelOpen = false,
    this.isInfoPanelOpen = false,
    this.selectedDeviceOnConn = '',
    this.selectedDeviceOnInfo = '',
    this.messageSpeed = 300.0,
    this.arpReqTimeout = 30.0,
  });

  SimScreen copyWith({
    bool? isPlaying,
    bool? isConnectionModeOn,
    bool? isMessageModeOn,
    bool? isDevicePanelOpen,
    bool? isLogPanelOpen,
    bool? isInfoPanelOpen,
    String? selectedDeviceOnConn,
    String? selectedDeviceOnInfo,
    double? messageSpeed,
    double? arpReqTimeout,
  }) {
    return SimScreen(
      isPlaying: isPlaying ?? this.isPlaying,
      isConnectionModeOn: isConnectionModeOn ?? this.isConnectionModeOn,
      isMessageModeOn: isMessageModeOn ?? this.isMessageModeOn,
      isDevicePanelOpen: isDevicePanelOpen ?? this.isDevicePanelOpen,
      isLogPanelOpen: isLogPanelOpen ?? this.isLogPanelOpen,
      isInfoPanelOpen: isInfoPanelOpen ?? this.isInfoPanelOpen,
      selectedDeviceOnConn: selectedDeviceOnConn ?? this.selectedDeviceOnConn,
      selectedDeviceOnInfo: selectedDeviceOnInfo ?? this.selectedDeviceOnInfo,
      messageSpeed: messageSpeed ?? this.messageSpeed,
      arpReqTimeout: arpReqTimeout ?? this.arpReqTimeout,
    );
  }
}
