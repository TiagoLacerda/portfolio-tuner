import 'dart:math';

import 'package:material_ui/material_ui.dart';

class Triangle extends StatelessWidget {
  final Point a;
  final Point b;
  final Point c;
  final Color? color;
  late final double width;
  late final double height;
  late final double minX;
  late final double minY;

  Triangle({
    super.key,
    required this.a,
    required this.b,
    required this.c,
    this.color,
  }) : assert(a != b && b != c) {
    minX = min(a.x, min(b.x, c.x)).toDouble();
    minY = min(a.y, min(b.y, c.y)).toDouble();

    var maxX = max(a.x, max(b.x, c.x)).toDouble();
    var maxY = max(a.y, max(b.y, c.y)).toDouble();

    width = maxX - minX;
    height = maxY - minY;
  }

  factory Triangle.isosceles({
    required double width,
    required double height,
    Color? color,
  }) {
    assert(width > 0);
    assert(height > 0);

    return Triangle(
      a: Point(width / 2, 0),
      b: Point(0, height),
      c: Point(width, height),
      color: color,
    );
  }

  factory Triangle.equilateral({
    required double side,
    Color? color,
  }) {
    assert(side > 0);

    return Triangle.isosceles(
      width: side,
      height: side * sqrt(3) / 2,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: TrianglePainter(
          a: a,
          b: b,
          c: c,
          color: color ?? ColorScheme.of(context).primary,
          width: width,
          height: height,
          minX: minX,
          minY: minY,
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Point a;
  final Point b;
  final Point c;
  final Color color;
  final double width;
  final double height;
  final double minX;
  final double minY;

  TrianglePainter({
    required this.a,
    required this.b,
    required this.c,
    required this.color,
    required this.width,
    required this.height,
    required this.minX,
    required this.minY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Offset normalize(Point point) => Offset(
      (point.x - minX) / width * size.width,
      (point.y - minY) / height * size.height,
    );

    final path = Path()
      ..moveTo(normalize(a).dx, normalize(a).dy)
      ..lineTo(normalize(b).dx, normalize(b).dy)
      ..lineTo(normalize(c).dx, normalize(c).dy)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill
        ..isAntiAlias = true,
    );
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return a != oldDelegate.a || b != oldDelegate.b || c != oldDelegate.c || color != oldDelegate.color;
  }
}
