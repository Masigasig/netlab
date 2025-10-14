import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:netlab/simulation/core/enums.dart';
import 'package:netlab/simulation/core/ipv4_address_manager.dart';
import 'package:netlab/simulation/core/validator.dart';
import 'package:netlab/simulation/provider/sim_object_notifiers/sim_object_notifier.dart';
import 'package:netlab/simulation/provider/sim_screen_notifier.dart';

part 'info_panel_field.dart';
part 'info_panel_popup.dart';

part 'connection_info_panel.dart';
part 'host_info_panel.dart';
part 'message_info_panel.dart';
part 'router_info_panel.dart';
part 'switch_info_panel.dart';

class InfoPanel extends ConsumerWidget {
  const InfoPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('InfoPanel Widget Rebuilt');
    final selectedDevice = ref.watch(
      simScreenProvider.select((s) => s.selectedDeviceOnInfo),
    );
    final isOpen = ref.watch(
      simScreenProvider.select((s) => s.isInfoPanelOpen),
    );
    final isPlaying = ref.watch(simScreenProvider.select((s) => s.isPlaying));

    if (selectedDevice.isEmpty || !isOpen) return const SizedBox.shrink();

    final tabConfig = _TabConfig.fromDeviceType(selectedDevice);

    return Positioned(
      top: 60,
      bottom: 60,
      left: 6,
      child: DefaultTabController(
        length: tabConfig.length,
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            width: 250,
            child: Column(
              children: [
                _InfoPanelTabBar(tabConfig),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: TabBarView(children: tabConfig.views),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          ref.read(simScreenProvider.notifier).closeInfoPanel();
                        },
                        child: const Text('Close'),
                      ),
                      TextButton(
                        onPressed: isPlaying
                            ? null
                            : () => _onDelete(ref, selectedDevice),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onDelete(WidgetRef ref, String selectedDevice) {
    if (selectedDevice.startsWith(SimObjectType.host.label)) {
      ref.read(hostProvider(selectedDevice).notifier).removeSelf();
    } else if (selectedDevice.startsWith(SimObjectType.connection.label)) {
      ref.read(connectionProvider(selectedDevice).notifier).removeSelf();
    } else if (selectedDevice.startsWith(SimObjectType.message.label)) {
      ref.read(messageProvider(selectedDevice).notifier).removeSelf();
    } else if (selectedDevice.startsWith(SimObjectType.switch_.label)) {
      ref.read(switchProvider(selectedDevice).notifier).removeSelf();
    } else if (selectedDevice.startsWith(SimObjectType.router.label)) {
      ref.read(routerProvider(selectedDevice).notifier).removeSelf();
    }
  }
}

class _InfoPanelTabBar extends StatelessWidget {
  final _TabConfig config;
  const _InfoPanelTabBar(this.config);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: TabBar(
        indicator: config.length == 1
            ? const BoxDecoration()
            : BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withAlpha(40),
                borderRadius: BorderRadius.circular(16),
              ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: config.length == 1
            ? Theme.of(context).colorScheme.onSurface
            : Theme.of(context).colorScheme.secondary,
        unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        dividerColor: Theme.of(context).colorScheme.secondary,
        dividerHeight: 1,
        tabs: config.tabs,
      ),
    );
  }
}

class _TabConfig {
  final int length;
  final List<Tab> tabs;
  final List<Widget> views;

  const _TabConfig({
    required this.length,
    required this.tabs,
    required this.views,
  });

  static _TabConfig fromDeviceType(String deviceType) {
    if (deviceType.startsWith(SimObjectType.connection.label)) {
      return const _TabConfig(
        length: 1,
        tabs: [Tab(child: Text('Info', textAlign: TextAlign.center))],
        views: [_ConnectionInfoTabView()],
      );
    } else if (deviceType.startsWith(SimObjectType.message.label)) {
      return const _TabConfig(
        length: 1,
        tabs: [Tab(child: Text('Info', textAlign: TextAlign.center))],
        views: [_MessageInfoTabView()],
      );
    } else if (deviceType.startsWith(SimObjectType.router.label)) {
      return const _TabConfig(
        length: 3,
        tabs: [
          Tab(child: Text('Info', textAlign: TextAlign.center)),
          Tab(child: Text('ARP Table', textAlign: TextAlign.center)),
          Tab(child: Text('Routing Table', textAlign: TextAlign.center)),
        ],
        views: [
          _RouterInfoTabView(),
          _RouterArpTableTabView(),
          _RoutingTableTabView(),
        ],
      );
    } else if (deviceType.startsWith(SimObjectType.switch_.label)) {
      return const _TabConfig(
        length: 2,
        tabs: [
          Tab(child: Text('Info', textAlign: TextAlign.center)),
          Tab(child: Text('Mac Table', textAlign: TextAlign.center)),
        ],
        views: [_SwitchInfoTabView(), _MacTableTabView()],
      );
    } else {
      return const _TabConfig(
        length: 2,
        tabs: [
          Tab(child: Text('Info', textAlign: TextAlign.center)),
          Tab(child: Text('ARP Table', textAlign: TextAlign.center)),
        ],
        views: [_HostInfoTabView(), _HostArpTableTabView()],
      );
    }
  }
}
