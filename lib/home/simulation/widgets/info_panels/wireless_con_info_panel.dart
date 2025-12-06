part of 'info_panel.dart';

class _WirelessConInfoTabView extends ConsumerStatefulWidget {
  const _WirelessConInfoTabView();

  @override
  ConsumerState<_WirelessConInfoTabView> createState() =>
      _WirelessConInfoTabViewState();
}

class _WirelessConInfoTabViewState
    extends ConsumerState<_WirelessConInfoTabView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('WirelessCon InfoTabView Rebuilt');

    final selectedDeviceId = ref.watch(
      simScreenProvider.select((s) => s.selectedDeviceOnInfo),
    );

    final name = ref.watch(
      wirelessConProvider(selectedDeviceId).select((w) => w.name),
    );

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
                    .read(wirelessConProvider(selectedDeviceId).notifier)
                    .updateName(value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
