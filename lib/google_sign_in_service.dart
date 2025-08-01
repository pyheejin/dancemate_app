import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 1. authenticate() 메서드를 사용하여 GoogleSignInAccount 객체를 얻습니다.
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth =
          googleSignInAccount.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        // accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: $e");
      return null;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
