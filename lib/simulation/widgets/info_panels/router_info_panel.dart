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
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: const Column(children: [Text('This is Router Info Tab View')]),
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
