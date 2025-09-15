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
    } else if (selectedDevice.startsWith(SimObjectType.router.label)) {
      deviceInfoWidget = _RouterInfoTable(routerId: selectedDevice);
    } else if (selectedDevice.startsWith(SimObjectType.switch_.label)) {
      deviceInfoWidget = _SwitchInfoTable(switchId: selectedDevice);
    } else if (selectedDevice.startsWith(SimObjectType.message.label)) {
      deviceInfoWidget = _MessageInfoTable(messageId: selectedDevice);
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
                        onPressed: () => ref
                            .read(selectedDeviceOnInfoProvider.notifier)
                            .clearSelectedDevice(),
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
    if (ref.read(playingModeProvider)) return;

    final selectedDevice = deviceId;
    ref.read(selectedDeviceOnInfoProvider.notifier).clearSelectedDevice();

    if (selectedDevice.startsWith(SimObjectType.host.label)) {
      ref.read(hostProvider(selectedDevice).notifier).removeSelf();
    } else if (selectedDevice.startsWith(SimObjectType.connection.label)) {
      ref.read(connectionProvider(selectedDevice).notifier).removeSelf();
    } else if (selectedDevice.startsWith(SimObjectType.message.label)) {
      ref.read(messageProvider(selectedDevice).notifier).removeSelf();
    } else if (selectedDevice.startsWith(SimObjectType.switch_.label)) {
      ref.read(switchProvider(selectedDevice).notifier).removeSelf();
    } else if (selectedDevice.startsWith(SimObjectType.router.label)) {
      ref.read(routerProvider(selectedDevice).notifier).removeSelf();
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

class _InterfaceData {
  final String routerId;
  final String name;
  final String ipAddress;
  final String subnetMask;
  final String macAddress;

  const _InterfaceData({
    required this.routerId,
    required this.name,
    required this.ipAddress,
    required this.subnetMask,
    required this.macAddress,
  });
}

class _RouterInfoTable extends ConsumerWidget {
  final String routerId;
  const _RouterInfoTable({required this.routerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider(routerId));

    final List<_InterfaceData> interfaces = [
      _InterfaceData(
        routerId: routerId,
        name: Eth.eth0.name,
        ipAddress: router.eth0IpAddress,
        subnetMask: router.eth0SubnetMask,
        macAddress: router.eth0MacAddress,
      ),
      _InterfaceData(
        routerId: routerId,
        name: Eth.eth1.name,
        ipAddress: router.eth1IpAddress,
        subnetMask: router.eth1SubnetMask,
        macAddress: router.eth1MacAddress,
      ),
      _InterfaceData(
        routerId: routerId,
        name: Eth.eth2.name,
        ipAddress: router.eth2IpAddress,
        subnetMask: router.eth2SubnetMask,
        macAddress: router.eth2MacAddress,
      ),
      _InterfaceData(
        routerId: routerId,
        name: Eth.eth3.name,
        ipAddress: router.eth3IpAddress,
        subnetMask: router.eth3SubnetMask,
        macAddress: router.eth3MacAddress,
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(child: _InterfaceCard(data: interfaces[0])),
            const SizedBox(width: 12),
            Expanded(child: _InterfaceCard(data: interfaces[1])),
          ],
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(child: _InterfaceCard(data: interfaces[2])),
            const SizedBox(width: 12),
            Expanded(child: _InterfaceCard(data: interfaces[3])),
          ],
        ),
        const SizedBox(height: 12),

        ArpTableWidget(arpTable: router.arpTable),
        const SizedBox(height: 16),
        RoutingTableWidget(routingTable: router.routingTable),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => _showAddStaticRouteDialog(context, ref, routerId),
          child: const Text("Add Static Route"),
        ),
      ],
    );
  }

  void _showAddStaticRouteDialog(
    BuildContext context,
    WidgetRef ref,
    String routerId,
  ) {
    final networkController = TextEditingController();
    final subnetMaskController = TextEditingController();
    final interfaceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Static Route"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: networkController,
                decoration: const InputDecoration(
                  labelText: "Network Address",
                  hintText: "e.g., 192.168.1.0",
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: subnetMaskController,
                decoration: const InputDecoration(
                  labelText: "Subnet Mask",
                  hintText: "e.g., 255.255.255.0",
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: interfaceController,
                decoration: const InputDecoration(
                  labelText: "Interface",
                  hintText: "e.g., eth0",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                final network = networkController.text;
                final subnetMask = subnetMaskController.text;
                final interface = interfaceController.text;

                if (network.isNotEmpty &&
                    subnetMask.isNotEmpty &&
                    interface.isNotEmpty) {
                  ref
                      .read(routerProvider(routerId).notifier)
                      .addRoutingEntry(
                        network,
                        "Static",
                        subnetMask,
                        interface,
                      );
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}

class _InterfaceCard extends ConsumerStatefulWidget {
  final _InterfaceData data;

  const _InterfaceCard({required this.data});

  @override
  _InterfaceCardState createState() => _InterfaceCardState();
}

class _InterfaceCardState extends ConsumerState<_InterfaceCard> {
  bool _isEditing = false;
  late TextEditingController _ipController;
  late TextEditingController _maskController;

  @override
  void initState() {
    super.initState();
    _ipController = TextEditingController(text: widget.data.ipAddress);
    _maskController = TextEditingController(text: widget.data.subnetMask);
  }

  @override
  void dispose() {
    _ipController.dispose();
    _maskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.data.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text("IP:"),

        _isEditing
            ? TextField(
                controller: _ipController,
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              )
            : Text(widget.data.ipAddress),

        const SizedBox(height: 8),
        const Text("Subnet Mask:"),

        _isEditing
            ? TextField(
                controller: _maskController,
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              )
            : Text(widget.data.subnetMask),

        const SizedBox(height: 8),
        const Text("MAC Address:"),
        Text(widget.data.macAddress),

        const SizedBox(height: 8),

        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {
              if (_isEditing) {
                // Save changes
                // Note: In a real app, you would also update the state in the provider
                final networkAddress = IPv4AddressManager.getNetworkAddress(
                  _ipController.text,
                  _maskController.text,
                );

                final subnetMask = IPv4AddressManager.subnetToCidr(
                  _maskController.text,
                );

                bool isInRoutingTable = ref
                    .read(routerProvider(widget.data.routerId))
                    .routingTable
                    .containsKey(networkAddress + subnetMask);
                // print(ref.read(routerProvider(widget.data.routerId)).routingTable);

                if (IPv4AddressManager.isValidIp(_ipController.text) &&
                    IPv4AddressManager.isValidSubnet(_maskController.text) &&
                    !isInRoutingTable) {
                  ref
                      .read(routerProvider(widget.data.routerId).notifier)
                      .updateIpByEthName(widget.data.name, _ipController.text);

                  ref
                      .read(routerProvider(widget.data.routerId).notifier)
                      .updateSubnetMaskByEthName(
                        widget.data.name,
                        _maskController.text,
                      );

                  ref
                      .read(routerProvider(widget.data.routerId).notifier)
                      .addRoutingEntry(
                        networkAddress,
                        'Directed',
                        _maskController.text,
                        widget.data.name,
                      );
                }

                setState(() {
                  _isEditing = false;
                });
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
            child: Text(_isEditing ? "Save" : "Edit"),
          ),
        ),
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

class _SwitchInfoTable extends ConsumerWidget {
  final String switchId;

  const _SwitchInfoTable({required this.switchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final switchDevice = ref.watch(switchProvider(switchId));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "MAC Table",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DataTable(
          columns: const [
            DataColumn(label: Text("Port")),
            DataColumn(label: Text("MAC Address")),
          ],
          rows: switchDevice.macTable.entries.map((entry) {
            return DataRow(
              cells: [DataCell(Text(entry.key)), DataCell(Text(entry.value))],
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _MessageInfoTable extends ConsumerWidget {
  final String messageId;

  const _MessageInfoTable({required this.messageId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(messageProvider(messageId));

    final stack = message.layerStack;

    // Find the latest IP and MAC layers
    final ipLayer = stack.reversed.firstWhere(
      (layer) =>
          layer.containsKey(MessageKey.senderIp.name) &&
          layer.containsKey(MessageKey.targetIp.name),
      orElse: () => {},
    );

    final macLayer = stack.reversed.firstWhere(
      (layer) =>
          layer.containsKey(MessageKey.source.name) &&
          layer.containsKey(MessageKey.destination.name),
      orElse: () => {},
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          "Message: ${message.name}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "From: ${ref.read(hostProvider(message.srcId)).name} → "
          "${ref.read(hostProvider(message.dstId)).name}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        const Text(
          "Current Stack",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        if (macLayer.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey, width: 2),
              borderRadius: BorderRadius.circular(8),
              color: Colors.blueGrey.withValues(alpha: 0.1),
            ),
            child: Text(
              "MAC: ${macLayer[MessageKey.source.name] ?? 'N/A'} → "
              "${macLayer[MessageKey.destination.name] ?? 'N/A'}",
              style: const TextStyle(fontSize: 16),
            ),
          ),

        if (ipLayer.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey, width: 2),
              borderRadius: BorderRadius.circular(8),
              color: Colors.blueGrey.withValues(alpha: 0.1),
            ),
            child: Text(
              "IP: ${ipLayer[MessageKey.senderIp.name] ?? 'N/A'} → "
              "${ipLayer[MessageKey.targetIp.name] ?? 'N/A'}",
              style: const TextStyle(fontSize: 16),
            ),
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

class RoutingTableWidget extends StatelessWidget {
  final Map<String, Map<String, String>> routingTable;

  const RoutingTableWidget({required this.routingTable, super.key});

  @override
  Widget build(BuildContext context) {
    final entries = routingTable.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Routing Table",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DataTable(
          columns: const [
            DataColumn(label: Text("Type")),
            DataColumn(label: Text("Network")),
            DataColumn(label: Text("Interface")),
          ],
          rows: entries.map((entry) {
            final network = entry.key;
            final details = entry.value;
            return DataRow(
              cells: [
                DataCell(Text(details['type'] ?? '')),
                DataCell(Text(network)),
                DataCell(Text(details['interface'] ?? '')),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
