import 'package:flutter/material.dart';
import 'package:take_it_easy/auth/google_auth.dart';
import 'package:take_it_easy/components/loader.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/modules/signin/service/authentication.dart';
import 'package:take_it_easy/navigation/routes.dart';
import 'package:take_it_easy/resources/app_keys.dart';

class AuthController extends ChangeNotifier {
  bool isLoading = false;
  Future<void> login() async {
    DI.inject<Authentication>().varifyOTP("");
  }

  Future<void> gLogin() async {
    AppLoader.showLoader();
    isLoading = true;
    final bool res = await DI.inject<Authentication>().gLogin();
    if (res) {
      Navigator.pushReplacementNamed(navigatorKey.currentContext!, Routes.home);
    }
    isLoading = false;
  }

  Future<void> sendOtp(String n) async {
    await GoogleAuthService().sendOtp(n);
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      AppLoader.showLoader();
      GoogleAuthService().logout();
      AppLoader.hideLoader();
    } catch (_) {
      AppLoader.hideLoader();
    }
  }
}
