import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:portfolio_design_system/portfolio_design_system.dart';

import '../l10n/generated/modular_localization.dart';
import 'app_controller.dart';
import 'core/router/router.dart';

class AppView extends StatelessWidget {
  final AppController controller;

  const AppView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: MaterialApp.router(
            key: ValueKey(controller.locale),
            scaffoldMessengerKey: controller.scaffoldMessengerKey,
            title: 'Afinador',
            theme: PortfolioTheme.light,
            darkTheme: PortfolioTheme.dark,
            themeMode: controller.themeMode,
            debugShowCheckedModeBanner: false,
            locale: controller.locale,
            supportedLocales: controller.supportedLocales,
            localizationsDelegates: const [
              ModularLocalization.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: routerConfig,
          ),
        );
      },
    );
  }
}
