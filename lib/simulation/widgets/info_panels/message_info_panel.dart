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
            ],
          ),
        ),
      ),
    );
  }
}
