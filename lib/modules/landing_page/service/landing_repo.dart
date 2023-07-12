import 'package:take_it_easy/components/loader.dart';
import 'package:take_it_easy/modules/landing_page/service/landing_req.dart';
import 'package:take_it_easy/navigation/routes.dart';
import 'package:take_it_easy/resources/app_keys.dart';

abstract class LandingRepo {
  Future<bool> isSignIn();
  Future<bool> logOut();
}

class LandingRepoImpl extends LandingRepo {
  final LandingReq landingRepo = LandingReq();
  @override
  Future<bool> isSignIn() async {
    return landingRepo.isSignIn();
  }

  @override
  Future<bool> logOut() async {
    try {
      AppLoader.showLoader();
      await landingRepo.logOut();
    } catch (_) {}
    AppLoader.showLoader();
    navigatorKey.currentState?.pushReplacementNamed(Routes.root).then((value) => null);
    return true;
  }
}
