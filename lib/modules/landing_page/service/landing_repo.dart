import 'package:take_it_easy/auth/google_auth.dart';
import 'package:take_it_easy/components/loader.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/modules/landing_page/service/landing_req.dart';
import 'package:take_it_easy/storage/shared_storage.dart';

abstract class LandingRepo {
  Future<bool> isSignIn();
  Future<bool> logout();
}

class LandingRepoImpl extends LandingRepo {
  final LandingReq landingRepo = LandingReq();
  final SharedStorage _sharedStorage = DI.inject<SharedStorage>();
  @override
  Future<bool> isSignIn() async {
    final bool res = await landingRepo.isGSignIn();
    if (await _sharedStorage.isSignIn()) {
      return true;
    } else if (res && !(await _sharedStorage.isSignIn())) {
      await logout();
      return false;
    } else {
      logout();
      return false;
    }
  }

  @override
  Future<bool> logout() async {
    AppLoader.showLoader();
    try {
      AppLoader.showLoader();
      await GoogleAuthService().logout();
      await _sharedStorage.logout();
    } catch (_) {}
    AppLoader.hideLoader();
    return true;
  }
}
