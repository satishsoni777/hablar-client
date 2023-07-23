import 'package:flutter/material.dart';
import 'package:take_it_easy/navigation/navigation_manager.dart';
import 'package:take_it_easy/navigation/routes.dart';
import 'package:take_it_easy/style/theme/app_theme.dart';

class MyApp extends StatefulWidget {
  const MyApp();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RTC',
      theme: AppTheme.getTheme,
      navigatorKey: NavigationManager.navigationKey,
      home: Routes.getLandingPage(),
      onGenerateRoute: (RouteSettings s) => Routes.onGenerateRoute(s),
    );
  }
}
