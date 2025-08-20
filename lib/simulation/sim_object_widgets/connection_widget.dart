part of 'sim_object_widget.dart';

class ConnectionWidget extends SimObjectWidget {
  const ConnectionWidget({super.key, required super.simObjectId});

  factory ConnectionWidget.fromId(String simObjectId) =>
      ConnectionWidget(simObjectId: simObjectId);

  @override
  ConsumerState<ConnectionWidget> createState() => _ConnectionWidgetState();
}

class _ConnectionWidgetState extends _SimObjectWidgetState<ConnectionWidget> {
  late final String _conAId;
  late final String _conBId;
  late StateNotifierProviderFamily<DeviceNotifier<dynamic>, dynamic, String>
  _conAProvider;
  late StateNotifierProviderFamily<DeviceNotifier<dynamic>, dynamic, String>
  _conBProvider;

  @override
  void initState() {
    super.initState();
    _conAId = ref.read(connectionProvider(widget.simObjectId)).conAId;
    _conBId = ref.read(connectionProvider(widget.simObjectId)).conBId;

    _conAProvider = _getDeviceProvider(_conAId);
    _conBProvider = _getDeviceProvider(_conBId);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Connection_${widget.simObjectId} Rebuilt');
    final conAPosX = ref.watch(
      _conAProvider(_conAId).select((state) => state.posX),
    );
    final conAPosY = ref.watch(
      _conAProvider(_conAId).select((state) => state.posY),
    );
    final conBPosX = ref.watch(
      _conBProvider(_conBId).select((state) => state.posX),
    );
    final conBPosY = ref.watch(
      _conBProvider(_conBId).select((state) => state.posY),
    );

    final start = Offset(conAPosX, conAPosY);
    final end = Offset(conBPosX, conBPosY);
    final mid = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);

    return Stack(
      children: [
        IgnorePointer(
          child: CustomPaint(
            painter: _ConnectionLinePainter(start: start, end: end),
            child: const SizedBox.expand(),
          ),
        ),

        Positioned(
          left: mid.dx - 15,
          top: mid.dy - 15,
          child: GestureDetector(
            onTap: _handleTap,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.7),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.circle, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  void _handleTap() {
    if (ref.read(selectedDeviceOnInfoProvider.notifier).state ==
        widget.simObjectId) {
      ref.read(selectedDeviceOnInfoProvider.notifier).state = '';
    } else {
      ref.read(selectedDeviceOnInfoProvider.notifier).state =
          widget.simObjectId;
    }
  }

  StateNotifierProviderFamily<DeviceNotifier<dynamic>, dynamic, String>
  _getDeviceProvider(String deviceId) {
    if (deviceId.startsWith(SimObjectType.host.label)) {
      return hostProvider;
    } else if (deviceId.startsWith(SimObjectType.router.label)) {
      return routerProvider;
    } else if (deviceId.startsWith(SimObjectType.switch_.label)) {
      return switchProvider;
    } else {
      throw Exception('Device not found in any provider: $deviceId');
    }
  }
}

class _ConnectionLinePainter extends CustomPainter {
  final Offset start;
  final Offset end;

  const _ConnectionLinePainter({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant _ConnectionLinePainter oldDelegate) {
    return oldDelegate.start != start || oldDelegate.end != end;
  }
}
