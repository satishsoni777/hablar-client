import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:take_it_easy/auth/google_auth.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/modules/signin/model/gmail_user_data.dart';
import 'package:take_it_easy/resources/strings/app_strings.dart';
import 'package:take_it_easy/storage/shared_storage.dart';
import 'package:take_it_easy/webservice/http_manager/http_manager.dart';

enum AuthType { Gmail, Facebook }

abstract class Authentication {
  Future<UserData?> login({AuthType authType});
  Future<void> varifyOTP(String otp, {String? verificationId});
}

class AuthenticationImpl extends HttpManager implements Authentication {
  final SharedStorage _pref = DI.inject<SharedStorage>();
  Future<void> varifyOTP(String otp, {String? verificationId}) async {
    final PhoneAuthCredential gAuth = await GoogleAuthService().varifyOTP(otp);
    await _pref.setStringPreference(StorageKey.token, gAuth.accessToken ?? '');
  }

  @override
  Future<UserData?> login({AuthType authType = AuthType.Gmail}) async {
    switch (authType) {
      case AuthType.Gmail:
        try {
          final GoogleSignInAccount? res = await GoogleAuthService().handleSignIn();
          final UserData? user = await _signIn(res);
          return user;
        } catch (_) {
          print(_);
          throw _;
        }
      case AuthType.Facebook:
        break;
      // return fLogin();
    }
    return null;
  }

  Future<bool> fLogin() async {
    final res = await GoogleAuthService().handleSignIn();
    return true;
  }

  Future<UserData> _signIn(GoogleSignInAccount? user) async {
    try {
      final Map<String, dynamic> req = <String, dynamic>{
        "displayName": user?.displayName,
        "emailId": user?.email,
        "authType": "GMAIL",
        "image": user?.photoUrl,
        "google_id": user?.id,
      };
      final Response<dynamic> res = await sendRequest(HttpMethod.POST, endPoint: Endpoints.sigin, request: req);
      req["userId"] = res.data["userId"];
      req["gender"] = res.data["gender"];
      req["isNewUser"] = res.data?["isNewUser"] ?? false;
      await _pref
        ..setUserData(req)
        ..setToken(res.data["token"].toString())
        ..setNewUser(req["isNewUser"]?.toString() ?? "false");
      return _pref.getUserData();
    } catch (e) {
      throw e;
    }
  }
}
