import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netlab/simulation/model/sim_screen.dart';

final simScreenProvider = NotifierProvider<SimScreenNotifier, SimScreen>(
  SimScreenNotifier.new,
);

class SimScreenNotifier extends Notifier<SimScreen> {
  @override
  SimScreen build() {
    return const SimScreen();
  }

  void playSimulation() {
    state = state.copyWith(
      isPlaying: true,
      isDevicePanelOpen: false,
      isLogPanelOpen: false,
      isConnectionModeOn: false,
      isMessageModeOn: false,
      selectedDeviceOnConn: '',
      selectedDeviceOnInfo: '',
    );
  }

  void stopSimulation() {
    state = state.copyWith(isPlaying: false);
  }

  void openDevicePanel() {
    state = state.copyWith(isDevicePanelOpen: true);
  }

  void closeDevicePanel() {
    state = state.copyWith(isDevicePanelOpen: false);
  }

  void openLogPanel() {
    state = state.copyWith(isLogPanelOpen: true);
  }

  void closeLogPanel() {
    state = state.copyWith(isLogPanelOpen: false);
  }

  void toggleConnectionMode() {
    state = state.copyWith(isConnectionModeOn: !state.isConnectionModeOn);
  }

  void toggleMessageMode() {
    state = state.copyWith(isMessageModeOn: !state.isMessageModeOn);
  }
}
