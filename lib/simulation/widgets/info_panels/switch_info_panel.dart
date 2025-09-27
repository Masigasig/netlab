part of 'info_panel.dart';

//* TODO: Switch Info Panel
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
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: const Column(children: [Text('This is Switch Info Tab View')]),
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
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: const Column(children: [Text('This is Mac Table View')]),
        ),
      ),
    );
  }
}
