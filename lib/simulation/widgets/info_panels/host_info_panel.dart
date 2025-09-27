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
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: const Column(children: [Text('This is host Info Tab View')]),
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
