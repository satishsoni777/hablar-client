import 'package:flutter/material.dart';
import 'package:take_it_easy/auth/google_auth.dart';
import 'package:take_it_easy/components/loader.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/modules/signin/model/gmail_user_data.dart';
import 'package:take_it_easy/modules/signin/service/authentication.dart';
import 'package:take_it_easy/navigation/navigation_manager.dart';
import 'package:take_it_easy/navigation/routes.dart';

class AuthController extends ChangeNotifier {
  final Authentication _authentication = DI.inject<Authentication>();
  Future<void> login() async {
    DI.inject<Authentication>().varifyOTP("");
  }

  Future<void> gLogin() async {
    AppLoader.showLoader();
    try {
      final UserData? res = await _authentication.login();
      if (res != null) NavigationManager.pushReplacementNamed(Routes.home);
    } catch (_) {
      print(_);
    }
    AppLoader.hideLoader();
  }

  Future<void> sendOtp(String n) async {
    await GoogleAuthService().sendOtp(n);
    notifyListeners();
  }
}
