import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/navigation/routes.dart';
import 'package:take_it_easy/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runZonedGuarded(() async {
    await Firebase.initializeApp();
    DI.initializeDependencies();
    final r = await Routes.initialRoute;
    runApp(MyApp(r));
  }, (o, e) {});
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  MyApp(this.initialRoute);
  String initialRoute;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.getTheme,
      initialRoute: widget.initialRoute,
      routes: Routes.getRoutes(),
      onGenerateRoute: (s) => Routes.onGenerateRoute(s),
      // onUnknownRoute:(r)=>Routes.onUnknownRoute(r)
    );
  }
}
