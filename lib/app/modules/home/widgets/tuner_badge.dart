import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'triangle.dart';

class TunerBadge extends StatelessWidget {
  final VoidCallback? onTap;
  final double size;
  final double borderWidth;
  final Color? borderColor;
  final Widget? child;
  final bool showBottomNotch;

  const TunerBadge({
    super.key,
    this.onTap,
    this.size = 48.0,
    this.borderWidth = 3.0,
    this.borderColor,
    this.child,
    this.showBottomNotch = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    Widget widget = DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: BoxBorder.all(
          width: borderWidth,
          color: borderColor ?? colorScheme.onSurface,
        ),
        color: colorScheme.surface.withValues(
          alpha: 0.5,
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );

    if (onTap != null) {
      widget = Material(
        clipBehavior: Clip.antiAlias,
        color: Colors.transparent,
        shape: CircleBorder(),
        child: InkWell(
          onTap: onTap,
          child: widget,
        ),
      );
    }

    widget = SizedBox.square(
      dimension: size,
      child: widget,
    );

    if (showBottomNotch) {
      widget = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget,
          Transform.rotate(
            angle: math.pi,
            child: Transform.translate(
              offset: Offset(0.0, 1.0),
              child: Triangle.equilateral(
                side: 12.0,
                color: borderColor,
              ),
            ),
          ),
        ],
      );
    }

    return widget;
  }
}
