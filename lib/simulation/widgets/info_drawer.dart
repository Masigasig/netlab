part of '../simulation_screen.dart';

class InfoDrawer extends ConsumerStatefulWidget {
  final double width = 800.0;
  final double height = 250.0;
  final int animationSpeed = 300;

  const InfoDrawer({super.key});

  @override
  ConsumerState<InfoDrawer> createState() => _InfoDrawerState();
}

class _InfoDrawerState extends ConsumerState<InfoDrawer> {
  bool _isOpen = false;

  void _close() {
    setState(() {
      _isOpen = false;
    });
  }

  void _open() {
    setState(() {
      _isOpen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedDevice = ref.watch(selectedDeviceOnInfoProvider);

    if (selectedDevice.isNotEmpty) {
      _open();
    } else {
      _close();
    }

    dynamic deviceInfoWidget;

    if (selectedDevice.startsWith(SimObjectType.host.label)) {
      deviceInfoWidget = _HostInfoTable(hostId: selectedDevice);
    } else {
      deviceInfoWidget = const Offstage(offstage: true);
    }

    return Stack(
      children: [
        AnimatedPositioned(
          duration: Duration(milliseconds: widget.animationSpeed),
          bottom: _isOpen ? 0 : -widget.height,
          left: 0,
          right: 0,
          height: widget.height,
          child: Center(
            child: Material(
              color: const Color.fromRGBO(0, 0, 0, 0.5),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SizedBox(
                width: widget.width,
                height: widget.height,
                child: Stack(
                  children: [
                    deviceInfoWidget,

                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () =>
                            ref
                                    .read(selectedDeviceOnInfoProvider.notifier)
                                    .state =
                                '',
                      ),
                    ),

                    Positioned(
                      top: 8,
                      right: 40,
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white),
                        onPressed: () => _handleDelete(selectedDevice),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleDelete(String deviceId) {
    if (ref.read(playingModeProvider.notifier).state == true) return;

    final selectedDevice = deviceId;
    ref.read(selectedDeviceOnInfoProvider.notifier).state = '';

    if (selectedDevice.startsWith(SimObjectType.host.label)) {
      ref.read(hostProvider(selectedDevice).notifier).removeSelf();
    } else if (selectedDevice.startsWith(SimObjectType.connection.label)) {
      ref.read(connectionProvider(selectedDevice).notifier).removeSelf();
    } else if (selectedDevice.startsWith(SimObjectType.message.label)) {
      ref.read(messageProvider(selectedDevice).notifier).removeSelf();
    }
  }
}

class _InfoRow {
  final String label;
  final String value;
  final bool editable;

  const _InfoRow({
    required this.label,
    required this.value,
    this.editable = true,
  });
}

class _HostInfoTable extends ConsumerWidget {
  final String hostId;
  const _HostInfoTable({required this.hostId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final host = ref.watch(hostProvider(hostId));

    final List<_InfoRow> rows = [
      _InfoRow(label: 'name', value: host.name, editable: false),
      _InfoRow(label: 'IPv4 Address', value: host.ipAddress),
      _InfoRow(label: 'Subnet Mask', value: host.subnetMask),
      _InfoRow(label: 'Default Gateway', value: host.defaultGateway),
      _InfoRow(label: 'Mac Address', value: host.macAddress, editable: false),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Info rows
        ...rows.map((row) {
          return Column(
            children: [
              row.editable
                  ? _EditableRow(
                      label: row.label,
                      value: row.value,
                      onSave: (newValue) {
                        final notifier = ref.read(
                          hostProvider(hostId).notifier,
                        );
                        switch (row.label) {
                          case 'IPv4 Address':
                            notifier.updateIpAddress(newValue);
                            break;
                          case 'Subnet Mask':
                            notifier.updateSubnetMask(newValue);
                            break;
                          case 'Default Gateway':
                            notifier.updateDefaultGateway(newValue);
                            break;
                        }
                      },
                    )
                  : _ReadOnlyRow(label: row.label, value: row.value),
              const Divider(),
            ],
          );
        }),

        const SizedBox(height: 16),

        ArpTableWidget(arpTable: host.arpTable),
      ],
    );
  }
}

class _ReadOnlyRow extends StatelessWidget {
  final String label;
  final String value;

  const _ReadOnlyRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text("$label: $value", style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}

class _EditableRow extends StatefulWidget {
  final String label;
  final String value;
  final ValueChanged<String> onSave;

  const _EditableRow({
    required this.label,
    required this.value,
    required this.onSave,
  });

  @override
  State<_EditableRow> createState() => _EditableRowState();
}

class _EditableRowState extends State<_EditableRow> {
  bool _isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: !_isEditing
              ? Text(
                  "${widget.label}: ${widget.value}",
                  style: const TextStyle(fontSize: 16),
                )
              : Row(
                  children: [
                    Text(
                      "${widget.label}: ",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
        const SizedBox(width: 8),
        !_isEditing
            ? IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    _isEditing = true;
                  });
                },
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () {
                      widget.onSave(_controller.text);
                      setState(() => _isEditing = false);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      _controller.text = widget.value;
                      setState(() => _isEditing = false);
                    },
                  ),
                ],
              ),
      ],
    );
  }
}

class ArpTableWidget extends StatelessWidget {
  final Map<String, String> arpTable;

  const ArpTableWidget({required this.arpTable, super.key});

  @override
  Widget build(BuildContext context) {
    final entries = arpTable.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "ARP Table",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DataTable(
          columns: const [
            DataColumn(label: Text("IP Address")),
            DataColumn(label: Text("MAC Address")),
          ],
          rows: entries.map((entry) {
            return DataRow(
              cells: [DataCell(Text(entry.key)), DataCell(Text(entry.value))],
            );
          }).toList(),
        ),
      ],
    );
  }
}
