import 'package:take_it_easy/modules/landing_page/service/landing_req.dart';

abstract class LandingRepo {
  Future<bool> isSignIn();
  Future<bool> logOut();
}

class LandingRepoImpl extends LandingRepo {
  final LandingReq landingRepo = LandingReq();
  @override
  Future<bool> isSignIn() async {
    return await landingRepo.isSignIn();
  }
  
  @override
  Future<bool> logOut() async{
    return await landingRepo.logOut();
  }
}
