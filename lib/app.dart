import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_it_easy/modules/landing_page/landing_bloc/landing_page_bloc.dart';
import 'package:take_it_easy/modules/landing_page/landing_page.dart';
import 'package:take_it_easy/navigation/navigation_manager.dart';
import 'package:take_it_easy/navigation/routes.dart';
import 'package:take_it_easy/resources/app_keys.dart';
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
      // routes: Routes.getRoutes(),
      home: Routes.getLandingPage(),
      onGenerateRoute: (s) => Routes.onGenerateRoute(s),
    );
  }
}
