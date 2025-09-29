part of 'info_panel.dart';

//* TODO: Router Info Panel
class _RouterInfoTabView extends ConsumerStatefulWidget {
  const _RouterInfoTabView();

  @override
  ConsumerState<_RouterInfoTabView> createState() => _RouterInfoTabViewState();
}

class _RouterInfoTabViewState extends ConsumerState<_RouterInfoTabView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('RouterInfoTabView Rebuilt');

    final selectedDeviceId = ref.watch(
      simScreenProvider.select((s) => s.selectedDeviceOnInfo),
    );
    final name = ref.watch(
      routerProvider(selectedDeviceId).select((r) => r.name),
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
                    .read(routerProvider(selectedDeviceId).notifier)
                    .updateName(value),
              ),

              Consumer(
                builder: (context, ref, child) {
                  debugPrint('Interface 0 Consumer Rebuilt');

                  final ipAddress = ref.watch(
                    routerProvider(
                      selectedDeviceId,
                    ).select((r) => r.eth0IpAddress),
                  );
                  final subnetMask = ref.watch(
                    routerProvider(
                      selectedDeviceId,
                    ).select((r) => r.eth0SubnetMask),
                  );

                  final macAddress = ref.watch(
                    routerProvider(
                      selectedDeviceId,
                    ).select((r) => r.eth0MacAddress),
                  );

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 2),
                          const Text(
                            "Interface 0",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // _InfoPanelField(
                          //   label: 'Ipv4 Address :',
                          //   value: ipAddress,
                          //   validator: (input) =>
                          //       Validator.validateIpAddress(input, subnetMask),
                          //   onSave: (value) => ref
                          //       .read(routerProvider(selectedDeviceId).notifier)
                          //       .updateIpAddress(value),
                          // ),
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
                            label: 'Mac Address :',
                            value: macAddress,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // const Text(
              //   "Interface 1",
              //   style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              // ),

              // Consumer(
              //   builder: (context, ref, child) {
              //     debugPrint('Interface 1 Consumer Rebuilt');

              //     final ipAddress = ref.watch(
              //       routerProvider(
              //         selectedDeviceId,
              //       ).select((r) => r.eth1IpAddress),
              //     );
              //     final subnetMask = ref.watch(
              //       routerProvider(
              //         selectedDeviceId,
              //       ).select((r) => r.eth1SubnetMask),
              //     );

              //     final macAddress = ref.watch(
              //       routerProvider(
              //         selectedDeviceId,
              //       ).select((r) => r.eth1MacAddress),
              //     );

              //     return Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         _InfoPanelField(
              //           label: 'Ipv4 Address :',
              //           value: ipAddress,
              //           validator: (input) =>
              //               Validator.validateIpAddress(input, subnetMask),
              //           onSave: (value) => ref
              //               .read(hostProvider(selectedDeviceId).notifier)
              //               .updateIpAddress(value),
              //         ),
              //         _InfoPanelField(
              //           label: 'Subnet Mask :',
              //           value: subnetMask,
              //           validator: (input) =>
              //               Validator.validateSubnetMask(input, ipAddress),
              //           onSave: (value) => ref
              //               .read(hostProvider(selectedDeviceId).notifier)
              //               .updateSubnetMask(value),
              //         ),
              //         _InfoPanelField(
              //           label: 'Mac Address :',
              //           value: macAddress,
              //         ),
              //       ],
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RouterArpTableTabView extends ConsumerStatefulWidget {
  const _RouterArpTableTabView();

  @override
  ConsumerState<_RouterArpTableTabView> createState() =>
      _RouterArpTableTabViewState();
}

class _RouterArpTableTabViewState
    extends ConsumerState<_RouterArpTableTabView> {
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
          child: const Column(
            children: [Text('This is Router Arp Table View')],
          ),
        ),
      ),
    );
  }
}

class _RoutingTableTabView extends ConsumerStatefulWidget {
  const _RoutingTableTabView();

  @override
  ConsumerState<_RoutingTableTabView> createState() =>
      _RoutingTableTabViewState();
}

class _RoutingTableTabViewState extends ConsumerState<_RoutingTableTabView> {
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
          child: const Column(children: [Text('This is Routing Table View')]),
        ),
      ),
    );
  }
}
