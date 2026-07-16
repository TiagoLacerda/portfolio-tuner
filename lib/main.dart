import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app/app_module.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  usePathUrlStrategy();

  LicenseRegistry.addLicense(() async* {
    final String license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(<String>['google_fonts'], license);
  });

  runApp(
    const AppModule(),
  );
}
