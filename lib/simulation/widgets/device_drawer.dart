part of '../simulation_screen.dart';

class DeviceDrawer extends StatefulWidget {
  final double width = 200.0;
  final int animationSpeed = 300;
  final allSpawners = const [
    _DeviceSpawner(type: SimObjectType.host, imagePath: AppImage.host),
    _DeviceSpawner(type: SimObjectType.router, imagePath: AppImage.router),
    _DeviceSpawner(type: SimObjectType.switch_, imagePath: AppImage.switch_),
    _ConnectionSpawner(),
    _MessageSpawner(),
  ];

  const DeviceDrawer({super.key});

  @override
  State<DeviceDrawer> createState() => _DeviceDrawerState();
}

class _DeviceDrawerState extends State<DeviceDrawer> {
  bool _isOpen = true;

  void _toggleDrawer() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('DeviceDrawer Widget Rebuilt');
    return Stack(
      children: [
        AnimatedPositioned(
          duration: Duration(milliseconds: widget.animationSpeed),
          top: 0,
          bottom: 0,
          left: _isOpen ? 0 : -widget.width,
          width: widget.width,
          child: Material(
            color: const Color.fromRGBO(0, 0, 0, 0.5),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Devices",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const Divider(color: Colors.white),

                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(10.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 0.0,
                          mainAxisSpacing: 0.0,
                          childAspectRatio: 0.9,
                        ),
                    itemCount: widget.allSpawners.length,
                    itemBuilder: (context, index) => widget.allSpawners[index],
                  ),
                ),
              ],
            ),
          ),
        ),

        AnimatedPositioned(
          duration: Duration(milliseconds: widget.animationSpeed),
          top: 47,
          left: _isOpen ? widget.width : 0,
          child: GestureDetector(
            onTap: () => _toggleDrawer(),
            child: Container(
              width: 20,
              height: 60,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.5),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Icon(
                _isOpen ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
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

class _DeviceSpawner extends StatelessWidget {
  final SimObjectType type;
  final String imagePath;
  final double size = 100.0;

  const _DeviceSpawner({required this.type, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    debugPrint('DeviceSpawner Widget Rebuilt');
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Draggable<SimObjectType>(
          data: type,
          dragAnchorStrategy: pointerDragAnchorStrategy,
          feedback: Transform.translate(
            offset: Offset(-size / 2, -size / 2),
            child: SizedBox(
              width: size,
              height: size,
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
          ),
          child: SizedBox(
            width: size - 35,
            height: size - 35,
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
        ),
        Text(type.label),
      ],
    );
  }
}

class _ConnectionSpawner extends ConsumerWidget {
  final double size = 100.0;

  const _ConnectionSpawner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('ConnectionSpawner Widget Rebuilt');
    final isActive = ref.watch(wireModeProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => ref.read(simScreenState.notifier).toggleWireMode(),
          child: Container(
            width: size - 35,
            height: size - 35,
            decoration: BoxDecoration(
              color: isActive ? Colors.blueAccent : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Image.asset(AppImage.connection, fit: BoxFit.contain),
          ),
        ),
        Text(SimObjectType.connection.label),
      ],
    );
  }
}

class _MessageSpawner extends ConsumerWidget {
  final double size = 100.0;

  const _MessageSpawner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('MessageSpawner Widget Rebuilt');
    final isActive = ref.watch(messageModeProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => ref.read(simScreenState.notifier).toggleMessageMode(),
          child: Container(
            width: size - 35,
            height: size - 35,
            decoration: BoxDecoration(
              color: isActive ? Colors.blueAccent : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Image.asset(AppImage.message, fit: BoxFit.contain),
          ),
        ),
        Text(SimObjectType.message.label),
      ],
    );
  }
}
