import 'dart:ui';

import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/generated/modular_localization.dart';
import 'tuner_target_dialog_table.dart';

class TunerTargetDialog extends StatefulWidget {
  final double minMidi;
  final double maxMidi;
  final double? initialValue;
  final double spacing;
  final EdgeInsetsGeometry padding;
  final localizations = ModularLocalization.localizations.modules.home.widgets.tunerTargetDialog;

  TunerTargetDialog({
    super.key,
    required this.minMidi,
    required this.maxMidi,
    this.initialValue,
    this.spacing = 16.0,
    this.padding = const EdgeInsets.all(
      16.0,
    ),
  });

  @override
  State<TunerTargetDialog> createState() => _TunerTargetDialogState();
}

class _TunerTargetDialogState extends State<TunerTargetDialog> {
  double? value;

  @override
  void initState() {
    super.initState();

    value = widget.initialValue ?? widget.minMidi + (widget.maxMidi - widget.minMidi) / 2.0;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final colorScheme = ColorScheme.of(context);

    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 1.4,
        sigmaY: 1.4,
      ),
      child: Scrollbar(
        interactive: true,
        child: Center(
          child: SingleChildScrollView(
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(
                  16.0,
                ),
              ),
              backgroundColor: colorScheme.surface.withValues(alpha: 0.9),
              child: Padding(
                padding: widget.padding,
                child: IntrinsicWidth(
                  child: Column(
                    spacing: widget.spacing,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        spacing: widget.spacing,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.localizations.title,
                              style: textTheme.titleMedium,
                            ),
                          ),
                          IconButton(
                            onPressed: () => context.pop(widget.initialValue),
                            icon: Icon(
                              Icons.close_rounded,
                            ),
                          ),
                        ],
                      ),
                      Scrollbar(
                        interactive: true,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ClipRRect(
                            borderRadius: BorderRadiusDirectional.circular(
                              8.0,
                            ),
                            child: TunerTargetDialogTable(
                              minValue: widget.minMidi,
                              maxValue: widget.maxMidi,
                              initialValue: value,
                              onSelected: (value) => setState(() => this.value = value),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        spacing: widget.spacing,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => context.pop(null),
                            child: Row(
                              spacing: widget.spacing,
                              children: [
                                Text(widget.localizations.clear),
                                Icon(Icons.clear_rounded),
                              ],
                            ),
                          ),
                          FilledButton(
                            onPressed: () => context.pop(value),
                            child: Row(
                              spacing: widget.spacing,
                              children: [
                                Text(widget.localizations.select),
                                Icon(Icons.check_rounded),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
