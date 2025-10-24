part of 'info_panel.dart';

class _MessageInfoTabView extends ConsumerStatefulWidget {
  const _MessageInfoTabView();

  @override
  ConsumerState<_MessageInfoTabView> createState() =>
      _MessageInfoTabViewState();
}

class _MessageInfoTabViewState extends ConsumerState<_MessageInfoTabView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('MessageInfoTabView Rebuilt');

    final selectedDeviceId = ref.watch(
      simScreenProvider.select((s) => s.selectedDeviceOnInfo),
    );

    final name = ref.watch(
      messageProvider(selectedDeviceId).select((m) => m.name),
    );

    final srcId = ref.watch(
      messageProvider(selectedDeviceId).select((m) => m.srcId),
    );

    final dstId = ref.watch(
      messageProvider(selectedDeviceId).select((m) => m.dstId),
    );

    final srcHostName = ref.watch(hostProvider(srcId).select((h) => h.name));

    String dstHostName = dstId;
    if (dstId.startsWith(SimObjectType.host.label)) {
      dstHostName = ref.read(hostProvider(dstId)).name;
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              _InfoPanelField(
                label: 'Name :',
                value: name,
                validator: Validator.validateName,
                onSave: (value) => ref
                    .read(messageProvider(selectedDeviceId).notifier)
                    .updateName(value),
              ),
              _InfoPanelField(label: 'From :', value: srcHostName),

              _InfoPanelField(label: 'To :', value: dstHostName),

              if (dstHostName.startsWith(SimObjectType.host.label))
                _OsiLayerCard(selectedDeviceId: selectedDeviceId)
              else
                _ArpLayersCard(selectedDeviceId: selectedDeviceId),
            ],
          ),
        ),
      ),
    );
  }
}

class _OsiLayerCard extends ConsumerWidget {
  final String selectedDeviceId;
  const _OsiLayerCard({required this.selectedDeviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layerStackLength = ref.watch(
      messageProvider(selectedDeviceId).select((m) => m.layerStack.length),
    );

    debugPrint('OsiLayersCard rebuilt. length=$layerStackLength');

    final layerStack = ref.read(messageProvider(selectedDeviceId)).layerStack;

    final reversedStack = [{}, ...layerStack].reversed.toList();

    const osiModelLayers = [
      {'layer': '8', 'name': 'Physical', 'color': '0xFF00BCD4'},
      {'layer': '7', 'name': 'Data Link', 'color': '0xFF03A9F4'},
      {'layer': '6', 'name': 'Network', 'color': '0xFF2196F3'},
      {'layer': '', 'name': 'Data', 'color': '0xFF3F51B5'},
      // {'name': 'Transport', 'color': '0xFF3F51B5'},
      // {'name': 'Session', 'color': '0xFF673AB7'},
      // {'name': 'Presentation', 'color': '0xFF9C27B0'},
      // {'name': 'Application', 'color': '0xFFE91E63'},
    ];

    final offset = osiModelLayers.length - reversedStack.length;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            children: [
              const Text(
                'OSI Model Layers',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 250,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: List.generate(reversedStack.length, (index) {
                    final layer = reversedStack[index];
                    final osiLayer = osiModelLayers[offset + index];
                    final color = Color(int.parse(osiLayer['color']!));
                    final layerName = osiLayer['name']!;
                    final layerHeight = 250.0 - (index * 60.0);
                    final horizontalPadding = index * 5.0;

                    return Positioned(
                      bottom: 0,
                      left: horizontalPadding,
                      right: horizontalPadding,
                      child: Container(
                        height: layerHeight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color, color.withAlpha(120)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                          border: Border.all(
                            color: Colors.white.withAlpha(200),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withAlpha(200),
                              blurRadius: 4,
                              offset: const Offset(0, -1),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (index != reversedStack.length - 1)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(100),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Text(
                                        'L${osiLayer['layer']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(width: 10),
                                  if (index != reversedStack.length - 1)
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            layerName,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          if (layerName != 'Physical')
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'SRC: ${(layerName == 'Network') ? layer[MessageKey.senderIp.name] : layer[MessageKey.source.name]}',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                      'DST: ${(layerName == 'Network') ? layer[MessageKey.targetIp.name] : layer[MessageKey.destination.name]}',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    )
                                  else
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          layerName,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArpLayersCard extends ConsumerWidget {
  final String selectedDeviceId;

  const _ArpLayersCard({required this.selectedDeviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layerStackLength = ref.watch(
      messageProvider(selectedDeviceId).select((m) => m.layerStack.length),
    );

    debugPrint('ArpLayersCard rebuilt. length=$layerStackLength');

    final layerStack = ref.read(messageProvider(selectedDeviceId)).layerStack;

    final reversedStack = layerStack.reversed.toList();

    const arpModelLayers = [
      {'layer': '8', 'name': 'Physical', 'color': '0xFF00BCD4'},
      {'layer': '7', 'name': 'Data Link', 'color': '0xFF03A9F4'},
      {'layer': '6', 'name': 'ARP Layer', 'color': '0xFF3F51B5'},
    ];

    final offset = arpModelLayers.length - reversedStack.length;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            children: [
              const Text(
                'OSI Model Layers',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 250,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: List.generate(reversedStack.length, (index) {
                    final layer = reversedStack[index];
                    final osiLayer = arpModelLayers[offset + index];
                    final color = Color(int.parse(osiLayer['color']!));
                    final layerName = osiLayer['name']!;
                    final layerHeight = 250.0 - (index * 60.0);
                    final horizontalPadding = index * 5.0;

                    return Positioned(
                      bottom: 0,
                      left: horizontalPadding,
                      right: horizontalPadding,
                      child: Container(
                        height: layerHeight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color, color.withAlpha(120)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                          border: Border.all(
                            color: Colors.white.withAlpha(200),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withAlpha(200),
                              blurRadius: 4,
                              offset: const Offset(0, -1),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withAlpha(100),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: Text(
                                      'L${osiLayer['layer']}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          layerName,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        if (layerName != 'Physical' &&
                                            layerName == 'Data Link')
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'SRC: ${layer[MessageKey.source.name]}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    'DST: ${layer[MessageKey.destination.name]}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),

                                        if (layerName == 'ARP Layer')
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Type: ${layer[MessageKey.operation.name]}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    'SRC: ${layer[MessageKey.senderIp.name]}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    'DST: ${layer[MessageKey.targetIp.name]}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
