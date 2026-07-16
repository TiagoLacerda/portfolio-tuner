import 'package:go_router/go_router.dart';

import '../../app_controller.dart';
import '../../modules/home/home_module.dart';

final routerConfig = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeModule(),
    ),
  ],
  navigatorKey: AppController.instance.navigatorKey,
);
