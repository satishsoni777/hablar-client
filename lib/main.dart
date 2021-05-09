import 'package:flutter/material.dart';
import 'package:take_it_easy/navigation/routes.dart';
import 'package:take_it_easy/theme/app_theme.dart';
import 'modules/authentication/auth.dart';

void main() async{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.getTheme,
      home: Authentication(),
      routes: Routes.getRoutes(),
    );
  }
}
