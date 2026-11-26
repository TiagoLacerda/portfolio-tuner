import 'package:material_ui/material_ui.dart';

/// Tick marks at -50, -25, 0, +25 and +50 cents, aligned with the needle's horizontal travel.
class TunerScale extends StatelessWidget {
  final double badgeSize;
  final double height;
  final Color? color;

  const TunerScale({
    super.key,
    required this.badgeSize,
    this.height = 8.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _TunerScalePainter(
          badgeSize: badgeSize,
          color: color ?? ColorScheme.of(context).onSurface.withValues(alpha: 0.25),
        ),
      ),
    );
  }
}

class _TunerScalePainter extends CustomPainter {
  /// Offsets in semitones, with whether each tick is a major one.
  static const _ticks = [
    (-0.5, true),
    (-0.25, false),
    (0.0, true),
    (0.25, false),
    (0.5, true),
  ];

  final double badgeSize;
  final Color color;

  const _TunerScalePainter({
    required this.badgeSize,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    for (final (offset, major) in _ticks) {
      final alignmentX = offset / (2 + offset.abs());
      final x = badgeSize / 2 + (alignmentX + 1) / 2 * (size.width - badgeSize);
      final tickHeight = major ? size.height : size.height / 2;

      canvas.drawLine(Offset(x, 0), Offset(x, tickHeight), paint);
    }
  }

  @override
  bool shouldRepaint(_TunerScalePainter oldDelegate) {
    return badgeSize != oldDelegate.badgeSize || color != oldDelegate.color;
  }
}
