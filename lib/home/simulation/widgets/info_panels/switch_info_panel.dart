part of 'info_panel.dart';

class _SwitchInfoTabView extends ConsumerStatefulWidget {
  const _SwitchInfoTabView();

  @override
  ConsumerState<_SwitchInfoTabView> createState() => _SwitchInfoTabViewState();
}

class _SwitchInfoTabViewState extends ConsumerState<_SwitchInfoTabView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('SwitchInfoTabView Rebuilt');

    final selectedDeviceId = ref.watch(
      simScreenProvider.select((s) => s.selectedDeviceOnInfo),
    );

    final name = ref.watch(
      switchProvider(selectedDeviceId).select((s) => s.name),
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
                    .read(switchProvider(selectedDeviceId).notifier)
                    .updateName(value),
              ),

              Consumer(
                builder: (context, ref, child) {
                  final port0conId = ref.watch(
                    switchProvider(
                      selectedDeviceId,
                    ).select((s) => s.port0conId),
                  );

                  final port1conId = ref.watch(
                    switchProvider(
                      selectedDeviceId,
                    ).select((s) => s.port1conId),
                  );

                  final port2conId = ref.watch(
                    switchProvider(
                      selectedDeviceId,
                    ).select((s) => s.port2conId),
                  );

                  final port3conId = ref.watch(
                    switchProvider(
                      selectedDeviceId,
                    ).select((s) => s.port3conId),
                  );

                  final port4conId = ref.watch(
                    switchProvider(
                      selectedDeviceId,
                    ).select((s) => s.port4conId),
                  );

                  final port5conId = ref.watch(
                    switchProvider(
                      selectedDeviceId,
                    ).select((s) => s.port5conId),
                  );

                  final portConIds = [
                    port0conId,
                    port1conId,
                    port2conId,
                    port3conId,
                    port4conId,
                    port5conId,
                  ];

                  return _buildConnectedDeviceCard(
                    selectedDeviceId,
                    portConIds,
                  );
                },
              ),
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

class _MacTableTabView extends ConsumerStatefulWidget {
  const _MacTableTabView();

  @override
  ConsumerState<_MacTableTabView> createState() => _MacTableTabViewState();
}

class _MacTableTabViewState extends ConsumerState<_MacTableTabView> {
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
      switchProvider(selectedDeviceId).select((s) => s.macTable),
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
