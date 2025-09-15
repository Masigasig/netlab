part of '../simulation_screen.dart';

class SimulationLogs extends ConsumerStatefulWidget {
  final double width = 200.0;
  final double height = 400.0;
  final int animationSpeed = 300;
  const SimulationLogs({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SimulationLogsState();
}

class _SimulationLogsState extends ConsumerState<SimulationLogs> {
  bool _isOpen = true;

  void _toggleDrawer() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final logs = ref.watch(simLogsProvider);
    return Stack(
      children: [
        AnimatedPositioned(
          duration: Duration(milliseconds: widget.animationSpeed),
          right: _isOpen ? 0 : -widget.width,
          width: widget.width,
          height: widget.height,
          child: Material(
            color: const Color.fromRGBO(0, 0, 0, 0.5),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  // Log list
                  Positioned.fill(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        return Text(
                          logs[logs.length - 1 - index],
                          style: const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),

                  // Floating clear button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: TextButton(
                      onPressed: () {
                        ref.read(simLogsProvider.notifier).clearLogs();
                      },
                      child: const Text(
                        'Clear',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        AnimatedPositioned(
          duration: Duration(milliseconds: widget.animationSpeed),
          top: 47,
          right: _isOpen ? widget.width : 0,
          child: GestureDetector(
            onTap: _toggleDrawer,
            child: Container(
              width: 20,
              height: 60,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
              ),
              child: Icon(
                _isOpen ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
