part of 'sim_object_widget.dart';

class ConnectionWidget extends SimObjectWidget {
  const ConnectionWidget({super.key, required super.simObjectId});

  @override
  ConsumerState<ConnectionWidget> createState() => _ConnectionWidgetState();
}

class _ConnectionWidgetState extends _SimObjectWidgetState<ConnectionWidget> {
  @override
  Widget build(BuildContext context) {
    debugPrint('Connection_${widget.simObjectId} Rebuilt');

    final con = ref.watch(connectionProvider(widget.simObjectId));

    final conAId = con.conAId;
    final conBId = con.conBId;

    final conAProvider = _getDeviceProvider(conAId);
    final conBProvider = _getDeviceProvider(conBId);

    final conAPosX = ref.watch(conAProvider(conAId).select((s) => s.posX));
    final conAPosY = ref.watch(conAProvider(conAId).select((s) => s.posY));
    final conBPosX = ref.watch(conBProvider(conBId).select((s) => s.posX));
    final conBPosY = ref.watch(conBProvider(conBId).select((s) => s.posY));

    final start = Offset(conAPosX, conAPosY);
    final end = Offset(conBPosX, conBPosY);
    final mid = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);

    return Stack(
      children: [
        IgnorePointer(
          child: CustomPaint(
            painter: _ConnectionLinePainter(
              colorScheme: Theme.of(context).colorScheme,
              start: start,
              end: end,
            ),
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
                color: Theme.of(
                  context,
                ).colorScheme.secondary.withValues(alpha: 0.7),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.onSurface,
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.circle,
                color: Theme.of(context).colorScheme.onSurface,
                size: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }

  NotifierProviderFamily<DeviceNotifier, Device, String> _getDeviceProvider(
    String deviceId,
  ) {
    if (deviceId.startsWith(SimObjectType.router.label)) {
      return switchProvider;
    } else if (deviceId.startsWith(SimObjectType.switch_.label)) {
      return switchProvider;
    }
    //* this 3 is the only possible scenario so it's fine
    return hostProvider;
  }

  void _handleTap() {
    //* TODO: handle Tap at connection
  }
}

class _ConnectionLinePainter extends CustomPainter {
  final ColorScheme colorScheme;
  final Offset start;
  final Offset end;

  const _ConnectionLinePainter({
    required this.colorScheme,
    required this.start,
    required this.end,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colorScheme.onSurface
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant _ConnectionLinePainter oldDelegate) {
    return oldDelegate.colorScheme != colorScheme ||
        oldDelegate.start != start ||
        oldDelegate.end != end;
  }
}
