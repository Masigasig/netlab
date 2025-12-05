part of 'info_panel.dart';

class _WirelessHostInfoTabView extends ConsumerStatefulWidget {
  const _WirelessHostInfoTabView();
  @override
  ConsumerState<_WirelessHostInfoTabView> createState() =>
      _WirelessHostInfoTabViewState();
}

class _WirelessHostInfoTabViewState
    extends ConsumerState<_WirelessHostInfoTabView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('WirelessHostInfoTabView Rebuilt');

    //TODO: connection for wirelessHost

    final selectedDeviceId = ref.watch(
      simScreenProvider.select((s) => s.selectedDeviceOnInfo),
    );

    final name = ref.watch(
      wirelessHostProvider(selectedDeviceId).select((w) => w.name),
    );
    final ipAddress = ref.watch(
      wirelessHostProvider(selectedDeviceId).select((w) => w.ipAddress),
    );
    final subnetMask = ref.watch(
      wirelessHostProvider(selectedDeviceId).select((w) => w.subnetMask),
    );
    final defaultGateway = ref.watch(
      wirelessHostProvider(selectedDeviceId).select((w) => w.defaultGateway),
    );
    final macAddress = ref.watch(
      wirelessHostProvider(selectedDeviceId).select((w) => w.macAddress),
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
                    .read(wirelessHostProvider(selectedDeviceId).notifier)
                    .updateName(value),
              ),
              _InfoPanelField(
                label: 'Network Id :',
                value: Ipv4AddressManager.getNetworkAddress(
                  ipAddress,
                  subnetMask,
                ),
              ),
              _InfoPanelField(
                label: 'Ipv4 Address :',
                value: ipAddress,
                validator: (input) =>
                    Validator.validateIpAddress(input, subnetMask, ipAddress),
                onSave: (value) => ref
                    .read(wirelessHostProvider(selectedDeviceId).notifier)
                    .updateIpAddress(value),
              ),
              _InfoPanelField(
                label: 'Subnet Mask :',
                value: subnetMask,
                validator: (input) =>
                    Validator.validateSubnetMask(input, ipAddress),
                onSave: (value) => ref
                    .read(wirelessHostProvider(selectedDeviceId).notifier)
                    .updateSubnetMask(value),
              ),
              _InfoPanelField(
                label: 'Default Gateway :',
                value: defaultGateway,
                validator: Validator.validateDefaultGateway,
                onSave: (value) => ref
                    .read(wirelessHostProvider(selectedDeviceId).notifier)
                    .updateDefaultGateway(value),
              ),
              _InfoPanelField(label: 'Mac Address :', value: macAddress),

              Consumer(
                builder: (context, ref, child) {
                  final cs = Theme.of(context).colorScheme;
                  final wirelessConId = ref.watch(
                    wirelessHostProvider(
                      selectedDeviceId,
                    ).select((w) => w.wirelessConId),
                  );

                  final accessPointIds = ref
                      .watch(accessPointMapProvider)
                      .keys
                      .toList();

                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 4),

                        const Text(
                          'Available Connections',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        ListView.separated(
                          shrinkWrap: true,
                          itemCount: accessPointIds.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 0),
                          itemBuilder: (context, index) {
                            bool isConnected = false;

                            if (wirelessConId.isNotEmpty) {
                              isConnected =
                                  accessPointIds[index] ==
                                  ref
                                      .read(
                                        wirelessConProvider(
                                          wirelessConId,
                                        ).notifier,
                                      )
                                      .getConnectedDeviceId(selectedDeviceId);
                            }

                            return Container(
                              padding: const EdgeInsets.all(4),
                              child: Row(
                                children: [
                                  HugeIcon(
                                    icon: HugeIcons.strokeRoundedWifi01,
                                    color: cs.onSurface,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ref
                                              .read(
                                                accessPointProvider(
                                                  accessPointIds[index],
                                                ),
                                              )
                                              .name,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),

                                        if (isConnected)
                                          const Text(
                                            'Connected',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: AppColors.successColor,
                                              fontSize: 10,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 2),

                                  if (isConnected)
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppColors.errorColor,
                                        textStyle: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      onPressed: () {
                                        ref
                                            .read(
                                              wirelessHostProvider(
                                                selectedDeviceId,
                                              ).notifier,
                                            )
                                            .disconnectToAccessPoint();
                                      },
                                      child: const Text('Disconnect'),
                                    )
                                  else
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppColors.successColor,
                                        textStyle: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      onPressed: () {
                                        ref
                                            .read(
                                              wirelessHostProvider(
                                                selectedDeviceId,
                                              ).notifier,
                                            )
                                            .connectToAccessPoint(
                                              accessPointIds[index],
                                            );
                                      },
                                      child: const Text('Connect'),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
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

class _WirelessHostArpTableTabView extends ConsumerStatefulWidget {
  const _WirelessHostArpTableTabView();

  @override
  ConsumerState<_WirelessHostArpTableTabView> createState() =>
      _WirelessHostArpTableTabViewState();
}

class _WirelessHostArpTableTabViewState
    extends ConsumerState<_WirelessHostArpTableTabView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('WirelessHostArpTableTabView Rebuilt');

    final selectedDeviceId = ref.watch(
      simScreenProvider.select((s) => s.selectedDeviceOnInfo),
    );

    final arpTable = ref.watch(
      wirelessHostProvider(selectedDeviceId).select((p) => p.arpTable),
    );

    return Padding(
      padding: const EdgeInsets.all(2.0),
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
