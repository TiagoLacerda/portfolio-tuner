import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

class TrailPoint {
  final double value;
  final DateTime dateTime;

  const TrailPoint({
    required this.value,
    required this.dateTime,
  });
}

class Trail extends StatefulWidget {
  final Stream<TrailPoint> values;
  final double badgeSize;

  const Trail({
    super.key,
    required this.values,
    required this.badgeSize,
  });

  @override
  State<Trail> createState() => _TrailState();
}

class _TrailState extends State<Trail> {
  final _buffer = Queue<TrailPoint>();

  final trailPointLifetime = const Duration(seconds: 10);

  StreamSubscription<TrailPoint>? _subscription;
  Timer? _timer;

  void listener(TrailPoint trailPoint) => setState(() => _buffer.addFirst(trailPoint));

  @override
  void initState() {
    super.initState();

    _subscription = widget.values.listen(listener);
    _timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      final limit = DateTime.now().subtract(trailPointLifetime);

      // TODO: Is this optimal use of setState?
      setState(() {
        while (_buffer.isNotEmpty && _buffer.last.dateTime.isBefore(limit)) {
          _buffer.removeLast();
        }
      });
    });
  }

  @override
  void didUpdateWidget(covariant Trail oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.values != oldWidget.values) {
      _subscription?.cancel();
      _subscription = widget.values.listen(listener);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TrailPainter(
        values: List.unmodifiable(_buffer),
        trailPointLifetime: trailPointLifetime,
      ),
    );
  }
}

class _TrailPainter extends CustomPainter {
  final List<TrailPoint> values;
  final Duration trailPointLifetime;
  final double pointRadius;
  final double pixelsPerSecond;

  const _TrailPainter({
    required this.values,
    required this.trailPointLifetime,
  }) : pointRadius = 2.0,
       pixelsPerSecond = 24.0;

  @override
  void paint(Canvas canvas, Size size) {
    final now = DateTime.now();

    for (final trailPoint in values) {
      final elapsedSeconds = now.difference(trailPoint.dateTime).inMilliseconds / 1000.0;
      final y = elapsedSeconds * pixelsPerSecond - pointRadius;
      final progress = (elapsedSeconds / trailPointLifetime.inSeconds.toDouble()).clamp(0, 1).toDouble();
      final value = trailPoint.value.clamp(-1.0, 1.0).toDouble();
      final color = Color.lerp(Colors.green, Colors.red, value.abs())!.withValues(alpha: 1.0 - progress);
      final paint = Paint()
        ..color = color
        ..strokeWidth = 0.0
        ..isAntiAlias = true;
      final x = 24.0 + ((value + 1.0) / 2.0) * (size.width - 48.0);

      canvas.drawCircle(Offset(x, y), pointRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TrailPainter oldDelegate) => true;
}
