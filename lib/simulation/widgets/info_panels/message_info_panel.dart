part of 'info_panel.dart';

//* TODO: Message Info Panel
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
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: const Column(
            children: [Text('This is Message Info Tab View')],
          ),
        ),
      ),
    );
  }
}
