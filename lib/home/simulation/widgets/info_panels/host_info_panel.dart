part of 'info_panel.dart';

class _HostInfoTabView extends ConsumerStatefulWidget {
  const _HostInfoTabView();

  @override
  ConsumerState<_HostInfoTabView> createState() => _HostInfoTabViewState();
}

class _HostInfoTabViewState extends ConsumerState<_HostInfoTabView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('HostInfoTabView Rebuilt');

    final selectedDeviceId = ref.watch(
      simScreenProvider.select((s) => s.selectedDeviceOnInfo),
    );
    final name = ref.watch(
      hostProvider(selectedDeviceId).select((h) => h.name),
    );
    final ipAddress = ref.watch(
      hostProvider(selectedDeviceId).select((h) => h.ipAddress),
    );
    final subnetMask = ref.watch(
      hostProvider(selectedDeviceId).select((h) => h.subnetMask),
    );
    final defaultGateway = ref.watch(
      hostProvider(selectedDeviceId).select((h) => h.defaultGateway),
    );
    final macAddress = ref.watch(
      hostProvider(selectedDeviceId).select((h) => h.macAddress),
    );
    final conId = ref.watch(
      hostProvider(selectedDeviceId).select((h) => h.connectionId),
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
                    .read(hostProvider(selectedDeviceId).notifier)
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
                    .read(hostProvider(selectedDeviceId).notifier)
                    .updateIpAddress(value),
              ),
              _InfoPanelField(
                label: 'Subnet Mask :',
                value: subnetMask,
                validator: (input) =>
                    Validator.validateSubnetMask(input, ipAddress),
                onSave: (value) => ref
                    .read(hostProvider(selectedDeviceId).notifier)
                    .updateSubnetMask(value),
              ),
              _InfoPanelField(
                label: 'Default Gateway :',
                value: defaultGateway,
                validator: Validator.validateDefaultGateway,
                onSave: (value) => ref
                    .read(hostProvider(selectedDeviceId).notifier)
                    .updateDefaultGateway(value),
              ),
              _InfoPanelField(label: 'Mac Address :', value: macAddress),

              _buildConnectedDeviceCard(selectedDeviceId, conId),
            ],
          ),
        ),
      ),
    );
  }

  Card _buildConnectedDeviceCard(String deviceId, String conId) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Connected Device :',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Image.asset(
                  AppImage.ethernet,
                  width: 15,
                  height: 15,
                  color: conId.isEmpty
                      ? Theme.of(context).colorScheme.onSurface
                      : Colors.green,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: conId.isEmpty
                      ? const Text('eth0 :  Not connected')
                      : Text(
                          'eth0 :  ${ref.read(connectionProvider(conId).notifier).getConnectedDeviceName(deviceId)}',
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HostArpTableTabView extends ConsumerStatefulWidget {
  const _HostArpTableTabView();

  @override
  ConsumerState<_HostArpTableTabView> createState() =>
      _HostArpTableTabViewState();
}

class _HostArpTableTabViewState extends ConsumerState<_HostArpTableTabView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('HostArpTableTabView Rebuilt');
    final selectedDeviceId = ref.watch(
      simScreenProvider.select((s) => s.selectedDeviceOnInfo),
    );

    final arpTable = ref.watch(
      hostProvider(selectedDeviceId).select((h) => h.arpTable),
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
                  fontWeight: FontWeight.normal,
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
