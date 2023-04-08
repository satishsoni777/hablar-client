import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/navigation/routes.dart';
import 'package:take_it_easy/resources/app_keys.dart';
import 'package:take_it_easy/storage/shared_storage.dart';

class GoogleAuthService {
  bool _isUserSignedIn = false;
  static String id = "";
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<bool> handleSignIn() async {
    // hold the instance of the authenticated user
    User user; // flag to check whether we're signed in already
    bool isSignedIn = await _googleSignIn.isSignedIn();
    if (isSignedIn && _auth.currentUser != null) {
      // if so, return the current user
      user = _auth.currentUser!;
      _isUserSignedIn = isSignedIn;
    } else {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication; // get the credentials to (access / id token)
      // to sign in via Firebase Authentication
      final AuthCredential credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      user = (await _auth.signInWithCredential(credential)).user!;
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

  Future<void> sendOtp(String number, {Function(OTP_STATUS)? callback}) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91 $number',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        callback?.call(OTP_STATUS.FAILED);
      },
      codeSent: (String verificationId, int? resendToken) {
        id = verificationId;
        callback?.call(OTP_STATUS.SENT);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<PhoneAuthCredential> varifyOTP(String smsCode) async {
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: id, smsCode: smsCode);
    return credential;
  }

  Future<bool> signOut() async {
    final result = await _googleSignIn.signOut();
    result?.clearAuthCache();
    await _auth.signOut();
    navigatorKey.currentState?.popUntil((route) => false);
    return true;
  }

  Future<bool> isSignInGoogle() async {
    return await _googleSignIn.isSignedIn();
  }
}

// ignore: camel_case_types
enum OTP_STATUS {
  SENT,
  FAILED
}
