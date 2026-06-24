import 'package:firebase_auth/firebase_auth.dart';

import '../core/exceptions.dart';

/// Thin wrapper over Firebase Auth for the web admin. Uses Google sign-in via
/// the browser popup flow (no `google_sign_in` plugin needed on web).
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithGoogle() async {
    try {
      final provider = GoogleAuthProvider()
        ..setCustomParameters({'prompt': 'select_account'});
      return await _auth.signInWithPopup(provider);
    } on FirebaseAuthException catch (e) {
      throw AdminException(e.message ?? 'Sign-in failed', cause: e);
    }
  }

  Future<void> signOut() => _auth.signOut();
}
