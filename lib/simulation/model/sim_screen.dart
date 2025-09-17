class SimScreen {
  final bool isPlaying;
  final bool isWireModeOn;
  final bool isMessageModeOn;
  final bool isDevicePanelOpen;
  final bool isLogPanelOpen;
  final String selectedDeviceOnConn;
  final String selectedDeviceOnInfo;

  const SimScreen({
    this.isPlaying = false,
    this.isWireModeOn = false,
    this.isMessageModeOn = false,
    this.isDevicePanelOpen = false,
    this.isLogPanelOpen = false,
    this.selectedDeviceOnConn = '',
    this.selectedDeviceOnInfo = '',
  });

  SimScreen copyWith({
    bool? isPlaying,
    bool? isWireModeOn,
    bool? isMessageModeOn,
    bool? isDevicePanelOpen,
    bool? isLogPanelOpen,
    String? selectedDeviceOnConn,
    String? selectedDeviceOnInfo,
  }) {
    return SimScreen(
      isPlaying: isPlaying ?? this.isPlaying,
      isWireModeOn: isWireModeOn ?? this.isWireModeOn,
      isMessageModeOn: isMessageModeOn ?? this.isMessageModeOn,
      isDevicePanelOpen: isDevicePanelOpen ?? this.isDevicePanelOpen,
      isLogPanelOpen: isLogPanelOpen ?? this.isLogPanelOpen,
      selectedDeviceOnConn: selectedDeviceOnConn ?? this.selectedDeviceOnConn,
      selectedDeviceOnInfo: selectedDeviceOnInfo ?? this.selectedDeviceOnInfo,
    );
  }
}
