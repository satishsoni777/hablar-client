import 'package:take_it_easy/modules/landing_page/service/landing_req.dart';

abstract class LandingRepo {
  Future<bool> isSignIn();
}

class LandingRepoImpl extends LandingRepo {
  final LandingReq landingRepo = LandingReq();
  @override
  Future<bool> isSignIn() async {
    return await landingRepo.isSignIn();
  }
}
