part of 'sim_object_widget.dart';

class ConnectionWidget extends SimObjectWidget {
  const ConnectionWidget({super.key, required super.simObjectId});

  @override
  ConsumerState<ConnectionWidget> createState() => _ConnectionWidgetState();
}

class _ConnectionWidgetState extends _SimObjectWidgetState<ConnectionWidget> {
  late final String _conAId;
  late final String _conBId;
  late final StateNotifierProvider<dynamic, Map<String, dynamic>> _conAProvider;
  late final StateNotifierProvider<dynamic, Map<String, dynamic>> _conBProvider;

  @override
  void initState() {
    super.initState();
    _conAId = (ref.read(connectionProvider)[widget.simObjectId]!).conA;
    _conBId = (ref.read(connectionProvider)[widget.simObjectId]!).conB;

    _conAProvider = _getDeviceProvider(_conAId);
    _conBProvider = _getDeviceProvider(_conBId);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Connection_${widget.simObjectId} Rebuilt');
    final conAPosX = ref.watch(
      _conAProvider.select((map) => (map[_conAId].posX)),
    );
    final conAPosY = ref.watch(
      _conAProvider.select((map) => (map[_conAId].posY)),
    );
    final conBPosX = ref.watch(
      _conBProvider.select((map) => (map[_conBId].posX)),
    );
    final conBPosY = ref.watch(
      _conBProvider.select((map) => (map[_conBId].posY)),
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
            onTap: () => debugPrint('midpoint ${widget.simObjectId} tapped'),
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

  StateNotifierProvider<dynamic, Map<String, dynamic>> _getDeviceProvider(
    String deviceId,
  ) {
    if (ref.read(hostProvider).containsKey(deviceId)) {
      return hostProvider
          as StateNotifierProvider<dynamic, Map<String, dynamic>>;
    } else if (ref.read(routerProvider).containsKey(deviceId)) {
      return routerProvider
          as StateNotifierProvider<dynamic, Map<String, dynamic>>;
    } else if (ref.read(switchProvider).containsKey(deviceId)) {
      return switchProvider
          as StateNotifierProvider<dynamic, Map<String, dynamic>>;
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
