part of 'info_panel.dart';

class _RouterInfoTabView extends ConsumerStatefulWidget {
  const _RouterInfoTabView();

  @override
  ConsumerState<_RouterInfoTabView> createState() => _RouterInfoTabViewState();
}

class _RouterInfoTabViewState extends ConsumerState<_RouterInfoTabView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('RouterInfoTabView Rebuilt');

    final selectedDeviceId = ref.watch(
      simScreenProvider.select((s) => s.selectedDeviceOnInfo),
    );
    final name = ref.watch(
      routerProvider(selectedDeviceId).select((r) => r.name),
    );

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoPanelField(
                label: 'Name :',
                value: name,
                validator: Validator.validateName,
                onSave: (value) => ref
                    .read(routerProvider(selectedDeviceId).notifier)
                    .updateName(value),
              ),

              Consumer(
                builder: (context, ref, child) {
                  final ipAddress = ref.watch(
                    routerProvider(
                      selectedDeviceId,
                    ).select((r) => r.eth0IpAddress),
                  );

                  final subnetMask = ref.watch(
                    routerProvider(
                      selectedDeviceId,
                    ).select((r) => r.eth0SubnetMask),
                  );

                  final macAddress = ref.watch(
                    routerProvider(
                      selectedDeviceId,
                    ).select((r) => r.eth0MacAddress),
                  );

                  return _RouterInterfaceField(
                    title: Eth.eth0.label,
                    ipAddress: ipAddress,
                    subnetMask: subnetMask,
                    macAddress: macAddress,
                    onSave: (ipAddress, subnetMask) {
                      ref
                          .read(routerProvider(selectedDeviceId).notifier)
                          .updateIpByEthName(Eth.eth0.name, ipAddress);
                      ref
                          .read(routerProvider(selectedDeviceId).notifier)
                          .updateSubnetMaskByEthName(Eth.eth0.name, subnetMask);

                      ref
                          .read(routerProvider(selectedDeviceId).notifier)
                          .updateOrAddRoutingEntry(
                            type: RouteType.directed.label,
                            subnetMask: subnetMask,
                            ipAddress: ipAddress,
                            targetInterface: Eth.eth0.name,
                          );
                    },
                  );
                },
              ),

              Consumer(
                builder: (context, ref, child) {
                  final ipAddress = ref.watch(
                    routerProvider(
                      selectedDeviceId,
                    ).select((r) => r.eth1IpAddress),
                  );

                  final subnetMask = ref.watch(
                    routerProvider(
                      selectedDeviceId,
                    ).select((r) => r.eth1SubnetMask),
                  );

                  final macAddress = ref.watch(
                    routerProvider(
                      selectedDeviceId,
                    ).select((r) => r.eth1MacAddress),
                  );

                  return _RouterInterfaceField(
                    title: Eth.eth1.label,
                    ipAddress: ipAddress,
                    subnetMask: subnetMask,
                    macAddress: macAddress,
                    onSave: (ipAddress, subnetMask) {
                      ref
                          .read(routerProvider(selectedDeviceId).notifier)
                          .updateIpByEthName(Eth.eth1.name, ipAddress);
                      ref
                          .read(routerProvider(selectedDeviceId).notifier)
                          .updateSubnetMaskByEthName(Eth.eth1.name, subnetMask);

                      ref
                          .read(routerProvider(selectedDeviceId).notifier)
                          .updateOrAddRoutingEntry(
                            type: RouteType.directed.label,
                            subnetMask: subnetMask,
                            ipAddress: ipAddress,
                            targetInterface: Eth.eth1.name,
                          );
                    },
                  );
                },
              ),

              Consumer(
                builder: (context, ref, child) {
                  final ipAddress = ref.watch(
                    routerProvider(
                      selectedDeviceId,
                    ).select((r) => r.eth2IpAddress),
                  );

                  final subnetMask = ref.watch(
                    routerProvider(
                      selectedDeviceId,
                    ).select((r) => r.eth2SubnetMask),
                  );

                  final macAddress = ref.watch(
                    routerProvider(
                      selectedDeviceId,
                    ).select((r) => r.eth2MacAddress),
                  );

                  return _RouterInterfaceField(
                    title: Eth.eth2.label,
                    ipAddress: ipAddress,
                    subnetMask: subnetMask,
                    macAddress: macAddress,
                    onSave: (ipAddress, subnetMask) {
                      ref
                          .read(routerProvider(selectedDeviceId).notifier)
                          .updateIpByEthName(Eth.eth2.name, ipAddress);
                      ref
                          .read(routerProvider(selectedDeviceId).notifier)
                          .updateSubnetMaskByEthName(Eth.eth2.name, subnetMask);

                      ref
                          .read(routerProvider(selectedDeviceId).notifier)
                          .updateOrAddRoutingEntry(
                            type: RouteType.directed.label,
                            subnetMask: subnetMask,
                            ipAddress: ipAddress,
                            targetInterface: Eth.eth2.name,
                          );
                    },
                  );
                },
              ),

              Consumer(
                builder: (context, ref, child) {
                  final ipAddress = ref.watch(
                    routerProvider(
                      selectedDeviceId,
                    ).select((r) => r.eth3IpAddress),
                  );

                  final subnetMask = ref.watch(
                    routerProvider(
                      selectedDeviceId,
                    ).select((r) => r.eth3SubnetMask),
                  );

                  final macAddress = ref.watch(
                    routerProvider(
                      selectedDeviceId,
                    ).select((r) => r.eth3MacAddress),
                  );

                  return _RouterInterfaceField(
                    title: Eth.eth3.label,
                    ipAddress: ipAddress,
                    subnetMask: subnetMask,
                    macAddress: macAddress,
                    onSave: (ipAddress, subnetMask) {
                      ref
                          .read(routerProvider(selectedDeviceId).notifier)
                          .updateIpByEthName(Eth.eth3.name, ipAddress);
                      ref
                          .read(routerProvider(selectedDeviceId).notifier)
                          .updateSubnetMaskByEthName(Eth.eth3.name, subnetMask);

                      ref
                          .read(routerProvider(selectedDeviceId).notifier)
                          .updateOrAddRoutingEntry(
                            type: RouteType.directed.label,
                            subnetMask: subnetMask,
                            ipAddress: ipAddress,
                            targetInterface: Eth.eth3.name,
                          );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RouterArpTableTabView extends ConsumerStatefulWidget {
  const _RouterArpTableTabView();

  @override
  ConsumerState<_RouterArpTableTabView> createState() =>
      _RouterArpTableTabViewState();
}

class _RouterArpTableTabViewState
    extends ConsumerState<_RouterArpTableTabView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Arp Table Rebuilt');
    final selectedDeviceId = ref.watch(
      simScreenProvider.select((s) => s.selectedDeviceOnInfo),
    );

    final arpTable = ref.watch(
      routerProvider(selectedDeviceId).select((r) => r.arpTable),
    );

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              DataTable(
                headingRowHeight: 35,
                dataRowMinHeight: 30,
                dataRowMaxHeight: 30,
                horizontalMargin: 0,
                dividerThickness: 0.01,
                columnSpacing: 0,
                headingTextStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                dataTextStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w100,
                ),
                border: TableBorder(
                  horizontalInside: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 0.5,
                  ),
                ),
                columns: const [
                  DataColumn(
                    columnWidth: FixedColumnWidth(100),
                    headingRowAlignment: MainAxisAlignment.center,
                    label: Center(child: Text("IP Address")),
                  ),
                  DataColumn(
                    columnWidth: FixedColumnWidth(100),
                    headingRowAlignment: MainAxisAlignment.center,
                    label: Center(child: Text("MAC Address")),
                  ),
                ],
                rows: arpTable.entries.map((entry) {
                  return DataRow(
                    cells: [
                      DataCell(Center(child: Text(entry.key))),
                      DataCell(Center(child: Text(entry.value))),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoutingTableTabView extends ConsumerStatefulWidget {
  const _RoutingTableTabView();

  @override
  ConsumerState<_RoutingTableTabView> createState() =>
      _RoutingTableTabViewState();
}

class _RoutingTableTabViewState extends ConsumerState<_RoutingTableTabView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Routing Table Rebuilt');
    final isPlaying = ref.watch(simScreenProvider.select((s) => s.isPlaying));

    final selectedDeviceId = ref.watch(
      simScreenProvider.select((s) => s.selectedDeviceOnInfo),
    );

    final routingTable = ref.watch(
      routerProvider(selectedDeviceId).select((r) => r.routingTable),
    );

    //* Sorted: Directed -> Static -> Dynamic
    final sortedEntries = routingTable.entries.toList()
      ..sort((a, b) {
        final typeOrder = {
          RouteType.directed.label: 0,
          RouteType.static_.label: 1,
          RouteType.dynamic_.label: 2,
        };
        final typeA = a.value['type'] ?? '';
        final typeB = b.value['type'] ?? '';
        return (typeOrder[typeA] ?? 99).compareTo(typeOrder[typeB] ?? 99);
      });

    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  DataTable(
                    headingRowHeight: 35,
                    dataRowMinHeight: 30,
                    dataRowMaxHeight: 30,
                    horizontalMargin: 0,
                    dividerThickness: 0.01,
                    columnSpacing: 2,
                    headingTextStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    dataTextStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w100,
                    ),
                    border: TableBorder(
                      horizontalInside: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 0.5,
                      ),
                    ),
                    columns: const [
                      DataColumn(
                        columnWidth: FixedColumnWidth(40),
                        headingRowAlignment: MainAxisAlignment.center,
                        label: Center(child: Text("Type")),
                      ),
                      DataColumn(
                        columnWidth: FixedColumnWidth(90),
                        headingRowAlignment: MainAxisAlignment.center,
                        label: Center(child: Text("Network Id")),
                      ),
                      DataColumn(
                        columnWidth: FixedColumnWidth(75),
                        headingRowAlignment: MainAxisAlignment.center,
                        label: Center(child: Text("Interface")),
                      ),
                      DataColumn(
                        columnWidth: FixedColumnWidth(25),
                        headingRowAlignment: MainAxisAlignment.center,
                        label: Center(child: Text("")),
                      ),
                    ],
                    rows: sortedEntries.map((entry) {
                      final network = entry.key;
                      final details = entry.value;
                      return DataRow(
                        cells: [
                          DataCell(Center(child: Text(details['type']!))),
                          DataCell(Center(child: Text(network))),
                          DataCell(Center(child: Text(details['interface']!))),

                          DataCell(
                            Center(
                              child: IconButton(
                                onPressed: isPlaying
                                    ? null
                                    : () {
                                        if (details['type'] ==
                                            RouteType.directed.label) {
                                          ref
                                              .read(
                                                routerProvider(
                                                  selectedDeviceId,
                                                ).notifier,
                                              )
                                              .removeRoute(network);
                                          if (details['interface'] ==
                                              Eth.eth0.name) {
                                            ref
                                                .read(
                                                  routerProvider(
                                                    selectedDeviceId,
                                                  ).notifier,
                                                )
                                                .updateIpByEthName(
                                                  Eth.eth0.name,
                                                  '',
                                                );
                                          }
                                          if (details['interface'] ==
                                              Eth.eth1.name) {
                                            ref
                                                .read(
                                                  routerProvider(
                                                    selectedDeviceId,
                                                  ).notifier,
                                                )
                                                .updateIpByEthName(
                                                  Eth.eth1.name,
                                                  '',
                                                );
                                          }
                                          if (details['interface'] ==
                                              Eth.eth2.name) {
                                            ref
                                                .read(
                                                  routerProvider(
                                                    selectedDeviceId,
                                                  ).notifier,
                                                )
                                                .updateIpByEthName(
                                                  Eth.eth2.name,
                                                  '',
                                                );
                                          }
                                          if (details['interface'] ==
                                              Eth.eth3.name) {
                                            ref
                                                .read(
                                                  routerProvider(
                                                    selectedDeviceId,
                                                  ).notifier,
                                                )
                                                .updateIpByEthName(
                                                  Eth.eth3.name,
                                                  '',
                                                );
                                          }
                                        } else {
                                          ref
                                              .read(
                                                routerProvider(
                                                  selectedDeviceId,
                                                ).notifier,
                                              )
                                              .removeRoute(network);
                                        }
                                      },
                                padding: EdgeInsets.zero,
                                icon: HugeIcon(
                                  icon: HugeIcons.strokeRoundedCancel01,
                                  size: 16,
                                  color: isPlaying ? Colors.grey : Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 12,
          left: 0,
          right: 0,
          child: Center(
            child: ElevatedButton.icon(
              onPressed: isPlaying
                  ? null
                  : () {
                      showDialog(
                        context: context,
                        builder: (context) => _AddStaticRouteDialog(
                          onSave: (networkId, subnetMask, interface_) {
                            ref
                                .read(routerProvider(selectedDeviceId).notifier)
                                .addStaticRoute(
                                  networkId: networkId + subnetMask,
                                  interface_: interface_,
                                );
                          },
                        ),
                      );
                    },
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedPropertyAdd,
                size: 16,
              ),
              label: const Text(
                'Add Static Route',
                style: TextStyle(fontSize: 10),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
