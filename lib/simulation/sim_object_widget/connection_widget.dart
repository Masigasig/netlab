part of 'sim_object_widget.dart';

class ConnectionWidget extends SimObjectWidget {
  const ConnectionWidget({super.key, required super.simObjectId});

  @override
  ConsumerState<ConnectionWidget> createState() => _ConnectionWidgetState();
}

class _ConnectionWidgetState extends _SimObjectWidgetState<ConnectionWidget> {
  late final String _conAId;
  late final String _conBId;

  @override
  void initState() {
    super.initState();
    _conAId = (ref.read(connectionProvider)[widget.simObjectId]!).conA;
    _conBId = (ref.read(connectionProvider)[widget.simObjectId]!).conB;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Connection_${widget.simObjectId} Rebuilt');
    final conAPosX = ref.watch(
      deviceProvider.select((map) => (map[_conAId]!).posX),
    );
    final conAPosY = ref.watch(
      deviceProvider.select((map) => (map[_conAId]!).posY),
    );
    final conBPosX = ref.watch(
      deviceProvider.select((map) => (map[_conBId]!).posX),
    );
    final conBPosY = ref.watch(
      deviceProvider.select((map) => (map[_conBId]!).posY),
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
