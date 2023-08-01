import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:take_it_easy/app.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/utils/flovor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runZonedGuarded(() async {
    try {
      if (Platform.isAndroid) await Firebase.initializeApp();
      DI.initializeDependencies();
      Flavor.internal().setFlavor(Enviroment.AWS);
    } catch (e) {
      print(e);
    }
    runApp(MyApp());
  }, (o, e) {});
}
