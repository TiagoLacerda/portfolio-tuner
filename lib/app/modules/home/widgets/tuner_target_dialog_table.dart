import 'package:material_ui/material_ui.dart';

import '../../../core/utils/tuner_utils.dart';

class TunerTargetDialogTable extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final double? initialValue;
  final void Function(double) onSelected;
  final double spacing;
  final EdgeInsetsGeometry padding;

  const TunerTargetDialogTable({
    super.key,

    required this.minValue,
    required this.maxValue,
    required this.onSelected,
    this.initialValue,
    this.spacing = 16.0,
    this.padding = const EdgeInsets.all(
      16.0,
    ),
  });

  @override
  State<TunerTargetDialogTable> createState() => _TunerTargetDialogTableState();
}

class _TunerTargetDialogTableState extends State<TunerTargetDialogTable> {
  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final colorScheme = ColorScheme.of(context);

    final notes = 12;
    final minMidi = widget.minValue.ceil();
    final maxMidi = widget.maxValue.floor();
    final minOctave = minMidi ~/ notes - 1;
    final maxOctave = maxMidi ~/ notes - 1;

    final rows = <TableRow>[];

    for (int octave = minOctave; octave <= maxOctave; ++octave) {
      final cells = <TableCell>[];

      for (int note = 0; note < notes; ++note) {
        final midi = (octave + 1.0) * notes + note;
        final frequency = TunerUtils.midiToFrequency(midi);

        final midiString = TunerUtils.midiToString(midi);
        final frequencyString = (frequency == frequency.round() ? '' : '~') + frequency.toStringAsFixed(0);

        final foregroundColor = widget.initialValue == midi ? colorScheme.onPrimary : colorScheme.onSurface;
        final backgroundColor = widget.initialValue == midi
            ? colorScheme.primary
            : colorScheme.onSurface.withValues(alpha: midi % 2 == 0 ? 1 / 16 : 1 / 32);

        final isInRange = midi >= minMidi && midi <= maxMidi;

        Widget child;

        if (!isInRange) {
          child = SizedBox.shrink();
        } else {
          child = Padding(
            padding: const EdgeInsets.all(
              8.0,
            ),
            child: Column(
              children: [
                Text(
                  midiString,
                  style: textTheme.titleMedium?.copyWith(
                    color: foregroundColor,
                  ),
                  maxLines: 1,
                ),
                Text(
                  frequencyString,
                  style: textTheme.labelMedium?.copyWith(
                    color: foregroundColor,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          );
        }

        cells.add(
          TableCell(
            child: InkWell(
              onTap: isInRange ? () => widget.onSelected(midi.toDouble()) : null,
              child: ColoredBox(
                color: backgroundColor,
                child: child,
              ),
            ),
          ),
        );
      }

      rows.add(
        TableRow(
          children: cells,
        ),
      );
    }

    return Table(
      children: rows,
      defaultColumnWidth: IntrinsicColumnWidth(),
    );
  }
}
