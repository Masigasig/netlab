part of '../simulation_screen.dart';

class ConnChoiceList extends ConsumerStatefulWidget {
  const ConnChoiceList({super.key});

  @override
  ConsumerState<ConnChoiceList> createState() => _ConnChoiceListState();
}

class _ConnChoiceListState extends ConsumerState<ConnChoiceList> {
  @override
  Widget build(BuildContext context) {
    debugPrint('ConnChoiceList Widget Rebuilt');

    final selectedId = ref.watch(selectedDeviceOnConnProvider);

    if (selectedId.isEmpty) return const Offstage(offstage: true);

    dynamic device;
    List<Map<String, String>> connection = [];

    if (selectedId.startsWith(SimObjectType.host.label)) {
      device = ref.watch(hostProvider(selectedId));
      connection = ref
          .read(hostProvider(selectedId).notifier)
          .getAllConnectionInfo();
    } else if (selectedId.startsWith(SimObjectType.router.label)) {
      device = ref.watch(routerProvider(selectedId));
      connection = ref
          .read(routerProvider(selectedId).notifier)
          .getAllConnectionInfo();
    } else if (selectedId.startsWith(SimObjectType.switch_.label)) {
      device = ref.watch(switchProvider(selectedId));
      connection = ref
          .read(switchProvider(selectedId).notifier)
          .getAllConnectionInfo();
    } else {
      return const Offstage(offstage: true);
    }

    double offset =
        55 + connection.length * 27; //* 27 is like the height per connection

    return Positioned(
      left: device.posX - 60,
      top: device.posY - offset,
      child: Card(
        elevation: 4,
        child: SizedBox(
          width: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ...connection.map((entry) => _buildConnectionItem(entry)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionItem(Map<String, String> entry) {
    final name = entry['name']!;
    final isAvailable = entry['conId']!.isEmpty;

    return TextButton(
      onPressed: isAvailable
          ? () {
              ref
                  .read(simScreenState.notifier)
                  .createConnection(
                    ref.read(selectedDeviceOnConnProvider),
                    name,
                  );
              ref.read(selectedDeviceOnConnProvider.notifier).state = '';
            }
          : null,
      style: TextButton.styleFrom(minimumSize: const Size(120, 40)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAvailable ? Icons.link_off : Icons.link,
            size: 16,
            color: isAvailable ? null : Colors.green,
          ),
          const SizedBox(width: 8),
          Text(
            name,
            style: TextStyle(color: isAvailable ? null : Colors.green),
          ),
        ],
      ),
    );
  }
}
