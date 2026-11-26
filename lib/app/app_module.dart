import 'package:material_ui/material_ui.dart';

import 'app_controller.dart';
import 'app_view.dart';

class AppModule extends StatefulWidget {
  const AppModule({super.key});

  @override
  State<AppModule> createState() => _AppModuleState();
}

class _AppModuleState extends State<AppModule> {
  late final AppController controller;

  @override
  void initState() {
    super.initState();

    controller = AppController();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppView(
      controller: controller,
    );
  }
}
