import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';

import 'jobs/main.dart';
import 'logger.dart';
import 'routes.dart';
import 'services/navigation_service.dart';

Future<void> main() async {
  logger.v('Starting app');

  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  initJobs();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: initialRoute,
      routes: routes,
      navigatorKey: NavigationService.navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
