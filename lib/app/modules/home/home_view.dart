import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:overlay_options_button/overlay_options_button.dart';
import 'package:portfolio_design_system/portfolio_design_system.dart';

import '../../../l10n/generated/modular_localization.dart';
import '../../app_controller.dart';
import '../../core/adapters/permissions.dart';
import '../../core/enums/permission_status.dart';
import 'home_controller.dart';
import 'widgets/gridlines.dart';
import 'widgets/microphone_access_dialog.dart';
import 'widgets/tuner_widget.dart';

class HomeView extends StatelessWidget {
  final HomeController controller;
  final double spacing;

  final localizations = ModularLocalization.localizations.modules.home.homeView;

  HomeView({super.key, required this.controller, this.spacing = 40.0});

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          final textTheme = TextTheme.of(context);
          final colorScheme = ColorScheme.of(context);

          final textStyleNormal = textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          );

          final aboutStyleHighlight = textTheme.titleMedium?.copyWith(
            color: colorScheme.primary,
          );

          final brightnessSwitch = PortfolioBrightnessSwitch(
            onPressed: () => AppController.instance.toggleThemeMode(),
          );

          final localeButton = OverlayOptionsButton(
            initialValue: AppController.instance.locale,
            items: AppController.instance.supportedLocales,
            onChanged: (value) => AppController.instance.locale = value,
            itemBuilder: (context, index, value, select) {
              final assetName = switch (value.languageCode) {
                'pt' => PortfolioIcons.pt,
                'en' => PortfolioIcons.en,
                _ => PortfolioIcons.pt,
              };

              return IconButton(
                onPressed: () => select(),
                icon: SizedBox.square(
                  dimension: 24.0,
                  child: ClipOval(
                    child: SvgPicture.asset(
                      assetName,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          );

          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 80.0,
              elevation: 3.0,
              actions: [
                Expanded(
                  child: Center(
                    child: PortfolioResponsiveBox(
                      child: Padding(
                        padding: EdgeInsetsGeometry.symmetric(
                          horizontal: spacing,
                        ),
                        child: Row(
                          children: [
                            brightnessSwitch,
                            localeButton,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: Stack(
              fit: StackFit.expand,
              children: [
                Gridlines(),
                SafeArea(
                  child: Center(
                    child: PortfolioResponsiveBox(
                      child: Padding(
                        padding: EdgeInsets.all(
                          spacing,
                        ),
                        child: Column(
                          spacing: spacing,
                          children: [
                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: SizedBox(
                                      width: constraints.maxWidth,
                                      child: Text.rich(
                                        textAlign: TextAlign.justify,
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: localizations.body0,
                                              style: textStyleNormal,
                                            ),
                                            TextSpan(
                                              text: localizations.body1,
                                              style: aboutStyleHighlight,
                                            ),
                                            TextSpan(
                                              text: localizations.body2,
                                              style: textStyleNormal,
                                            ),
                                            TextSpan(
                                              text: localizations.body3,
                                              style: aboutStyleHighlight,
                                            ),
                                            TextSpan(
                                              text: localizations.body4,
                                              style: textStyleNormal,
                                            ),
                                            TextSpan(
                                              text: '\n\n',
                                            ),
                                            TextSpan(
                                              text: localizations.body5,
                                              style: textStyleNormal,
                                            ),
                                            TextSpan(
                                              text: localizations.body6,
                                              style: aboutStyleHighlight,
                                            ),
                                            TextSpan(
                                              text: localizations.body7,
                                              style: textStyleNormal,
                                            ),
                                            TextSpan(
                                              text: localizations.body8,
                                              style: aboutStyleHighlight,
                                            ),
                                            TextSpan(
                                              text: localizations.body9,
                                              style: textStyleNormal,
                                            ),
                                            TextSpan(
                                              text: localizations.body10,
                                              style: aboutStyleHighlight,
                                            ),
                                            TextSpan(
                                              text: localizations.body11,
                                              style: textStyleNormal,
                                            ),
                                            TextSpan(
                                              text: localizations.body12,
                                              style: aboutStyleHighlight,
                                            ),
                                            TextSpan(
                                              text: localizations.body13,
                                              style: textStyleNormal,
                                            ),
                                            TextSpan(
                                              text: '\n\n',
                                            ),
                                            TextSpan(
                                              text: localizations.body14,
                                              style: textStyleNormal,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: controller.isAudioEngineRunning
                                  ? TunerWidget(
                                      minFrequency: controller.minFrequency,
                                      maxFrequency: controller.maxFrequency,
                                      frequencies: controller.stream,
                                      targetFrequency: 440,
                                    )
                                  : Center(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          final status = await microphonePermission();

                                          if (!context.mounted) return;

                                          switch (status) {
                                            case PermissionStatus.denied:
                                              showDialog(
                                                context: context,
                                                builder: (context) => MicrophoneAccessDialog(),
                                              );
                                              break;

                                            case PermissionStatus.granted:
                                            case PermissionStatus.prompt:
                                            case PermissionStatus.unsupported:
                                              controller.startAudioEngine();
                                              break;
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorScheme.of(context).primary,
                                          foregroundColor: ColorScheme.of(context).onPrimary,
                                        ),
                                        child: Row(
                                          spacing: 8.0,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(localizations.button),
                                            Icon(Icons.mic_rounded),
                                          ],
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
