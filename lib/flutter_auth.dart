import 'package:flutter/material.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/navigation/routes.dart';
import 'package:take_it_easy/resources/app_keys.dart';
import 'package:take_it_easy/storage/shared_storage.dart';

import 'auth/google_auth.dart';

mixin FlutterAtuh {
  Future<void> logOut() async {
    final GoogleAuthService googleAuthService = GoogleAuthService();
    await DI.inject<SharedStorage>().resetFlow();
    await googleAuthService.signOut();
    Navigator.popUntil(navigatorKey.currentContext!, (route) => false);
    Navigator.pushNamed(navigatorKey.currentContext!, Routes.auth);
  }
}
