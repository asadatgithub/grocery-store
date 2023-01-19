import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInAPI {
  static final googleSignIn = GoogleSignIn();
  static Future<GoogleSignInAccount?> login() {
    return googleSignIn.signIn();
  }

  void logout() {
    googleSignIn.signOut();
  }
}
