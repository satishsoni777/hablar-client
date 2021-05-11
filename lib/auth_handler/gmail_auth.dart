import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/navigation/routes.dart';
import 'package:take_it_easy/storage/shared_storage.dart';

class GmailAuth {
  bool _isUserSignedIn = false;
  FirebaseAuth _auth;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<bool> handleSignIn() async {
    _auth = FirebaseAuth.instance;
    // hold the instance of the authenticated user
    User user; // flag to check whether we're signed in already
    bool isSignedIn = await _googleSignIn.isSignedIn();
    if (isSignedIn) {
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
      _isUserSignedIn = true;
    }
    await DI.inject<SharedStorage>().setUserData(user);
    await DI.inject<SharedStorage>().setInitialRoute(route: Routes.home);
    return _isUserSignedIn;
  }
}
