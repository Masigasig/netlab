import 'package:flutter/material.dart';

class GridPainter extends CustomPainter {
  final ColorScheme colorScheme;

  const GridPainter({required this.colorScheme});

  static const double _spacing = 50.0;
  static const double _major = _spacing * 5;
  static const double _axis = 1.0;
  static const double _majorLine = 0.5;
  static const double _minorLine = 0.5;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final axisPaint = Paint()
      ..color = colorScheme.onSurface
      ..strokeWidth = _axis;

    final majorPaint = Paint()
      ..color = colorScheme.onSurface
      ..strokeWidth = _majorLine;

    final minorPaint = Paint()
      ..color = colorScheme.onSurfaceVariant
      ..strokeWidth = _minorLine;

    void drawLines(bool vertical) {
      final length = vertical ? size.width : size.height;
      final centerCoord = vertical ? center.dx : center.dy;

      for (double pos = 0; pos <= length; pos += _spacing) {
        final dist = (pos - centerCoord).abs();
        final paint = (pos == centerCoord)
            ? axisPaint
            : (dist % _major == 0 ? majorPaint : minorPaint);

        final from = vertical ? Offset(pos, 0) : Offset(0, pos);
        final to = vertical
            ? Offset(pos, size.height)
            : Offset(size.width, pos);
        canvas.drawLine(from, to, paint);
      }
    }

    drawLines(true); // vertical
    drawLines(false); // horizontal

    canvas.drawCircle(center, 7, axisPaint);
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) => false;
}
