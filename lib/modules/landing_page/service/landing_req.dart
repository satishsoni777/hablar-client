import 'package:take_it_easy/auth/google_auth.dart';
import 'package:take_it_easy/webservice/http_manager/http_manager.dart';

class LandingReq extends HttpManager with FlutterAuth {
  Future<bool> isSignIn() async {
    return GoogleAuthService().isSignInGoogle();
  }

  Future<bool> logOut() async {
    try {
      return logout();
    } catch (_) {}
    return true;
  }
}
