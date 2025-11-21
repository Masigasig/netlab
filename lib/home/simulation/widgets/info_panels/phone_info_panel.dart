part of 'info_panel.dart';

class _PhoneInfoTabView extends ConsumerStatefulWidget {
  const _PhoneInfoTabView();
  @override
  ConsumerState<_PhoneInfoTabView> createState() => _PhoneInfoTabViewState();
}

class _PhoneInfoTabViewState extends ConsumerState<_PhoneInfoTabView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('PhoneInfoTabView Rebuilt');

    //TODO: connection for phone

    final selectedDeviceId = ref.watch(
      simScreenProvider.select((s) => s.selectedDeviceOnInfo),
    );

    final name = ref.watch(
      phoneProvider(selectedDeviceId).select((p) => p.name),
    );
    final ipAddress = ref.watch(
      phoneProvider(selectedDeviceId).select((p) => p.ipAddress),
    );
    final subnetMask = ref.watch(
      phoneProvider(selectedDeviceId).select((p) => p.subnetMask),
    );
    final defaultGateway = ref.watch(
      phoneProvider(selectedDeviceId).select((p) => p.defaultGateway),
    );
    final macAddress = ref.watch(
      phoneProvider(selectedDeviceId).select((p) => p.macAddress),
    );
    // final conId = ref.watch(
    //   phoneProvider(selectedDeviceId).select((p) => p.connectionId),
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
                    .read(phoneProvider(selectedDeviceId).notifier)
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
                    .read(phoneProvider(selectedDeviceId).notifier)
                    .updateIpAddress(value),
              ),
              _InfoPanelField(
                label: 'Subnet Mask :',
                value: subnetMask,
                validator: (input) =>
                    Validator.validateSubnetMask(input, ipAddress),
                onSave: (value) => ref
                    .read(phoneProvider(selectedDeviceId).notifier)
                    .updateSubnetMask(value),
              ),
              _InfoPanelField(
                label: 'Default Gateway :',
                value: defaultGateway,
                validator: Validator.validateDefaultGateway,
                onSave: (value) => ref
                    .read(phoneProvider(selectedDeviceId).notifier)
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

class _PhoneArpTableTabView extends ConsumerStatefulWidget {
  const _PhoneArpTableTabView();

  @override
  ConsumerState<_PhoneArpTableTabView> createState() =>
      _PhoneArpTableTabViewState();
}

class _PhoneArpTableTabViewState extends ConsumerState<_PhoneArpTableTabView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('PhoneArpTableTabView Rebuilt');

    final selectedDeviceId = ref.watch(
      simScreenProvider.select((s) => s.selectedDeviceOnInfo),
    );

    final arpTable = ref.watch(
      phoneProvider(selectedDeviceId).select((p) => p.arpTable),
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
