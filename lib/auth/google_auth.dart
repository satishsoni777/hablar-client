import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/navigation/routes.dart';
import 'package:take_it_easy/storage/shared_storage.dart';

class GoogleAuthService {
  GoogleAuthService._internal();
  factory GoogleAuthService() {
    return _singleton;
  }
  bool _isUserSignedIn = false;
  static String id = "";
  static final GoogleAuthService _singleton = GoogleAuthService._internal();
  final SharedStorage _sharedStorage = DI.inject<SharedStorage>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<GoogleSignInAccount?> handleSignIn() async {
    GoogleSignInAccount? googleUser;
    // hold the instance of the authenticated user
    User? user; // flag to check whether we're signed in already
    await _googleSignIn.signOut();
    bool isSignedIn = await _googleSignIn.isSignedIn();
    if (isSignedIn && _auth.currentUser != null) {
      // if so, return the current user
      user = _auth.currentUser!;
      _isUserSignedIn = isSignedIn;
    } else {
      try {
        googleUser = await _googleSignIn.signIn();
      } catch (_) {}
      if (googleUser == null)
        return null;
      else {
        _isUserSignedIn = true;
      }
      // final GoogleSignInAuthentication googleAuth = await googleUser.authentication; // get the credentials to (access / id token)
      // // to sign in via Firebase Authentication
      // final AuthCredential credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      // // user = (await _auth.signInWithCustomToken("asdadasdada789DISJHJKDAFSLD")).user!;
      // user = (await _auth.signInWithCredential(credential)).user!;
      // if (user == null)
      //   _isUserSignedIn = false;
      // else
      //   _isUserSignedIn = true;
    }
    if (_isUserSignedIn) {
      await _sharedStorage.setInitialRoute(route: Routes.home);
    } else {
      await _sharedStorage.setInitialRoute(route: Routes.landingPage);
    }
    return googleUser;
  }

  Future<dynamic> facebookLogin() async {}

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

  Future<bool> logout() async {
    final GoogleSignInAccount? result = await _googleSignIn.signOut();
    await result?.clearAuthCache();
    await _auth.signOut();
    return true;
  }

  Future<bool> isSignInGoogle() async {
    final res = await _googleSignIn.isSignedIn();
    print("res, $res");
    return res;
  }
}

// ignore: camel_case_types
enum OTP_STATUS { SENT, FAILED }
