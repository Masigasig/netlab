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
      wirelessHostProvider(selectedDeviceId).select((p) => p.name),
    );
    final ipAddress = ref.watch(
      wirelessHostProvider(selectedDeviceId).select((p) => p.ipAddress),
    );
    final subnetMask = ref.watch(
      wirelessHostProvider(selectedDeviceId).select((p) => p.subnetMask),
    );
    final defaultGateway = ref.watch(
      wirelessHostProvider(selectedDeviceId).select((p) => p.defaultGateway),
    );
    final macAddress = ref.watch(
      wirelessHostProvider(selectedDeviceId).select((p) => p.macAddress),
    );
    // final conId = ref.watch(
    //   wirelessHostProvider(selectedDeviceId).select((p) => p.connectionId),
    // );

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

              // _buildConnectedDeviceCard(selectedDeviceId, conId),
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
