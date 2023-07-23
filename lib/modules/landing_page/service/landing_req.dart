import 'package:take_it_easy/auth/google_auth.dart';
import 'package:take_it_easy/webservice/http_manager/http_manager.dart';

class LandingReq extends HttpManager with FlutterAuth {
  Future<bool> isGSignIn() async {
    return GoogleAuthService().isSignInGoogle();
  }
}
