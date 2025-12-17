part of 'info_panel.dart';

class _AccessPointInfoTabView extends ConsumerStatefulWidget {
  const _AccessPointInfoTabView();

  @override
  ConsumerState<_AccessPointInfoTabView> createState() =>
      _AccessPointInfoTabViewState();
}

class _AccessPointInfoTabViewState
    extends ConsumerState<_AccessPointInfoTabView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('AccessPointInfoTabView Rebuilt');
    final selectedDeviceId = ref.watch(
      simScreenProvider.select((s) => s.selectedDeviceOnInfo),
    );

    final name = ref.watch(
      accessPointProvider(selectedDeviceId).select((ap) => ap.name),
    );

    final port0conId = ref.watch(
      accessPointProvider(selectedDeviceId).select((a) => a.port0conId),
    );
    final portConIds = [port0conId];

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
                    .read(accessPointProvider(selectedDeviceId).notifier)
                    .updateName(value),
              ),

              _buildConnectedDeviceCard(selectedDeviceId, portConIds),
            ],
          ),
        ),
      ),
    );
  }

  Card _buildConnectedDeviceCard(String deviceId, List<String> portConIds) {
    List<Widget> buildConnectionRows() {
      return List.generate(portConIds.length, (index) {
        final conId = portConIds[index];
        final label = 'port$index';

        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
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
                child: Text(
                  conId.isEmpty
                      ? '$label :  Not connected'
                      : '$label :  ${ref.read(connectionProvider(conId).notifier).getConnectedDeviceName(deviceId)}',
                ),
              ),
            ],
          ),
        );
      });
    }

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
            ...buildConnectionRows(),
          ],
        ),
      ),
    );
  }
}

class _APMacTableTabView extends ConsumerStatefulWidget {
  const _APMacTableTabView();

  @override
  ConsumerState<_APMacTableTabView> createState() => _APMacTableTabViewState();
}

class _APMacTableTabViewState extends ConsumerState<_APMacTableTabView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedDeviceId = ref.watch(
      simScreenProvider.select((s) => s.selectedDeviceOnInfo),
    );

    final macToConId = ref.watch(
      accessPointProvider(selectedDeviceId).select((ap) => ap.macToConId),
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
                    label: Center(child: Text("SSID/Port")),
                  ),
                  DataColumn(
                    columnWidth: FixedColumnWidth(100),
                    headingRowAlignment: MainAxisAlignment.center,
                    label: Center(child: Text("MAC Address")),
                  ),
                ],
                rows: macToConId.entries.map((entry) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Center(
                          child: Text(
                            entry.value.startsWith(
                                  SimObjectType.connection.label,
                                )
                                ? 'port0'
                                : ref
                                      .read(
                                        wirelessHostProvider(
                                          ref
                                              .read(
                                                wirelessConProvider(
                                                  entry.value,
                                                ).notifier,
                                              )
                                              .getConnectedDeviceId(
                                                entry.value,
                                              ),
                                        ),
                                      )
                                      .name,
                          ),
                        ),
                      ),
                      DataCell(Center(child: Text(entry.key))),
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
