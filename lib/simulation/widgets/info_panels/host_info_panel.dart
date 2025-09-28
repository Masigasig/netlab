part of 'info_panel.dart';

//* TODO: Host Info Panel
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
                label: 'Ipv4 Address :',
                value: ipAddress,
                validator: (input) =>
                    Validator.validateIpAddress(input, subnetMask),
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
            ],
          ),
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
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: const Column(children: [Text('This is host Arp Table View')]),
        ),
      ),
    );
  }
}
