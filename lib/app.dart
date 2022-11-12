
import 'package:flutter/material.dart';
import 'package:take_it_easy/navigation/routes.dart';
import 'package:take_it_easy/resources/app_keys.dart';
import 'package:take_it_easy/theme/app_theme.dart';
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
      navigatorKey: navigatorKey,
      initialRoute: Routes.landingPage,
      routes: Routes.getRoutes(),
      onGenerateRoute: (s) => Routes.onGenerateRoute(s),
      // onUnknownRoute:(r)=>Routes.onUnknownRoute(r)
    );
  }
}
