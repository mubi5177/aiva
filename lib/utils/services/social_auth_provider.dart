import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

enum AuthStatus {
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
  authenticateException,
  authenticateCanceled,
}

enum SocialLogins {
  google,
  apple,
}

class SocialAuthProvider extends ChangeNotifier {

  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;

  AuthStatus _status = AuthStatus.uninitialized;
  AuthStatus get status => _status;

  User? _currentUser;
  User? get currentUser => _currentUser;

  SocialAuthProvider({
    required this.firebaseAuth,
    required this.googleSignIn,
  }){
    firebaseAuth.authStateChanges().listen((User? user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  Future<void> handleSocialSignIn(SocialLogins social) async {
    switch(social){
      case SocialLogins.google:
        await handleGoogleSignIn();
        break;
      case SocialLogins.apple:
        await handleAppleSignIn();
        break;
    }
  }

  Future<bool> handleGoogleSignIn() async {
    _setStatus(AuthStatus.authenticating);
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      _setStatus(AuthStatus.authenticateCanceled);
      return false;
    }

    GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    User? firebaseUser;
    try {
      firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;
    } catch (error, stacktrace) {
      debugPrint('Authentication Error : $error\n$stacktrace');
      _setStatus(AuthStatus.authenticateError);
      return false;
    }

    if (firebaseUser == null){
      _setStatus(AuthStatus.authenticateError);
      return false;
    }

    _currentUser = firebaseUser;
    _setStatus(AuthStatus.authenticated);
    return true;
  }

  Future<bool> handleAppleSignIn() async {
    /*
    * Note : Normally Apple sign-in isn't used in Android, but to enable Apple sign-in in Android, you need to do some steps.
    * see here : https://firebase.google.com/docs/auth/android/apple?hl=ko#join-the-apple-developer-program
    * */
    _setStatus(AuthStatus.authenticating);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    User? firebaseUser;
    try{
      firebaseUser = (await firebaseAuth.signInWithCredential(oauthCredential)).user;
    } catch (error, stacktrace) {
      debugPrint('Authentication Error : $error\n$stacktrace');
      _setStatus(AuthStatus.authenticateError);
      return false;
    }

    if (firebaseUser == null){
      _setStatus(AuthStatus.authenticateError);
      return false;
    }

    _currentUser = firebaseUser;
    _setStatus(_status = AuthStatus.authenticated);
    return true;
  }

  Future<void> handleSignOut() async {
    await firebaseAuth.signOut();
    // Note: Do this to prevent google sign-in from automatically selecting the previous account.
    // See also : https://stackoverflow.com/a/73552210/16626322
    if(await googleSignIn.isSignedIn()){
      await googleSignIn.disconnect();
      await googleSignIn.signOut();
    }

    _currentUser = null;
    _setStatus(AuthStatus.uninitialized);
  }

  void _setStatus(AuthStatus status){
    _status = status;
    notifyListeners();
  }

}


