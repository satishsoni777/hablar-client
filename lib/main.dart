import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/modules/authentication/webservice/gmail_auth.dart';
import 'package:take_it_easy/navigation/routes.dart';
import 'package:take_it_easy/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runZonedGuarded(() async {
    String route;
    try {
      await Firebase.initializeApp();
      DI.initializeDependencies();
      await GmailAuth().handleSignIn();
      route = await Routes.initialRoute;
    } catch (e) {
      print(e);
      route = Routes.auth;
    }
    runApp(MyApp(route));
  }, (o, e) {});
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  const MyApp(this.initialRoute);
  final String initialRoute;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RTC',
      theme: AppTheme.getTheme,
      initialRoute: widget.initialRoute,
      routes: Routes.getRoutes(),
      onGenerateRoute: (s) => Routes.onGenerateRoute(s),
      // onUnknownRoute:(r)=>Routes.onUnknownRoute(r)
    );
  }
}
