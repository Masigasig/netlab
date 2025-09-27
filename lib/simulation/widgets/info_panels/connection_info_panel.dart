part of 'info_panel.dart';

//* TODO: Connection Info Panel
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
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: const Column(
            children: [Text('This is Connection Info Tab View')],
          ),
        ),
      ),
    );
  }
}
