import 'dart:developer';

import 'package:flutter/material.dart';

import 'core/adapters/cookie.dart';

class AppController extends ChangeNotifier {
  static final AppController _instance = AppController._internal();

  static AppController get instance => _instance;

  AppController._internal() {
    try {
      final cookie = Cookie.get('theme_mode');

      _themeMode = switch (cookie) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
    } catch (e) {
      log(e.toString());
    }

    try {
      final cookie = Cookie.get('locale');

      if (cookie != null) {
        _locale = supportedLocales.firstWhere(
          (locale) => locale.toString() == cookie,
          orElse: () => supportedLocales.first,
        );
      }
    } catch (e) {
      log(e.toString());
    }
  }

  factory AppController() => _instance;

  final navigatorKey = GlobalKey<NavigatorState>();
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  late Locale _locale = supportedLocales.first;
  Locale get locale => _locale;
  set locale(Locale newValue) {
    _locale = newValue;
    notifyListeners();

    Cookie.set(
      'locale',
      newValue.toString(),
      domain: 'tiagomlbrasil.com',
    );
  }

  final supportedLocales = [
    const Locale('pt'),
    const Locale('en'),
  ];

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode newValue) {
    _themeMode = newValue;
    notifyListeners();

    Cookie.set(
      'theme_mode',
      switch (newValue) {
        ThemeMode.system => 'system',
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
      },
      domain: 'tiagomlbrasil.com',
    );
  }

  void toggleThemeMode() {
    final context = navigatorKey.currentContext!;

    if (Theme.of(context).brightness == Brightness.dark) {
      themeMode = ThemeMode.light;
    } else {
      themeMode = ThemeMode.dark;
    }
  }
}
