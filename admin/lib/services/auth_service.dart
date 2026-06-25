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
      throw AdminException(_friendlyMessage(e), cause: e);
    }
  }

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AdminException(_friendlyMessage(e), cause: e);
    }
  }

  Future<void> signOut() => _auth.signOut();

  /// Maps Firebase auth error codes to short, user-facing messages.
  String _friendlyMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'That email address looks invalid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again in a moment.';
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      case 'popup-closed-by-user':
      case 'cancelled-popup-request':
        return 'Sign-in was cancelled.';
      default:
        return e.message ?? 'Sign-in failed.';
    }
  }
}
