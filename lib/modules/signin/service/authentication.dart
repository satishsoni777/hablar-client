import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:take_it_easy/auth/google_auth.dart';
import 'package:take_it_easy/components/app_alert.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/modules/signin/view/gender_popup.dart';
import 'package:take_it_easy/resources/strings/app_strings.dart';
import 'package:take_it_easy/storage/shared_storage.dart';
import 'package:take_it_easy/webservice/http_manager/http_manager.dart';

enum AuthType { Gmail, Facebook }

abstract class Authentication {
  Future<bool> gLogin({AuthType authType});
  Future<void> varifyOTP(String otp, {String? verificationId});
}

class AuthenticationImpl extends HttpManager implements Authentication {
  Future<void> varifyOTP(String otp, {String? verificationId}) async {
    final gAuth = await GoogleAuthService().varifyOTP(otp);
    await DI.inject<SharedStorage>().setStringPreference(StorageKey.token, gAuth.accessToken ?? '');
  }

  @override
  Future<bool> gLogin({AuthType authType = AuthType.Gmail}) async {
    final String? gender = await DialogHelper.showCommonDialog(child: GenderSelection());
    if (gender == null) return false;
    switch (authType) {
      case AuthType.Gmail:
        try {
          final User? res = await GoogleAuthService().handleSignIn();
          final dynamic user = await _signIn(res, gender);
          if (user != null)
            return true;
          else
            return false;
        } catch (_) {
          throw _;
        }
      case AuthType.Facebook:
        return fLogin();
    }
  }

  Future<bool> fLogin() async {
    final User? res = await GoogleAuthService().handleSignIn();
    return true;
  }

  Future<dynamic> _signIn(User? user, String gender) async {
    try {
      final Map<String, dynamic> req = <String, dynamic>{
        "displayName": user?.displayName,
        "emailId": user?.email,
        "state": "Jharkhand",
        "pin": 828202,
        "authType": "GMAIL",
        "mobileNumber": user?.phoneNumber,
        "gender": gender,
        "photoURL": user?.photoURL,
        "emailVerified": user?.emailVerified ?? false
      };
      final Response<dynamic> res = await sendRequest(HttpMethod.POST, endPoint: Endpoints.sigin, request: req);
      req["userId"] = res.data["userId"];
      await DI.inject<SharedStorage>().setUserData(req);
      DI.inject<SharedStorage>().setToken(res.data["token"].toString());
      return res;
    } catch (e) {
      throw e;
    }
  }
}
