import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/simulation/provider/logs_notifier.dart';
import 'package:netlab/simulation/provider/sim_screen_notifier.dart';

class LogPanel extends ConsumerWidget {
  const LogPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('LogPanel Widget Rebuilt');
    final isOpen = ref.watch(simScreenProvider.select((s) => s.isLogPanelOpen));

    if (!isOpen) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: 60,
      bottom: 60,
      right: 58,
      child: Center(
        child: DefaultTabController(
          length: 2,
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SizedBox(
              width: 175,
              child: Column(
                children: [
                  SizedBox(
                    height: 35,
                    child: TabBar(
                      indicator: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.secondary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Theme.of(context).colorScheme.secondary,
                      unselectedLabelColor: Theme.of(
                        context,
                      ).colorScheme.onSurface,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      splashFactory: NoSplash.splashFactory,
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      dividerColor: Theme.of(context).colorScheme.secondary,
                      dividerHeight: 0.5,
                      tabs: const [
                        Tab(child: Text('System')),
                        Tab(child: Text('Device')),
                      ],
                    ),
                  ),

                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: TabBarView(children: [_SystemLog(), _DeviceLog()]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DeviceLog extends ConsumerStatefulWidget {
  const _DeviceLog();

  @override
  ConsumerState<_DeviceLog> createState() => _DeviceLogState();
}

class _DeviceLogState extends ConsumerState<_DeviceLog> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedDeviceId = ref.watch(
      simScreenProvider.select((s) => s.selectedDeviceOnInfo),
    );
    final logs = ref.watch(simObjectLogProvider(selectedDeviceId));

    if (_isAtBottom()) {
      _animateToBottom();
    }

    return Stack(
      children: [
        Positioned.fill(
          child: logs.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Log of the selected device will appear here',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(left: 8.0),
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        log.message,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontFamily: 'monospace',
                          fontSize: 10,
                        ),
                      ),
                    );
                  },
                ),
        ),

        if (logs.isNotEmpty)
          Positioned(
            top: 0,
            right: 0,
            child: TextButton(
              onPressed: () {
                ref
                    .read(simObjectLogProvider(selectedDeviceId).notifier)
                    .clearLogs();
              },
              child: Text(
                'Clear',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 10,
                ),
              ),
            ),
          ),
      ],
    );
  }

  bool _isAtBottom() {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return (maxScroll - currentScroll) < 50; // 50px tolerance
  }

  void _animateToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}

class _SystemLog extends ConsumerStatefulWidget {
  const _SystemLog();

  @override
  ConsumerState<_SystemLog> createState() => _SystemLogState();
}

class _SystemLogState extends ConsumerState<_SystemLog> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final logs = ref.watch(systemLogProvider);

    if (_isAtBottom()) {
      _animateToBottom();
    }

    return Stack(
      children: [
        Positioned.fill(
          child: logs.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'System Logs will apper here',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(left: 8.0),
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        log.message,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontFamily: 'monospace',
                          fontSize: 10,
                        ),
                      ),
                    );
                  },
                ),
        ),

        if (logs.isNotEmpty)
          Positioned(
            top: 0,
            right: 0,
            child: TextButton(
              onPressed: () {
                ref.read(systemLogProvider.notifier).clearLogs();
              },
              child: Text(
                'Clear',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 10,
                ),
              ),
            ),
          ),
      ],
    );
  }

  bool _isAtBottom() {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return (maxScroll - currentScroll) < 50; //? 50px tolerance
  }

  void _animateToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
