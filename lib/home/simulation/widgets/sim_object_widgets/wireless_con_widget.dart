part of 'sim_object_widget.dart';

class WirelessConWidget extends SimObjectWidget {
  const WirelessConWidget({super.key, required super.simObjectId});

  @override
  ConsumerState<WirelessConWidget> createState() => _WirelessConWidgetState();
}

class _WirelessConWidgetState extends _SimObjectWidgetState<WirelessConWidget> {
  @override
  Widget build(BuildContext context) {
    debugPrint('${widget.simObjectId} Rebuilt');

    final wirelessCon = ref.watch(wirelessConProvider(widget.simObjectId));

    final conAId = wirelessCon.conAId;
    final conBId = wirelessCon.conBId;

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
            painter: _WirelessConnectionLinePainter(
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
      return routerProvider;
    } else if (deviceId.startsWith(SimObjectType.switch_.label)) {
      return switchProvider;
    } else if (deviceId.startsWith(SimObjectType.accessPoint.label)) {
      return accessPointProvider;
    } else if (deviceId.startsWith(SimObjectType.wirelessHost.label)) {
      return wirelessHostProvider;
    }
    //* this 5 is the only possible scenario so it's fine
    return hostProvider;
  }

  void _handleTap() {
    ref
        .read(simScreenProvider.notifier)
        .setSelectedDeviceOnInfo(widget.simObjectId);

    if (ref.read(simScreenProvider).isInfoPanelOpen) {
      if (ref.read(simScreenProvider).selectedDeviceOnInfo.isEmpty) {
        ref.read(simScreenProvider.notifier).closeInfoPanel();
      }
    } else {
      if (ref.read(simScreenProvider).selectedDeviceOnInfo.isNotEmpty) {
        ref.read(simScreenProvider.notifier).openInfoPanel();
      }
    }
  }
}

class _WirelessConnectionLinePainter extends CustomPainter {
  final ColorScheme colorScheme;
  final Offset start;
  final Offset end;

  const _WirelessConnectionLinePainter({
    required this.colorScheme,
    required this.start,
    required this.end,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colorScheme.onSurface
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    const dashWidth = 10.0;
    const dashSpace = 5.0;

    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final distance = sqrt(dx * dx + dy * dy);
    final dashCount = (distance / (dashWidth + dashSpace)).floor();

    final xStep = dx / dashCount;
    final yStep = dy / dashCount;

    double startX = start.dx;
    double startY = start.dy;

    for (int i = 0; i < dashCount; i++) {
      final endX = startX + xStep * (dashWidth / (dashWidth + dashSpace));
      final endY = startY + yStep * (dashWidth / (dashWidth + dashSpace));

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);

      startX += xStep;
      startY += yStep;
    }
  }

  @override
  bool shouldRepaint(covariant _WirelessConnectionLinePainter oldDelegate) {
    return oldDelegate.colorScheme != colorScheme ||
        oldDelegate.start != start ||
        oldDelegate.end != end;
  }
}
