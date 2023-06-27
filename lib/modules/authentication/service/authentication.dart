import 'package:take_it_easy/auth/google_auth.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/storage/shared_storage.dart';
import 'package:take_it_easy/webservice/http_manager/http_manager.dart';

abstract class Authentication {
  Future<void> gLogin();
  Future<void> varifyOTP(String otp, {String? verificationId});
}

class AuthenticationImpl extends HttpManager implements Authentication {
  Future<void> varifyOTP(String otp, {String? verificationId}) async {
    final gAuth = await GoogleAuthService().varifyOTP(otp);
    await DI.inject<SharedStorage>().setStringPreference(StorageKey.token, gAuth.accessToken ?? '');
  }

  @override
  Future<bool> gLogin() async {
    try {
      return GoogleAuthService().handleSignIn();
    } catch (_) {
      throw _;
    }
  }
}
