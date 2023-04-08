import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:take_it_easy/app.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/utils/flovor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runZonedGuarded(() async {
    try {
      Flavor.internal().setFlavor(Enviroment.RENDER);
      await Firebase.initializeApp();
      DI.initializeDependencies();
    } catch (e) {
      print(e);
    }
    runApp(MyApp());
  }, (o, e) {});
}

// ignore: must_be_immutable
