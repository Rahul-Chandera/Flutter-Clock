import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'hand.dart';

class SecondHand extends Hand {
  const SecondHand({
    @required Color color,
    @required this.thickness,
    @required double size,
    @required double angleRadians,
  })  : assert(color != null),
        assert(thickness != null),
        assert(size != null),
        assert(angleRadians != null),
        super(
          color: color,
          size: size,
          angleRadians: angleRadians,
        );

  final double thickness;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _HandPainter(
              handSize: size,
              lineWidth: thickness,
              angleRadians: angleRadians,
              color: color),
        ),
      ),
    );
  }
}

class _HandPainter extends CustomPainter {
  _HandPainter({
    @required this.handSize,
    @required this.lineWidth,
    @required this.angleRadians,
    @required this.color,
  })  : assert(handSize != null),
        assert(lineWidth != null),
        assert(angleRadians != null),
        assert(color != null),
        assert(handSize >= 0.0),
        assert(handSize <= 1.0);

  double handSize;
  double lineWidth;
  double angleRadians;
  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;
    final angle = angleRadians - math.pi / 2.0;
    final radius = size.shortestSide * 0.5 * handSize;

    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    final secondHandPaint = Paint();
    secondHandPaint.color = color;
    secondHandPaint.style = PaintingStyle.stroke;
    secondHandPaint.strokeWidth = 2.0;

    final secondHandPointsPaint = Paint();
    secondHandPointsPaint.color = color;
    secondHandPointsPaint.style = PaintingStyle.fill;

    Path path1 = new Path();
    Path path2 = new Path();
    path1.moveTo(0.0, -radius);
    path1.lineTo(0.0, radius / 4);

    path2.addOval(
        new Rect.fromCircle(radius: 7.0, center: new Offset(0.0, -radius)));
    path2.addOval(
        new Rect.fromCircle(radius: 5.0, center: new Offset(0.0, 0.0)));

    canvas.drawPath(path1, secondHandPaint);
    canvas.drawPath(path2, secondHandPointsPaint);
  }

  @override
  bool shouldRepaint(_HandPainter oldDelegate) {
    return oldDelegate.handSize != handSize ||
        oldDelegate.lineWidth != lineWidth ||
        oldDelegate.angleRadians != angleRadians ||
        oldDelegate.color != color;
  }
}
