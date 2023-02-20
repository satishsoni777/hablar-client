import 'package:take_it_easy/webservice/base_request.dart';

class LandingReq extends BaseRequest {
  Future<bool> isSignIn() async {
    return await this.isSignInGoogle();
  }
  Future<bool> logOut()async{
    return await this.signOut();
  }
}
