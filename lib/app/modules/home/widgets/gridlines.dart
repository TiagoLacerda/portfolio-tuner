import 'package:flutter/material.dart';

class Gridlines extends StatefulWidget {
  final Color? color;
  final double spacing;
  final double pixelsPerSecond;

  const Gridlines({
    super.key,
    this.color,
    this.spacing = 24.0,
    this.pixelsPerSecond = 24.0,
  });

  @override
  State<Gridlines> createState() => _GridlinesState();
}

class _GridlinesState extends State<Gridlines> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: (widget.spacing / widget.pixelsPerSecond * 1000).round(),
      ),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? ColorScheme.of(context).onSurface;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _GridPainter(
            animationValue: _controller.value,
            color: color.withValues(alpha: 0.25),
            spacing: widget.spacing,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _GridPainter extends CustomPainter {
  final double animationValue;
  final Color color;
  final double spacing;

  _GridPainter({
    required this.animationValue,
    required this.color,
    required this.spacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2.0;
    final centerY = size.height / 2.0;

    final offset = animationValue * spacing;

    final rect = Offset.zero & size;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.0
      ..isAntiAlias = false;

    canvas.saveLayer(rect, paint);

    final int horizontalLines = (size.height / spacing).ceil() + 2;
    final int verticalLines = (size.width / spacing).ceil() + 2;

    for (int i = -verticalLines; i <= verticalLines; i++) {
      final x = centerX + i * spacing;

      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    for (int i = -horizontalLines; i <= horizontalLines; i++) {
      final y = centerY + offset + i * spacing;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      Paint()
        ..color = color.withValues(alpha: 0.5)
        ..strokeWidth = 2.0
        ..isAntiAlias = false,
    );

    canvas.drawRect(
      rect,
      Paint()
        ..blendMode = BlendMode.dstIn
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.white,
            Colors.white,
            Colors.transparent,
          ],
          stops: [0.0, 0.1, 0.9, 1.0],
        ).createShader(rect),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) => oldDelegate.animationValue != animationValue;
}
