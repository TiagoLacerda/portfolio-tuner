import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_design_system/portfolio_design_system.dart';

import '../../../../l10n/generated/modular_localization.dart';

class MicrophoneAccessDialog extends StatelessWidget {
  final double spacing;
  final EdgeInsetsGeometry padding;
  final localizations = ModularLocalization.localizations.modules.home.widgets.microphoneAccessDialog;

  MicrophoneAccessDialog({
    super.key,
    this.spacing = 16.0,
    this.padding = const EdgeInsets.all(
      16.0,
    ),
  });

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
              child: PortfolioResponsiveBox(
                widthAtViewportStart: 300,
                widthAtViewportEnd: 400,
                child: Padding(
                  padding: padding,
                  child: IntrinsicWidth(
                    child: Column(
                      spacing: spacing,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          spacing: spacing,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                localizations.title,
                                style: textTheme.titleMedium,
                              ),
                            ),
                            IconButton(
                              onPressed: () => context.pop(),
                              icon: Icon(
                                Icons.close_rounded,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          localizations.body,
                          style: textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () => context.pop(),
                          child: Text(
                            localizations.button,
                          ),
                        ),
                      ],
                    ),
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
