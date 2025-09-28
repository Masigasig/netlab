import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/simulation/core/enums.dart';
import 'package:netlab/simulation/provider/sim_screen_notifier.dart';

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

    if (selectedDevice.isEmpty) return const SizedBox.shrink();

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
            width: 230,
            child: Column(
              children: [
                SizedBox(
                  height: 35,
                  child: TabBar(
                    indicator: tabConfig.length == 1
                        ? const BoxDecoration()
                        : BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.secondary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: tabConfig.length == 1
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.secondary,
                    unselectedLabelColor: Theme.of(
                      context,
                    ).colorScheme.onSurface,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    dividerColor: Theme.of(context).colorScheme.secondary,
                    dividerHeight: 0.5,
                    tabs: tabConfig.tabs,
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: TabBarView(children: tabConfig.views),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 4.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          ref
                              .read(simScreenProvider.notifier)
                              .setSelectedDeviceOnInfo('');
                        },
                        child: const Text('Close'),
                      ),
                      TextButton(
                        onPressed: () {
                          //* TODO: Del function
                        },
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
