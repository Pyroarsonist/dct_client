import 'package:dct_client/config.dart';
import 'package:dct_client/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';

import 'jobs/main.dart';
import 'logger.dart';
import 'push_notifications.dart';
import 'routes.dart';
import 'services/navigation_service.dart';

Future<void> main() async {
  logger.v('Starting app');

  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  Config.ensureVariables();
  await initPushNotifications();
  initJobs();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      initialRoute: initialRoute,
      routes: routes,
      navigatorKey: NavigationService.navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
