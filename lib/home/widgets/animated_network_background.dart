import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedNetworkBackground extends StatefulWidget {
  final int numberOfNodes;
  final Color nodeColor;
  final Color backgroundColor;
  final Color pointerNodeColor;
  final double connectionOpacity;
  final double connectionDistance;
  final double pointerConnectionDistance;
  final double nodeSpeed;

  const AnimatedNetworkBackground({
    super.key,
    this.numberOfNodes = 40,
    this.nodeColor = Colors.blue,
    this.backgroundColor = const Color(0xFF0D1117),
    this.pointerNodeColor = Colors.cyan,
    this.connectionOpacity = 0.15,
    this.connectionDistance = 150.0,
    this.pointerConnectionDistance = 200.0,
    this.nodeSpeed = 0.5,
  }) : assert(
         connectionOpacity >= 0.0 && connectionOpacity <= 1.0,
         'connectionOpacity must be between 0.0 and 1.0',
       ),
       assert(
         nodeSpeed >= 0.0,
         'nodeSpeed must be greater than or equal to 0.0',
       );

  @override
  State<AnimatedNetworkBackground> createState() =>
      _AnimatedNetworkBackgroundState();
}

class _AnimatedNetworkBackgroundState extends State<AnimatedNetworkBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Node> _nodes;
  final Random _random = Random();
  Offset? _pointerPosition;
  bool _isPointerActive = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(days: 1))
          ..addListener(() {
            setState(() {
              _updateNodes();
            });
          });
    _controller.repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeNodes();
  }

  void _initializeNodes() {
    final size = MediaQuery.of(context).size;

    _nodes = List.generate(widget.numberOfNodes, (index) {
      return Node(
        position: Offset(
          _random.nextDouble() * size.width,
          _random.nextDouble() * size.height,
        ),
        velocity: Offset(
          (_random.nextDouble() - 0.5) * widget.nodeSpeed,
          (_random.nextDouble() - 0.5) * widget.nodeSpeed,
        ),
        radius: _random.nextDouble() * 2 + 1.5,
      );
    });
  }

  void _updateNodes() {
    final size = MediaQuery.of(context).size;

    for (var node in _nodes) {
      node.position += node.velocity;

      //* Bounce off edges
      if (node.position.dx <= 0 || node.position.dx >= size.width) {
        node.velocity = Offset(-node.velocity.dx, node.velocity.dy);
        node.position = Offset(
          node.position.dx.clamp(0, size.width),
          node.position.dy,
        );
      }
      if (node.position.dy <= 0 || node.position.dy >= size.height) {
        node.velocity = Offset(node.velocity.dx, -node.velocity.dy);
        node.position = Offset(
          node.position.dx,
          node.position.dy.clamp(0, size.height),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: MouseRegion(
        onHover: (event) {
          setState(() {
            _pointerPosition = event.localPosition;
            _isPointerActive = true;
          });
        },
        onExit: (event) {
          setState(() {
            _isPointerActive = false;
          });
        },
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _pointerPosition = details.localPosition;
              _isPointerActive = true;
            });
          },
          onPanEnd: (details) {
            setState(() {
              _isPointerActive = false;
            });
          },
          onTapDown: (details) {
            setState(() {
              _pointerPosition = details.localPosition;
              _isPointerActive = true;
            });
          },
          onTapUp: (details) {
            setState(() {
              _isPointerActive = false;
            });
          },
          child: CustomPaint(
            painter: NetworkPainter(
              nodes: _nodes,
              pointerPosition: _pointerPosition,
              isPointerActive: _isPointerActive,
              nodeColor: widget.nodeColor,
              pointerNodeColor: widget.pointerNodeColor,
              connectionOpacity: widget.connectionOpacity,
              connectionDistance: widget.connectionDistance,
              pointerConnectionDistance: widget.pointerConnectionDistance,
            ),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }
}

class Node {
  Offset position;
  Offset velocity;
  final double radius;

  Node({required this.position, required this.velocity, required this.radius});
}

class NetworkPainter extends CustomPainter {
  final List<Node> nodes;
  final Offset? pointerPosition;
  final bool isPointerActive;
  final Color nodeColor;
  final Color pointerNodeColor;
  final double connectionOpacity;
  final double connectionDistance;
  final double pointerConnectionDistance;

  NetworkPainter({
    required this.nodes,
    this.pointerPosition,
    required this.isPointerActive,
    required this.nodeColor,
    required this.pointerNodeColor,
    required this.connectionOpacity,
    required this.connectionDistance,
    required this.pointerConnectionDistance,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final nodePaint = Paint()
      ..color = nodeColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = nodeColor.withValues(alpha: connectionOpacity)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final pointerLinePaint = Paint()
      ..color = pointerNodeColor.withValues(
        alpha: (connectionOpacity * 2.5).clamp(0.0, 1.0),
      )
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    //* Draw connections between nodes
    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        final distance = (nodes[i].position - nodes[j].position).distance;

        if (distance < connectionDistance) {
          final opacity =
              ((1 - distance / connectionDistance) * connectionOpacity).clamp(
                0.0,
                1.0,
              );
          linePaint.color = nodeColor.withValues(alpha: opacity);
          canvas.drawLine(nodes[i].position, nodes[j].position, linePaint);
        }
      }
    }

    //* Draw connections from pointer to nearby nodes
    if (isPointerActive && pointerPosition != null) {
      for (var node in nodes) {
        final distance = (node.position - pointerPosition!).distance;

        if (distance < pointerConnectionDistance) {
          final opacity =
              ((1 - distance / pointerConnectionDistance) *
                      connectionOpacity *
                      2.5)
                  .clamp(0.0, 1.0);
          pointerLinePaint.color = pointerNodeColor.withValues(alpha: opacity);
          pointerLinePaint.strokeWidth =
              1.5 + (1 - distance / pointerConnectionDistance) * 1.5;
          canvas.drawLine(pointerPosition!, node.position, pointerLinePaint);
        }
      }

      //* Draw pointer node with pulse effect
      final pointerNodePaint = Paint()
        ..color = pointerNodeColor.withValues(alpha: 0.8)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(pointerPosition!, 5, pointerNodePaint);

      //* Draw outer glow for pointer
      final pointerGlowPaint = Paint()
        ..color = pointerNodeColor.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(pointerPosition!, 8, pointerGlowPaint);

      //* Draw pulsing ring
      final ringPaint = Paint()
        ..color = pointerNodeColor.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(pointerPosition!, 12, ringPaint);
    }

    //* Draw nodes
    for (var node in nodes) {
      //* Check if node is near pointer and highlight it
      bool isNearPointer = false;
      if (isPointerActive && pointerPosition != null) {
        final distance = (node.position - pointerPosition!).distance;
        isNearPointer = distance < pointerConnectionDistance;
      }

      if (isNearPointer) {
        nodePaint.color = pointerNodeColor.withValues(alpha: 0.9);
        canvas.drawCircle(node.position, node.radius + 1, nodePaint);

        //* Enhanced glow for nodes near pointer
        final enhancedGlowPaint = Paint()
          ..color = pointerNodeColor.withValues(alpha: 0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
        canvas.drawCircle(node.position, node.radius + 4, enhancedGlowPaint);
      } else {
        nodePaint.color = nodeColor.withValues(alpha: 0.6);
        canvas.drawCircle(node.position, node.radius, nodePaint);

        //* Normal glow effect
        final glowPaint = Paint()
          ..color = nodeColor.withValues(alpha: 0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
        canvas.drawCircle(node.position, node.radius + 2, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(NetworkPainter oldDelegate) => true;
}
