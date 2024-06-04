import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginGoogleUtils {
  static const String TAG = "LoginGoogleUtils";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    log("$TAG signInWithGoogle() init...");

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        log("$TAG signInWithGoogle() cancelled by user");
        return null;
      }

      log("$TAG signInWithGoogle() googleUserEmail -> ${googleSignInAccount.email}");

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User user = userCredential.user!;

      return await _isCurrentSignIn(user);
    } catch (e) {
      log("$TAG signInWithGoogle() error -> $e");
      return null;
    }
  }

  Future<User?> _isCurrentSignIn(User user) async {
    if (user != null) {
      assert(await user.getIdToken() != null);
      final User currentUser = _auth.currentUser!;
      assert(user.uid == currentUser.uid);
      log("$TAG signInWithGoogle() success -> ${user.toString()}");
      return user;
    }
    return null;
  }
}
