import 'package:flutter/material.dart';

import '../../../core/utils/tuner_utils.dart';
import 'tuner_badge.dart';
import 'tuner_target_dialog.dart';

class TunerTargetWidget extends StatelessWidget {
  final double minFrequency;
  final double maxFrequency;
  final double? targetFrequency;
  final ValueChanged<double?> onChanged;
  final double size;

  const TunerTargetWidget({
    super.key,
    required this.targetFrequency,
    required this.onChanged,
    this.minFrequency = 40,
    this.maxFrequency = 20000,
    this.size = 48.0,
  }) : assert(minFrequency > 0),
       assert(maxFrequency >= minFrequency);

  @override
  Widget build(BuildContext context) {
    return TunerBadge(
      onTap: () {
        _showPicker(context);
      },
      child: Text(
        targetFrequency == null ? '-' : TunerUtils.midiToString(TunerUtils.frequencyToMidi(targetFrequency!)),
        style: TextTheme.of(context).bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _showPicker(BuildContext context) async {
    final minMidi = TunerUtils.frequencyToMidi(minFrequency).ceilToDouble();
    final maxMidi = TunerUtils.frequencyToMidi(maxFrequency).floorToDouble();

    double initialMidi;

    if (targetFrequency == null) {
      initialMidi = minMidi + (maxMidi - minMidi) / 2.0;
    } else {
      initialMidi = TunerUtils.frequencyToMidi(targetFrequency!).clamp(minMidi, maxMidi).roundToDouble();
    }

    var value = await showDialog<double>(
      context: context,
      builder: (context) => TunerTargetDialog(
        minMidi: minMidi,
        maxMidi: maxMidi,
        initialValue: initialMidi,
      ),
    );

    onChanged(value);
  }
}
