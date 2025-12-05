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

              //TODO: connection of access point
            ],
          ),
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
  //TODO: AccessPoint mac table
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

    final macTable = ref.watch(
      accessPointProvider(selectedDeviceId).select((ap) => ap.sessionTable),
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
                    columnWidth: FixedColumnWidth(50),
                    headingRowAlignment: MainAxisAlignment.center,
                    label: Center(child: Text("Port")),
                  ),
                  DataColumn(
                    columnWidth: FixedColumnWidth(100),
                    headingRowAlignment: MainAxisAlignment.center,
                    label: Center(child: Text("MAC Address")),
                  ),
                ],
                rows: macTable.entries.map((entry) {
                  return DataRow(
                    cells: [
                      DataCell(Center(child: Text(entry.value))),
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
