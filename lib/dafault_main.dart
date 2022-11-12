import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:take_it_easy/app.dart';
import 'package:take_it_easy/di/di_initializer.dart';

void runKaruna() async {
  WidgetsFlutterBinding.ensureInitialized();
  runZonedGuarded(() async {
    try {
      await Firebase.initializeApp();
      DI.initializeDependencies();
    } catch (e) {
      print(e);
    }
    runApp(MyApp());
  }, (o, e) {});
}