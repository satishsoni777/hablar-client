import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:take_it_easy/di/di.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/navigation/routes.dart';
import 'package:take_it_easy/resources/app_keys.dart';
import 'package:take_it_easy/storage/shared_storage.dart';

mixin FlutterAtuh {
  Future<void> logOut() async {
    final result = await DI.inject<SharedStorage>().resetFlow();
    Navigator.popUntil(navigatorKey.currentContext, (route) => false);
    Navigator.pushNamed(navigatorKey.currentContext, Routes.auth);
  }
}
