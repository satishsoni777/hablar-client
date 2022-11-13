import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/navigation/routes.dart';
import 'package:take_it_easy/storage/shared_storage.dart';

class GoogleAuthService {
  bool _isUserSignedIn = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<bool> handleSignIn() async {
    // hold the instance of the authenticated user
    User user; // flag to check whether we're signed in already
    bool isSignedIn = await _googleSignIn.isSignedIn();
    if (isSignedIn && _auth.currentUser != null) {
      // if so, return the current user
      user = _auth.currentUser;
      _isUserSignedIn = isSignedIn;
    } else {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser
          .authentication; // get the credentials to (access / id token)
      // to sign in via Firebase Authentication
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      user = (await _auth.signInWithCredential(credential)).user;
      if (user == null)
        _isUserSignedIn = false;
      else
        _isUserSignedIn = true;
    }
    if (_isUserSignedIn) {
      await DI.inject<SharedStorage>().setUserData(user);
      await DI.inject<SharedStorage>().setInitialRoute(route: Routes.home);
    } else {
      await DI.inject<SharedStorage>().setInitialRoute(route: '');
    }
    return _isUserSignedIn;
  }

  signOut() async {
    final result = await _googleSignIn.signOut();
    await result.clearAuthCache();
    await _auth.signOut();
  }

  Future<bool> isSignInGoogle() async {
    return await _googleSignIn.isSignedIn();
  }
}
