import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

import '../../../../l10n/generated/modular_localization.dart';
import '../../../core/utils/tuner_utils.dart';
import 'trail.dart';
import 'tuner_badge.dart';
import 'tuner_scale.dart';
import 'tuner_target_widget.dart';

class TunerWidget extends StatefulWidget {
  final double minFrequency;
  final double maxFrequency;
  final Stream<double> frequencies;
  final double? targetFrequency;
  final double badgeSize;
  final double spacing;

  const TunerWidget({
    super.key,
    required this.minFrequency,
    required this.maxFrequency,
    required this.frequencies,
    this.targetFrequency,
    this.badgeSize = 48.0,
    this.spacing = 16.0,
  });

  @override
  State<TunerWidget> createState() => _TunerWidgetState();
}

class _TunerWidgetState extends State<TunerWidget> {
  static const _medianLength = 5;

  /// How long without a valid estimate before the reading is cleared.
  static const _signalTimeout = Duration(milliseconds: 400);

  double? _midi;
  double? _targetMidi;

  final _recentMidi = Queue<double>();
  Timer? _signalTimer;

  StreamSubscription? subscription;

  StreamController<TrailPoint> trailPointStream = StreamController.broadcast();

  void listener(double value) {
    _signalTimer?.cancel();
    _signalTimer = Timer(_signalTimeout, _onSignalLost);

    _recentMidi.addLast(TunerUtils.frequencyToMidi(value));

    if (_recentMidi.length > _medianLength) {
      _recentMidi.removeFirst();
    }

    final sorted = _recentMidi.toList()..sort();

    setState(() {
      _midi = sorted[sorted.length ~/ 2];

      final current = _midi!;
      final target = _targetMidi ?? current.roundToDouble();
      final offset = current - target;
      final alignmentX = offset / (2 + offset.abs());

      trailPointStream.sink.add(
        TrailPoint(
          value: alignmentX,
          dateTime: DateTime.now(),
        ),
      );
    });
  }

  void _onSignalLost() {
    _recentMidi.clear();

    setState(() => _midi = null);
  }

  @override
  void initState() {
    super.initState();

    if (widget.targetFrequency != null) _targetMidi = TunerUtils.frequencyToMidi(widget.targetFrequency!);

    subscription = widget.frequencies.listen(listener);
  }

  @override
  void didUpdateWidget(covariant TunerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.frequencies != oldWidget.frequencies) {
      subscription?.cancel();
      subscription = widget.frequencies.listen(listener);
    }
  }

  @override
  void dispose() {
    subscription?.cancel();
    _signalTimer?.cancel();
    trailPointStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    var color = colorScheme.onSurface;
    var alignmentX = 0.0;
    var text = '';

    if (_midi != null) {
      final midi = _midi!;
      final targetMidi = _targetMidi ?? midi.roundToDouble();

      final offset = midi - targetMidi;

      alignmentX = offset / (2 + offset.abs());
      color = Color.lerp(Colors.green, Colors.red, alignmentX.abs())!;

      final cents = (offset * 100).round();
      text = cents > 0 ? '+$cents' : '$cents';
    }

    double? targetFrequency;

    if (_targetMidi != null) {
      targetFrequency = TunerUtils.midiToFrequency(_targetMidi!);
    } else if (_midi != null) {
      targetFrequency = TunerUtils.midiToFrequency(_midi!.roundToDouble());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TunerTargetWidget(
          minFrequency: widget.minFrequency,
          maxFrequency: widget.maxFrequency,
          targetFrequency: targetFrequency,
          onChanged: (value) {
            setState(() {
              _targetMidi = value;
            });
          },
          size: widget.badgeSize,
        ),
        SizedBox(
          height: widget.spacing,
        ),
        AnimatedAlign(
          alignment: Alignment(alignmentX, 0.0),
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          child: TunerBadge(
            size: widget.badgeSize,
            borderColor: color,
            showBottomNotch: true,
            child: Text(
              text,
              style: TextTheme.of(context).bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color
              ),
            ),
          ),
        ),
        TunerScale(
          badgeSize: widget.badgeSize,
        ),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Trail(
                values: trailPointStream.stream,
                badgeSize: widget.badgeSize,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: widget.spacing,
                  ),
                  child: AnimatedOpacity(
                    opacity: _midi == null ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      ModularLocalization.localizations.modules.home.widgets.tunerWidget.hint,
                      style: TextTheme.of(context).bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
