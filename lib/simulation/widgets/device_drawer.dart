part of '../simulation_screen.dart';

class DeviceDrawer extends StatefulWidget {
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
    const double width = 200.0;
    const int animationSpeed = 300;

    const allSpawners = [
      _DeviceSpawner(type: SimObjectType.host, imagePath: AppImage.host),
      _DeviceSpawner(type: SimObjectType.router, imagePath: AppImage.router),
      _DeviceSpawner(type: SimObjectType.switch_, imagePath: AppImage.switch_),
      _ConnectionSpawner(),
    ];

    return Stack(
      children: [
        AnimatedPositioned(
          duration: Duration(milliseconds: animationSpeed),
          top: 0,
          bottom: 0,
          left: _isOpen ? 0 : -width,
          width: width,
          child: Material(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            shape: RoundedRectangleBorder(
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
                    itemCount: allSpawners.length,
                    itemBuilder: (context, index) => allSpawners[index],
                  ),
                ),
              ],
            ),
          ),
        ),

        AnimatedPositioned(
          duration: Duration(milliseconds: animationSpeed),
          top: 47,
          left: _isOpen ? width : 0,
          child: GestureDetector(
            onTap: () => _toggleDrawer(),
            child: Container(
              width: 20,
              height: 60,
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.5),
                borderRadius: const BorderRadius.only(
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

  const _DeviceSpawner({required this.type, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    const double size = 200.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Draggable<SimObjectType>(
          data: type,
          dragAnchorStrategy: pointerDragAnchorStrategy,
          feedback: Transform.translate(
            offset: const Offset(-size / 2, -size / 2),
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
  const _ConnectionSpawner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double size = 200.0;
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
