part of 'info_panel.dart';

class _ConnectionInfoTabView extends ConsumerStatefulWidget {
  const _ConnectionInfoTabView();

  @override
  ConsumerState<_ConnectionInfoTabView> createState() =>
      _ConnectionInfoTabViewState();
}

class _ConnectionInfoTabViewState
    extends ConsumerState<_ConnectionInfoTabView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('ConnectionInfoTabView Rebuilt');

    final selectedDeviceId = ref.watch(
      simScreenProvider.select((s) => s.selectedDeviceOnInfo),
    );

    final name = ref.watch(
      connectionProvider(selectedDeviceId).select((c) => c.name),
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
                    .read(connectionProvider(selectedDeviceId).notifier)
                    .updateName(value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
